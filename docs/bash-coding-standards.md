# Bash Coding Standards

A style guide for Bash scripts. The rules apply to any file that begins with `#!/usr/bin/env bash`.

---

## Script example

```bash
#!/usr/bin/env bash

# Battery low notification

set -Eeuo pipefail

source "${HOME}/environment/lib/helpers.bash"

require_commands upower notify-send

declare -ri CRITICAL_THRESHOLD=10
declare -ri LOW_THRESHOLD=15

function is_battery {
    local -n fields_ref="$1"

    ((${#fields_ref[@]} == 3)) || return 1

    local field
    for field in "${fields_ref[@]}"; do
        [[ -n "${field}" ]] || return 1
    done

    return 0
}

function notify_for_battery {
    local battery="$1"

    local battery_data
    battery_data="$(upower --show-info "${battery}")"

    local -a fields
    mapfile -t fields < <(awk '/model:|state:|percentage:/{print $2}' <<<"${battery_data}")

    is_battery fields || return 0

    local state="${fields[1]}"

    [[ "${state}" == "discharging" ]] || return 0

    local model="${fields[0]}"
    local -i percentage="${fields[2]//%/}"

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

Every executable script follows the same fixed top-down order, including three-line wrappers.

The strict header order, top to bottom:

1. Shebang: `#!/usr/bin/env bash`
2. Header comment (one or two lines).
3. `set -Eeuo pipefail`
4. `source` the helpers.
5. `require_commands` for external dependencies.
6. File-scope `declare -r` constants.
7. Function definitions (helpers first, then `main`).
8. `main "$@"`

Each section is separated by a blank line. Sections that don't apply are omitted; the relative order of the others is preserved.

Files sourced into an interactive shell (`lib/aliases.bash`, `.bashrc`) omit `set -Eeuo pipefail`. The omission carries a one-line header comment.

---

## Comments

Default to no comment. Add a comment only when the *why* is non-obvious — a workaround, an external constraint, a subtle invariant, or behavior that would surprise.

`# shellcheck disable=SCxxxx` directives carry a one-line justification on the same line:

```bash
# shellcheck disable=SC2154  # VERSION_CODENAME is defined by /etc/os-release
```

Avoid:

- Restating what the code does (`# Iterate over the array` above a `for` loop).
- Multi-line essays and `# ---` borders.
- Structural-label dividers (`# Constants`, `# Functions`, `# main`).
- Operation labels above a block (`# Docker`, `# Networking`, `# Cleanup`).
- Section dividers.

---

## Naming

Names must convey meaning. `battery`, `percentage`, `fields`, `entry` — not `b`, `pct`, `fld`, `e`. Short conventional names for trivial loop variables (`i` for a numeric index, `f` for a one-line file iteration) remain acceptable; abbreviations of domain words do not.

- **Executable scripts** (in `bin/`): no extension; kebab-case.
- **Sourced bash libraries**: `.bash` extension; snake_case.
- **Function names**: snake_case, and descriptive of what the function does. When the name cannot convey it, a comment above the function explains it.
- **Variables**:
    - lowercase for local variables.
    - UPPERCASE for `declare -r` configuration and exported variables.

---

## Control flow

A guard clause whose body is a single terminal action uses `||` on one line. Everything else uses `if/then/fi`.

```bash
command -v upower >/dev/null || die "upower not found"
[[ -d "${dir}" ]] || continue
pkill old-daemon || true
```

The right-hand side of a `||` guard must be terminal — `die`, `return`, `continue`, `break`, `exit`, or `true`. `cmd || true` is the "swallow failure" idiom. Do not break a `||` guard across lines to make it fit — that is the signal to use `if/then/fi`.

Use `if/then/fi` when the body is more than one terminal action, when either branch falls through to later code, or when the one-line `||` form would pass 80 columns.

```bash
if ((percentage < CRITICAL_THRESHOLD)); then
    notify-send --urgency critical --expire-time 10000 "CRITICAL: ${model}"
elif ((percentage < LOW_THRESHOLD)); then
    notify-send --urgency critical --expire-time 10000 "LOW: ${model}"
fi
```

Chain conditions with `&&` and `||` in the `if`/`while`/`until` head, one condition per line when it spans more than one:

```bash
if [[ "${force}" == "false" ]] &&
    command -v zed >/dev/null; then
    return 0
fi
```

Never use `&&` as a standalone statement — `cmd && action` becomes an `if`. This does not apply to:

- `&&` and `||` in an `if`/`while`/`until` condition.
- Operators *inside* `[[ ]]`: `[[ -n "${a}" && -n "${b}" ]]`.
- Parameter expansion defaults: `${var:-default}`.

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

Always use `declare -r` for file-scope constants — never `readonly`.

### Configuration block

