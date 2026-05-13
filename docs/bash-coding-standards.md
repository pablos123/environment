# Bash Coding Standards

A style guide for Bash scripts. The rules apply to any file that begins with `#!/usr/bin/env bash`.

The guiding principle: prefer Bash builtins and explicit structure over external tools and clever shortcuts. Scripts should read top-down, failure modes should be obvious, and the same shape should repeat everywhere.

---

## Script example

```bash
#!/usr/bin/env bash

# Battery low notification

set -Eeuo pipefail

source "lib/helpers.bash"

require_commands upower notify-send

declare -ri CRITICAL_THRESHOLD=10
declare -ri LOW_THRESHOLD=15

function is_battery {
    local data="$1"

    local -a fields
    mapfile -t fields < <(awk '/present:|model:|rechargeable:|voltage:/{print $2}' <<<"${data}")

    if ((${#fields[@]} != 4)); then
        return 1
    fi

    local field
    for field in "${fields[@]}"; do
        if [[ -z "${field}" ]]; then
            return 1
        fi
    done

    return 0
}

function notify_for_battery {
    local battery="$1"

    local battery_data
    battery_data="$(upower --show-info "${battery}")"

    if ! is_battery "${battery_data}"; then
        return 0
    fi

    local -a fields
    mapfile -t fields < <(awk '/model:|state:|percentage:/{print $2}' <<<"${battery_data}")

    local model="${fields[0]}"
    local state="${fields[1]}"
    local -i percentage="${fields[2]//%/}"

    if [[ "${state}" != "discharging" ]]; then
        return 0
    fi

    if ((percentage < CRITICAL_THRESHOLD)); then
        notify-send --urgency critical --expire-time 10000 "CRITICAL BATTERY: ${model}"
    elif ((percentage < LOW_THRESHOLD)); then
        notify-send --urgency critical --expire-time 10000 "LOW BATTERY: ${model}"
    fi
}

function main {
    local -a batteries
    mapfile -t batteries < <(upower --enumerate)

    local battery
    for battery in "${batteries[@]}"; do
        notify_for_battery "${battery}"
    done
}

main "$@"
```

This example exercises most of the rules in this document; the sections below refer back to it.

---

## Anatomy of a script

Every script follows the same fixed top-down order. No deviations. The strict header order, top to bottom:

1. **Shebang.** `#!/usr/bin/env bash` locates Bash via `PATH` rather than hardcoding `/bin/bash`.
2. **Header comment.** A single one-line `#` comment naming what the file is. Required for every script and library; no exceptions. A second short line is permitted only when there is genuine context the reader cannot infer from the code (e.g., "Run as root.", "Sourced by interactive shells; no strict mode."). Two lines maximum.
3. **`set -Eeuo pipefail`.** Fail on errors (`-e`), unset variables (`-u`), and pipeline failures (`pipefail`). `-E` propagates the `ERR` trap into functions and subshells.
4. **`source` the helpers.** Always `source`, never `.`.
5. **`require_commands`.** Verify external dependencies before any setup work runs.
6. **File-scope declarations.** `declare -r` constants in UPPERCASE.
7. **Function definitions.** Helpers first, then `main`.
8. **`main "$@"`.** The last line of the file.

Each section is separated by a blank line. Sections that don't apply (a three-line wrapper has no declarations) are omitted; the relative order of the others is preserved.

---

## Comments

Default to no comment. Well-named functions and variables make most prose redundant. Add a comment only when the *why* is non-obvious — a workaround, an external constraint, a subtle invariant, or behavior that would surprise.

Avoid:

- Restating what the code does (`# Iterate over the array` above a `for` loop).
- Multi-line essays and `# ---` borders.
- Structural-label dividers (`# Constants`, `# Functions`, `# main`) — `declare -r` is obviously constants, `function` is obviously functions.
- Operation labels above a block (`# Docker`, `# Networking`, `# Cleanup`) — the code below is the documentation.
- Section dividers — they add nothing.

`# shellcheck disable=SCxxxx` directives carry a one-line justification on the same line:

```bash
# shellcheck disable=SC2154  # VERSION_CODENAME is defined by /etc/os-release
```

---

## Naming

Names must convey meaning. `battery`, `percentage`, `fields`, `entry` — not `b`, `pct`, `fld`, `e`. Short conventional names for trivial loop variables (`i` for a numeric index, `f` for a one-line file iteration) remain acceptable; abbreviations of domain words do not.

- **Executable scripts** (in `bin/`): no extension; kebab-case.
- **Sourced bash libraries**: `.bash` extension; snake_case.
- **Function names**: snake_case.
- **Variables**: lowercase for locals, function-internal state, and loop variables; UPPERCASE for `declare -r` configuration, exported variables, and anything that mirrors the shell environment.

