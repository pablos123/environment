# Bash Coding Standards

Style guide for Bash scripts in this repository. All scripts in `bin/` and `lib/` with a `#!/usr/bin/env bash` shebang follow these rules.

**Scope.** These rules are bash-specific. POSIX `sh` files (currently `bin/shtatic`) are exempt — they should be POSIX-correct and pass `shellcheck --shell=sh`, but the bash idioms here (`local`, `[[ ]]`, `mapfile`, type flags, the `function` keyword) don't apply.

**Guiding principle:** prefer Bash builtins and explicit structure over external tools and clever shortcuts. Scripts should read top-down, failure modes should be obvious, and the same shape should repeat everywhere.

---

## 1. Script header

Every script follows the same fixed top-down order. No deviations.

```bash
#!/usr/bin/env bash

# Battery low notification

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands upower notify-send

declare -ri CRITICAL_THRESHOLD=10
declare -ri LOW_THRESHOLD=15

function helper_x { ... }
function main { ... }

main "$@"
```

The strict order, top to bottom:

1. **Shebang.** `#!/usr/bin/env bash` — locates Bash via `PATH` rather than hardcoding `/bin/bash`.
2. **Header comment.** **Required for every script and library, no exceptions.** A single one-line `#` comment naming what the file is. Add a second short line only when there's genuine context the reader can't infer (e.g., "Run as root.", "Sourced by interactive shells; no strict mode."). Two lines maximum. No `# ---` decoration around it — the blank line above and below is enough demarcation.
3. **`set -Eeuo pipefail`.** Fail on errors (`-e`), unset variables (`-u`), pipeline failures (`pipefail`), with `-E` propagating the `ERR` trap into functions and subshells.
4. **`source` the helpers.** Always `source` (never `.`) — bash's spelling, which makes "this is loading another file" visible at a glance.
5. **`require_commands`.** Verify external dependencies before any setup work runs (see §11).
6. **File-scope declarations.** `declare -r` constants in UPPERCASE (see §4).
7. **Function definitions.** Helpers first, then `main`.
8. **`main "$@"`.** The last line of the file.

Each section is separated by a blank line. Sections that don't apply (a 3-line wrapper has no declarations) are omitted; the relative order of the others stays the same.

### No structural-label dividers, no decoration

`# ---` / label / `# ---` blocks are forbidden everywhere — including around the header. Section dividers in particular add nothing:

```bash
# --------------------------------------------------
# Constants
# --------------------------------------------------

# --------------------------------------------------
# Functions
# --------------------------------------------------

# --------------------------------------------------
# Main
# --------------------------------------------------
```

`declare -r` lines are obviously constants, `function` lines are obviously functions, `function main` is obviously main. The label says nothing the code doesn't. Same for operation labels (`# Docker`, `# Networking`, `# Cleanup`) — if the block is short enough for a one-word label, the code is short enough to read directly; if it's long, extract a named function.

### When to comment

- **Default to no comment.** Well-named functions and variables make most prose redundant.
- Add a comment only when the **why** is non-obvious to a reader looking at the code: a workaround, an external constraint, a subtle invariant, behavior that would surprise. The `# Wait and re-check to avoid reacting to brief disconnects` line in `bin/monitors-config` is the canonical example — it adds information the code can't.
- Don't restate **what** the code does. `# Iterate over the array` above a `for` loop is noise.
- One- or two-line `# comment` next to the code it explains. No `# ---` borders, no multi-line essays.
- Inline `# shellcheck disable=SCxxxx` directives include a one-line justification on the same line (e.g., `# shellcheck disable=SC2154  # VERSION_CODENAME is defined by /etc/os-release`).

---

## 2. Function syntax

Use the `function` keyword without parentheses:

```bash
function battery_notify {
    ...
}
```

Not `battery_notify()` and not `function battery_notify()`. The parens are redundant when `function` is present, and dropping them makes the keyword carry the meaning.

---

## 3. Control flow: `if/then/fi`, never `&&` or `||`

Use explicit conditionals for control flow. Do not chain commands with `&&` or `||` to express branching.

```bash
# Yes
if ! command -v upower >/dev/null; then
    die "upower not found"
fi

if [[ ! -d "${dir}" ]]; then
    continue
fi

# No
command -v upower >/dev/null || die "upower not found"
[[ -d "${dir}" ]] || continue
```

