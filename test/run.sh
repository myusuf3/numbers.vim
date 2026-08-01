#!/usr/bin/env bash
#
# Runs every case in test/cases/ against both Vim and Neovim.
#
# Each case runs in its own editor process so that the plugin's global state
# cannot leak between them. A case may request startup configuration with a
# `" SETUP: <commands>` line, which the runner passes as --cmd before the
# plugin loads.
#
# Usage: test/run.sh [case-name ...]

set -u

root=$(cd "$(dirname "$0")/.." && pwd)
cases=()
if [ $# -gt 0 ]; then
    for name in "$@"; do
        path="$root/test/cases/$name.vim"
        if [ ! -f "$path" ]; then
            echo "no such case: $name" >&2
            exit 1
        fi
        cases+=("$path")
    done
else
    for path in "$root"/test/cases/*.vim; do cases+=("$path"); done
fi

passed=0
failed=0
ran_any=0

run_case() {
    local editor=$1 path=$2 setup args output status
    setup=$(grep -m1 '^" SETUP: ' "$path" | cut -d: -f2-)

    args=(--cmd "set rtp+=$root")
    if [ -n "$setup" ]; then
        args+=(--cmd "$setup")
    fi

    # Stdin is closed throughout: an editor that hits an unexpected prompt
    # should fail the case rather than block the run forever.
    if [ "$editor" = nvim ]; then
        output=$(nvim --headless --clean "${args[@]}" -S "$path" </dev/null 2>&1)
        status=$?
    else
        # -u NORC keeps plugin loading enabled; -u NONE would disable it.
        # -es is silent Ex mode, which is why cases report via writefile().
        output=$(vim -es -u NORC -N "${args[@]}" -S "$path" </dev/null 2>&1 | tr -d '\r')
        status=${PIPESTATUS[0]}
    fi

    echo "$output"
    return $status
}

for editor in vim nvim; do
    if ! command -v "$editor" >/dev/null 2>&1; then
        echo "skipping $editor -- not installed"
        continue
    fi
    ran_any=1
    echo "$("$editor" --version | head -1)"

    for path in "${cases[@]}"; do
        name=$(basename "$path" .vim)
        echo "$name"
        if run_case "$editor" "$path"; then
            passed=$((passed + 1))
        else
            failed=$((failed + 1))
        fi
    done
    echo
done

if [ "$ran_any" -eq 0 ]; then
    echo "no editor found; install vim or neovim"
    exit 1
fi

echo "$passed case(s) passed, $failed failed"
[ "$failed" -eq 0 ]