Configuration constants go at the top of the script, after the header comment, as `declare -r` declarations:

```bash
declare -r SESSIONS_DIR="${HOME}/.config/sessions"
declare -ri CRITICAL_THRESHOLD=10
declare -ri LOW_THRESHOLD=15
```

### Constants from command substitution

When a constant's value comes from a command, split the assignment from the `declare -r`:

```bash
TMP_FILE="$(mktemp --suffix=.png)"
declare -r TMP_FILE
```

Never write `declare -r VAR="$(cmd)"`.

---

## Function shape

Use the `function` keyword without parentheses:

```bash
function battery_notify {
    ...
}
```

Not `battery_notify()`, not `function battery_notify()`.

One `local` per variable, declared immediately above the line that defines it, including nested loops.

If the value is a plain expression — parameter expansion, literal, integer arithmetic, anything that cannot fail — declare and assign on one line:

```bash
local name="$1"
local dir="${2:-${HOME}}"
local -i count=0
local -a items=()
local model="${fields[0]}"
```

If the value comes from a command (`$(...)`, `mapfile`, `read`), split into two lines: declaration above, assignment below.

```bash
local result
result="$(some_command)"

local -a items
mapfile -t items < <(find ...)
```

Never write `local var="$(cmd)"`, and never join the two lines with a semicolon.

When the `local` line is itself the definition (declare + assign on one line) and the variable is mutated in a later block, place the `local` immediately before that block. For an accumulator updated in a loop, that means just above the loop — above the loop's own `local`:

```bash
local -i count=0
local entry
for entry in "${items[@]}"; do
    ((count++))
done
```

Nested loops follow the same rule — one `local` per `for`:

```bash
local entry
for entry in "${entries[@]}"; do
    local file
    for file in "${entry}"/*.txt; do
        ...
    done
done
```

---

## Exit and return

Functions `return`. Only `main` and `die` ever call `exit`.

- `die` is the explicit "abort the script" verb. It logs to stderr and exits non-zero.
- A helper that fails should `return 1`, or rely on `set -e` to propagate the failure of a command substitution or pipeline.
- `main` is the only place where a deliberate `exit N` (with a chosen code) belongs.

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
| `~` | `${HOME}` |
| `[ ... ]` | `[[ ... ]]` |
| `expr "${a}" + "${b}"` | `((a + b))` |
| `for x in $(cmd)` | `mapfile -t arr < <(cmd); for x in "${arr[@]}"` |
| `wc -l <"${file}"` | `mapfile -t lines <"${file}"; ((${#lines[@]}))` |
| `sed 's/x/y/' <<<"${var}"` | `${var/x/y}` (single) or `${var//x/y}` (global) |
| `. file.bash` | `source file.bash` |

When the builtin form is harder to read than the external — typically complex regex extraction — the external is fine.

---

## Long options over short

Prefer long options (`--option`) to short options (`-o`) wherever both exist.

Short options are acceptable when no long form exists: bash builtins (`mapfile -t`, `read -r`) and tools whose native syntax is single-dash multi-letter (`find -type f`, `find -maxdepth 1`).

If the long form would push the line past 80 columns (4-space indent counted), use the short form. This applies even when the short form is already over 80. Backslash continuation is acceptable when it keeps the long form readable, but a single-line short form is usually better than a two-line long form for the same call.

---

## Quoting and tests

- Always brace expansions: `${var}`, not `$var`.
- Always quote expansions: `"${var}"`, not `${var}`. Exceptions: inside `[[ ... ]]` (right side of `=~`), inside `(( ... ))`, and where word-splitting is intentional (rare).
- Use `[[ ]]` for tests, never `[ ]`.
- Combine test operands inside a single `[[ a && b ]]`. Use `&&` or `||` between separate `[[ ]]`s or commands only when an operand is a command that cannot go inside `[[ ]]` — `command -v`, `grep -q`, a function call: `[[ "${force}" == "false" ]] && command -v zed >/dev/null`.
- Use `(( ))` for arithmetic comparisons and assignments: `if ((count < 10))`, `((count++))`. Inside `(( ))`, variables are referenced without `$`.
- Do not use `[[ "${a}" -lt "${b}" ]]` for numeric comparison.

---

## Linting and formatting

Every script must:

- Pass `shfmt --diff` with no changes. Indentation is four spaces; `case` arms are indented under `case`.
- Pass `shellcheck --enable=all` with zero warnings.

### Project-level shellcheck disables

Three checks are disabled at the repository level:

- **`SC2312`** — *command in pipeline masks return value.*
- **`SC1091`** — *not following sourced file.*
- **`SC2310`** — *function invoked in `if` / `while` / `until` condition disables `set -e`.*

For everything else, suppress checks inline with `# shellcheck disable=SCxxxx` and a one-line justification. Do not silence checks at the file or repository level.