Branches become greppable, indentation reflects control flow, and the failure response (`die`, `continue`, `return 0`) reads like prose rather than being tucked at the end of a chain. (Note: `if cmd; then` *also* suspends `set -e` for `cmd` — that's documented bash semantics for any test position. We accept the suspension because it's the intentional behavior; see §12 on `SC2310`.)

The rule applies to **command-level control flow**. It does not apply to:

- Parameter expansion defaults: `${var:-default}`, `${var:?error}` — these are expansions, not control flow.
- Operators *inside* `[[ ]]`: `[[ -n "${a}" && -n "${b}" ]]` is fine — that's a single test, not a chain.

---

## 4. Variable declarations

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

**Always use `declare -r` for file-scope constants — never `readonly`.** `readonly -i` is invalid (the `readonly` builtin accepts only `-aAf`), so mixing forces `readonly` for strings and `declare -r{i,a,A}` for everything typed. One keyword across all types avoids the trap.

Bash has no string type, so plain `local` *is* the typed form for strings.

`local -i` evaluates assignments as arithmetic: `local -i x="2+3"` yields `5`. Non-numeric assignments become `0` — a useful safety net for "this must be a number" function arguments.

### Naming

- **UPPERCASE** for `declare -r` configuration at the top of a script, exported variables, and anything that mirrors the shell environment.
- **lowercase** for locals, function-internal state, loop variables.

The reason is collision avoidance: the shell environment (`HOME`, `PATH`, `UID`, `EDITOR`, `XDG_*`, ...) is uppercase. Uppercase locals risk shadowing them; lowercase locals cannot.

### Configuration block

Configuration constants go at the top of the script, after the header comment, as `declare -r` declarations:

```bash
declare -r USER_SESSIONS_DIR="${HOME}/.config/kitty/sessions"
declare -r WORK_SESSIONS_DIR="${HOME}/repos/work/kitty-sessions"
declare -ri CRITICAL_THRESHOLD=10
declare -ri LOW_THRESHOLD=15
```

This is the place to look when changing how a script behaves.

---

## 5. Function shape

Every function reads top-to-bottom in three sections:

```bash
function example {
    # 1. Declarations — type-grouped, top of function.
    local name dir
    local -i count=0
    local -a items=()

    # 2. Args block — extract $1/$2/... immediately after declarations.
    name="$1"
    dir="${2:-${HOME}}"

    # 3. Logic — assignments at point of use; loop vars at the loop.
    if [[ ! -d "${dir}" ]]; then
        die "directory not found: ${dir}"
    fi

    mapfile -t items < <(find "${dir}" -maxdepth 1 -type f)

    local entry
    for entry in "${items[@]}"; do
        ((count++))
    done

    local first
    first="$(head --lines=1 "${dir}/.index")"
    log "${name}: ${count} files; index starts with '${first}'"
}
```

### Rules

1. **Declarations** at the top, grouped by type. Anything that cannot fail can ride on the declaration line — literal strings, integers, parameter-expansion defaults, empty arrays. Examples: `local name="default"`, `local -i count=0`, `local -a items=()`, `local target="${HOME}/foo"`. The only assignment that must be split off is command substitution (see below).
2. **Args extraction** in the block immediately after declarations. The function's "configuration."
3. **Command substitutions** are split-declared (`local var; var=$(cmd)`) and placed next to the code that uses the result.
4. **Loop variables** are declared on the line *immediately above* their `for`, never in the top declarations block. For nested loops, declare every loop variable of the nest in one `local` line just above the outermost `for`. Putting loop variables in the top block hides their scope and forces the reader to scroll to remember which `for` owns the name — declaring next to the loop makes the lifetime obvious.

   ```bash
   # Yes — loop var lives next to its for
   local entry file
   for entry in "${entries[@]}"; do
       for file in "${entry}"/*.txt; do
           ...
       done
   done

   # No — loop var hidden in the top block
   local entry file label dir
   ...
   for entry in "${entries[@]}"; do
       ...
   done
   ```

### Why split-declare command substitution

`local var=$(cmd)` always returns 0 because the `local` builtin succeeds even when `cmd` fails. `set -e` can't see through it. Splitting is the only way to let `set -e` propagate the substitution's failure:

```bash
local result
result="$(some_command)"   # set -e exits if some_command fails
```

Pairing the assignment with its consumer (rather than with the declaration block) keeps the failure adjacent to its context.

