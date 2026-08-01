#!/usr/bin/env bash
#
# Runs every case in test/cases/ against both Vim and Neovim.
#
# Each case runs in its own editor process so that the plugin's global state
# cannot leak between them. A case may request startup configuration with a
# `" SETUP: <commands>` line, which the runner passes as --cmd before the
# plugin loads.
#
# A case passes only if the editor exits 0 and the case printed its closing
# "done" line. Anything else -- an error partway through, a prompt the editor
# is waiting on, a crash -- is a failure.
#
# Usage: test/run.sh [case-name ...]

set -u

root=$(cd "$(dirname "$0")/.." && pwd)
timeout_secs=${NUMBERS_TEST_TIMEOUT:-30}

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

# Bash has no portable timeout(1) -- macOS does not ship one -- so poll.
run_case() {
    local editor=$1 path=$2
    local setup args cmd tmp pid waited status

    setup=$(grep -m1 '^" SETUP: ' "$path" | cut -d: -f2-)
    args=(--cmd "set rtp+=$root")
    if [ -n "$setup" ]; then
        args+=(--cmd "$setup")
    fi

    if [ "$editor" = nvim ]; then
        cmd=(nvim --headless --clean "${args[@]}" -S "$path")
    else
        # -u NORC keeps plugin loading enabled; -u NONE would disable it.
        # -es is silent Ex mode, which is why cases report via writefile().
        cmd=(vim -es -u NORC -N "${args[@]}" -S "$path")
    fi

    tmp=$(mktemp)
    # Stdin is closed so an unexpected prompt fails fast instead of blocking.
    "${cmd[@]}" </dev/null >"$tmp" 2>&1 &
    pid=$!

    waited=0
    while kill -0 "$pid" 2>/dev/null; do
        if [ "$waited" -ge "$timeout_secs" ]; then
            kill -9 "$pid" 2>/dev/null
            wait "$pid" 2>/dev/null
            tr -d '\r' <"$tmp"
            rm -f "$tmp"
            return 124
        fi
        sleep 1
        waited=$((waited + 1))
    done

    wait "$pid"
    status=$?
    tr -d '\r' <"$tmp"
    rm -f "$tmp"
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
        out=$(run_case "$editor" "$path")
        status=$?
        echo "$out"

        if [ "$status" -eq 124 ]; then
            echo "  FAIL case timed out after ${timeout_secs}s"
            failed=$((failed + 1))
        elif [ "$status" -ne 0 ]; then
            failed=$((failed + 1))
        elif ! printf '%s\n' "$out" | grep -q '^  done$'; then
            echo "  FAIL case did not reach the end -- an error aborted it"
            failed=$((failed + 1))
        else
            passed=$((passed + 1))
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