The reason for the variable casing is collision avoidance: the shell environment (`HOME`, `PATH`, `UID`, `EDITOR`, `XDG_*`, …) is uppercase. Uppercase locals risk shadowing them; lowercase locals cannot.

---

## Control flow

Use explicit conditionals — `if/then/fi`. Do not chain commands with `&&` or `||` to express branching.

```bash
if ! command -v upower >/dev/null; then
    die "upower not found"
fi

if [[ ! -d "${dir}" ]]; then
    continue
fi

if ! pkill old-daemon; then
    :
fi
```

Branches become greppable, indentation reflects control flow, and the failure response (`die`, `continue`, `return 0`) reads like prose rather than being tucked at the end of a chain. The third form — `if ! cmd; then :; fi` — is the explicit "swallow failure" idiom, replacing `cmd || true`.

`if cmd; then` also suspends `set -e` for `cmd`. That is documented bash semantics for any test position; the suspension is intentional behavior, not an oversight.

The rule applies to **command-level** control flow only. It does not apply to:

- Parameter expansion defaults: `${var:-default}` — this is an expansion, not control flow.
- Operators *inside* `[[ ]]`: `[[ -n "${a}" && -n "${b}" ]]` is a single test, not a chain.

---

## Variable declarations

### Type flags

Every `local` and file-scope constant carries the appropriate type flag:

| Kind | Local | Constant |
|---|---|---|
| Integer | `local -i n` | `declare -ri N` |
| Indexed array | `local -a items` | `declare -ra ITEMS` |
| Associative array | `local -A by_id` | `declare -rA BY_ID` |
| Read-only inside a function | `local -r const` | n/a |
| Nameref (alias to another var) | `local -n ref="$1"` | n/a |
| String / general | `local s` | `declare -r S` |

Always use `declare -r` for file-scope constants — never `readonly`. `readonly -i` is invalid (the `readonly` builtin accepts only `-aAf`), so mixing forces `readonly` for strings and `declare -r{i,a,A}` for everything typed. One keyword across all types avoids the trap.

Bash has no string type, so plain `local` *is* the typed form for strings.

`local -i` evaluates assignments as arithmetic: `local -i x="2+3"` yields `5`. Non-numeric assignments become `0` — a useful safety net for "this must be a number" function arguments.

### Configuration block

Configuration constants go at the top of the script, after the header comment, as `declare -r` declarations:

```bash
declare -r SESSIONS_DIR="${HOME}/.config/sessions"
declare -ri CRITICAL_THRESHOLD=10
declare -ri LOW_THRESHOLD=15
```

This is the place to look when changing how a script behaves.

### Constants from command substitution

When a constant's value comes from a command, split the assignment from the `declare -r` so `set -e` can see the command's exit code:

```bash
TMP_FILE="$(mktemp --suffix=.png)"
declare -r TMP_FILE
```

`declare -r VAR=$(cmd)` always returns 0, because the `declare` builtin succeeds even when `cmd` fails — `set -e` cannot see through it. The two-line form lets the substitution's failure propagate, then makes the variable read-only.

---

## Function shape

Use the `function` keyword without parentheses:

```bash
function battery_notify {
    ...
}
```

Not `battery_notify()`, not `function battery_notify()`. The parentheses are redundant when `function` is present, and dropping them lets the keyword carry the meaning.

One `local` per variable, declared immediately above the line that defines it.

If the value is a plain expression — parameter expansion, literal, integer arithmetic, anything that cannot fail — declare and assign on one line:

```bash
local name="$1"
local dir="${2:-${HOME}}"
local -i count=0
local -a items=()
local model="${fields[0]}"
```

If the value comes from a command (`$(...)`, `mapfile`, `read`), split into two lines: declaration above, assignment below. The split lets `set -e` see the command's exit code:

```bash
local result
result="$(some_command)"

local -a items
mapfile -t items < <(find ...)
```

`local var=$(cmd)` always returns 0 because the `local` builtin succeeds even when `cmd` fails — the same root cause as the `declare -r` rule above.

When the `local` line is itself the definition (declare + assign on one line) and the variable is mutated in a later block, place the `local` immediately before that block. For an accumulator updated in a loop, that means just above the loop — above the loop's own `local`:

```bash
local -i count=0
local entry
for entry in "${items[@]}"; do
    ((count++))
done
```

For loops, every `for` gets its own `local` line directly above, including nested loops:

```bash
local entry
for entry in "${entries[@]}"; do
    local file
    for file in "${entry}"/*.txt; do
        ...
    done
done
```

`local` is function-scoped in bash, so re-running `local file` once per outer iteration is harmless. The uniform rule — one `local` per variable, immediately above its definition, no exceptions — is preferable to a special case for nested loops.

---

## `main` function

Every executable script defines a `main` function and ends with `main "$@"`. No exceptions, including three-line wrappers. The uniform shape buys three things:

- Arguments enter the script in exactly one place.
- Sourcing the file does not auto-execute it, which is useful for testing or for refactoring helpers out into a library.
- Every script has the same shape, eliminating the "is this the kind that has a main?" cognitive load.

Sourced libraries do not define `main` — their body *is* the init, and the rule's purpose (don't auto-execute on source) is moot for files whose only job is to be sourced.

---

## Exit and return

Functions `return`. Only `main` and `die` ever call `exit`.

- `die` is the explicit "abort the script" verb. It logs to stderr and exits non-zero.
- A helper that fails should `return 1`, or rely on `set -e` to propagate the failure of a command substitution or pipeline.
- `main` is the only place where a deliberate `exit N` (with a chosen code) belongs.

A function that calls `exit` cannot be safely composed: it cannot be called from `if helper; then …`, cannot be sourced for testing, cannot be reused. `return` keeps the function as a unit.

---

## Bash builtins over externals

Prefer Bash parameter expansion, here-strings, and arithmetic to forking external tools.

| Avoid | Prefer |
|---|---|
| `basename "${path}"` | `${path##*/}` |
| `basename "${path}" .ext` | `name="${path##*/}"; name="${name%.ext}"` |
| `dirname "${path}"` | `${path%/*}` |
| `tr -d '%'` (single chars) | `${var//%/}` |
| `tr 'a-z' 'A-Z'` | `${var^^}` |
| `tr 'A-Z' 'a-z'` | `${var,,}` |
| `echo "${var}" \| cmd` | `cmd <<<"${var}"` |
| `$(pwd)` | `${PWD}` |
| `~` (in scripts) | `${HOME}` |
| `[ ... ]` | `[[ ... ]]` |
| `expr "${a}" + "${b}"` | `((a + b))` |
| `for x in $(cmd)` | `mapfile -t arr < <(cmd); for x in "${arr[@]}"` |
| `. file.bash` | `source file.bash` |

When the builtin form is harder to read than the external — typically complex regex extraction — the external is fine. The rule is "prefer," not "exclusive." The `source` row is the one exception that *is* exclusive: never use `.` in a bash file.

---

## Long options over short

Prefer long options (`--option`) to short options (`-o`) wherever both exist. Long options read as prose at the call site, survive grep, and don't require a man-page lookup later.

Short options are acceptable when no long form exists: bash builtins (`mapfile -t`, `read -r`) and tools whose native syntax is single-dash multi-letter (`find -type f`, `find -maxdepth 1`).

---

## Quoting and tests

- Always brace expansions: `${var}`, not `$var`.
- Always quote expansions: `"${var}"`, not `${var}`. Exceptions: inside `[[ ... ]]` (right side of `=~`), inside `(( ... ))`, and where word-splitting is intentional (rare).
- Use `[[ ]]` for tests, never `[ ]`. `[[ ]]` does not word-split or glob, supports `=~` for regex, and accepts `&&` and `||` *inside* the test (a single test, not control-flow chaining).
- Use `(( ))` for arithmetic comparisons and assignments: `if ((count < 10)); then`, `((count++))`. Inside `(( ))`, variables are referenced without `$`.
- Do not use `[[ "${a}" -lt "${b}" ]]` for numeric comparison. `(( ))` is shorter, doesn't need quoting, and reads as math.

---

## Linting and formatting

Every script must:

- Pass `shfmt --diff` with no changes. Indentation is four spaces; `case` arms are indented under `case`.
- Pass `shellcheck --enable=all` with zero warnings. `--enable=all` turns on optional checks (`require-variable-braces`, `require-double-brackets`, `quote-safe-variables`, others) that align with the rules in this document and catch genuine bugs the rules do not address.

POSIX `sh` files use `shfmt --posix --indent=4`. `--posix` selects the dialect — shfmt cannot infer it from `#!/usr/bin/env sh` and would otherwise format as bash.

### Project-level shellcheck disables

Three checks are disabled at the repository level:

- **`SC2312`** — *command in pipeline masks return value.* Every script sets `set -o pipefail`, so pipeline failures already propagate. The warning is a false positive in this codebase.
- **`SC1091`** — *not following sourced file.* Static cross-file source-following is not worth the per-script `# shellcheck source=…` directive.
- **`SC2310`** — *function invoked in `if` / `while` / `until` condition disables `set -e`.* The control-flow rule (`if/then/fi` for all branching) means predicate functions are *always* called from test positions. The `set -e` suspension that fires there is documented bash semantics, not an oversight. Predicate functions in this codebase are written to be simple — no internal commands whose failure `set -e` would need to catch — so the warning is structural noise.

For everything else, suppress checks inline with `# shellcheck disable=SCxxxx` and a one-line justification. Do not silence checks at the file or repository level.