---

## 6. `main` function

Every **executable** script has a `main` function and ends with `main "$@"`. No exceptions, including three-line wrappers:

```bash
function main {
    exec firefox --private-window "$@"
}

main "$@"
```

Why uniformly:

- Arguments enter the script in exactly one place.
- Sourcing the file does not auto-execute it (useful for testing or refactoring helpers out into a lib).
- Every script has the same shape, eliminating the "is this the kind that has a main?" cognitive load.

Sourced libraries (`lib/helpers.bash`, `lib/aliases.bash`) have no `main` — their body *is* the init. The rule's purpose (don't auto-execute on source) is moot for files whose only job is to be sourced.

---

## 7. Exit and return

Functions `return`. Only `main` and `die` ever call `exit`.

- `die` is the explicit "abort the script" verb. It logs to stderr and exits non-zero.
- A helper that fails should `return 1`, or rely on `set -e` to propagate the failure of a command substitution or pipeline.
- `main` is the only place where deliberate `exit N` (with a chosen code) belongs.

A function that calls `exit` cannot be safely composed: it cannot be called from `if helper; then ...`, cannot be sourced for testing, cannot be reused. `return` keeps the function as a unit.

---

## 8. Bash builtins over externals

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

When the builtin form is harder to read than the external (e.g., complex regex extraction), the external is fine. The rule is "prefer," not "exclusive." The `source` row above is the one exception that is exclusive: never use `.` in a bash file.

---

## 9. Long options over short

Prefer long options (`--option`) to short options (`-o`) wherever both exist. Long options read as prose at the call site, survive grep, and don't need a man-page lookup later.

```bash
# Yes
notify-send --urgency critical --expire-time 10000 "${msg}"
shfmt --write "${file}"

# No
notify-send -u critical -t 10000 "${msg}"
shfmt -w "${file}"
```

Short options are fine when there is no long form: bash builtins (`mapfile -t`, `read -r`) and tools whose native syntax is single-dash multi-letter (`find -type f`, `find -maxdepth 1`).

---

## 10. Quoting and tests

- Always brace expansions: `${var}`, not `$var`.
- Always quote expansions: `"${var}"`, not `${var}`. Exceptions: inside `[[ ... ]]` (right side of `=~`), inside `(( ... ))`, and where word-splitting is intentional (rare).
- Use `[[ ]]` for tests, never `[ ]`. `[[ ]]` does not word-split or glob, has `=~` for regex, and supports `&&` / `||` *inside* the test (which is a single test, not control-flow chaining).
- Use `(( ))` for arithmetic comparisons and assignments: `if ((count < 10)); then`, `((count++))`. Inside `(( ))`, variables are referenced without `$`. shfmt strips the inner spaces; `((cond))` is the canonical form.
- Don't use `[[ "${a}" -lt "${b}" ]]` for numeric comparison — `(( ))` is shorter, doesn't need quoting, and reads as math.

---

## 11. Dependency checks

External commands a script depends on are checked **at the top of the file** — after the configuration block, before any function definitions or `main` — using the `require_commands` helper:

```bash
declare -r URL="https://example.com"

require_commands curl jq

function fetch {
    ...
}

function main {
    ...
}

main "$@"
```

File scope (not inside `main`) means failures abort *before* any function is defined or any logic runs — the user sees missing tools immediately, not after partial setup.

`require_commands` collects every missing command and aborts with a single message listing all the gaps, so installing missing tooling is one round-trip instead of one per re-run.

---

## 12. Linting and formatting

### Formatting: `shfmt`

Every script is formatted with `shfmt` (installed via `go install` at `~/go/bin/shfmt`; ensure `~/go/bin` is on `PATH`). Configuration is read from `~/.editorconfig` (stowed from `dotfiles/home/.editorconfig`), so the canonical invocation is just:

```bash
shfmt --write <file>
```

Settings (in `~/.editorconfig`): `indent_style = space` and `indent_size = 4` as global defaults; `switch_case_indent = true` under shfmt's `[[bash]]` section (a non-standard editorconfig glob shfmt resolves against the file's detected variant, so it applies to extensionless scripts via shebang detection too). POSIX `sh` files (currently only `bin/shtatic`) need `shfmt --posix --indent=4 <file>`: `--posix` sets the dialect (shfmt can't infer it from the `env sh` shebang and would otherwise format as bash), and `--indent=4` is required because `--posix` bypasses editorconfig's indent settings entirely.

To check formatting without rewriting, use `shfmt --diff` or `shfmt --list`.

### Linting: `shellcheck`

Every script must pass:

```bash
shellcheck --enable=all <file>
```

with zero warnings. `--enable=all` turns on optional checks including `require-variable-braces`, `require-double-brackets`, `quote-safe-variables`, and others — all of which align directly with the rules above. It also catches genuine bugs the rules don't address (uninitialized variables, common substitution mistakes, dangerous quoting).

### Project-level disables

Three checks are disabled in `~/.shellcheckrc` (stowed from `dotfiles/home/.shellcheckrc`):

- **`SC2312`** ("command in pipeline masks return value") — every script sets `set -o pipefail`, so pipeline failures already propagate. The warning is a false positive in this codebase.
- **`SC1091`** ("not following sourced file") — static cross-file source-following is not worth the per-script `# shellcheck source=...` directive in this environment.
- **`SC2310`** ("function invoked in `if` / `while` / `until` condition disables `set -e`") — Rule 3 (`if/then/fi` for all control flow) means predicate functions are *always* called from test positions. The `set -e` suspension that fires there is documented bash semantics of test positions — it is the intentional behavior, not an oversight. Predicate functions in this repo are written to be simple (no internal commands whose failure we'd want `set -e` to catch), so the warning is structural noise.

These are the only checks silenced at the project level. **For everything else: if a check is genuinely wrong for a specific case, suppress it inline with a `# shellcheck disable=SCxxxx` comment that explains why** — never silence at the file or repo level.

---

## 13. Helpers

`lib/helpers.bash` provides the API every script in this repo can rely on. Source it (`source "${HOME}/environment/lib/helpers.bash"`) and the functions below are available; the error/exit traps register on source.

### Logging

| Function | Behavior |
|---|---|
| `log "msg"` | Informational, green `==>` prefix, stderr. |
| `warn "msg"` | Warning, yellow `[WARN]` prefix, stderr. |
| `die "msg"` | Error, red `[ERROR]` prefix, exit 1. The only sanctioned `exit` outside `main`. |

### Dependency check

| Function | Behavior |
|---|---|
| `require_commands cmd1 cmd2 ...` | Aborts with the full list of missing commands. Call once at file scope after the config block. |

### Process management

| Function | Behavior |
|---|---|
| `kill_and_wait <name>` | `killall` the process and poll until it's gone. |
| `quit_and_wait <quit_cmd> <name>` | Run a custom quit command, then poll until the process is gone. |

### Source-build helpers

| Function | Behavior |
|---|---|
| `git_clone_pull_repo <url> <dir> [force]` | Clone if missing, otherwise update. `force=true` for shallow + hard reset (external repos); default is full + ff-only (personal repos). |
| `make_build_install <dir> [make_arg]` | `cd <dir>`, `make clean && make [arg] && sudo make install`, all silenced. |

### Misc

| Function | Behavior |
|---|---|
| `calculate_applet_position <w> <h>` | Compute (x, y) for a popup placed in the screen corner, given the popup size. Used by the calendar/sound applets. |

### Traps (registered on source)

- `on_error` — fires on `ERR` / `SIGINT` / `SIGTERM`. Restores `${ORIGINAL_PWD}` if set, then `die`s with the script name and exit code.
- `on_exit` — fires on `EXIT`. Restores `${ORIGINAL_PWD}`, then calls a `cleanup` function if the sourcing script defines one.

A script that needs cleanup defines `function cleanup { ... }` at file scope; `on_exit` picks it up automatically.

---

## Putting it all together

A complete script that exercises every rule:

```bash
#!/usr/bin/env bash

# Battery low notification

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands upower notify-send

declare -ri CRITICAL_THRESHOLD=10
declare -ri LOW_THRESHOLD=15

function is_battery {
    local data
    local -a fields

    data="$1"

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
    local battery battery_data model state
    local -i percentage
    local -a fields

    battery="$1"

    battery_data="$(upower --show-info "${battery}")"

    if ! is_battery "${battery_data}"; then
        return 0
    fi

    mapfile -t fields < <(awk '/model:|state:|percentage:/{print $2}' <<<"${battery_data}")

    model="${fields[0]}"
    state="${fields[1]}"
    percentage="${fields[2]//%/}"

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
