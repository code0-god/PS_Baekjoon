#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage: ./run_problem.sh <problem_id> <language> [input_file]

Runs the selected Baekjoon solution from repo root using the provided stdin sample.
Supported languages: cpp, py, rs.
If input_file is omitted, the first *.txt file under problems/<id>/tests is used.
USAGE
}

if [[ $# -lt 2 ]]; then
    usage
    exit 1
fi

PROBLEM_ID="$1"
LANGUAGE="${2,,}"
INPUT_FILE="${3:-}"
PROBLEM_DIR="problems/${PROBLEM_ID}"
case "$LANGUAGE" in
    py) LANGUAGE_DIR_NAME="python" ;;
    rs) LANGUAGE_DIR_NAME="rust" ;;
    *) LANGUAGE_DIR_NAME="$LANGUAGE" ;;
esac
LANG_DIR="${PROBLEM_DIR}/${LANGUAGE_DIR_NAME}"
TEST_DIR="${PROBLEM_DIR}/tests"

if [[ ! -d "$PROBLEM_DIR" ]]; then
    echo "[error] Problem directory '$PROBLEM_DIR' not found" >&2
    exit 1
fi

if [[ ! -d "$LANG_DIR" ]]; then
    echo "[error] Language '$LANGUAGE' is not configured for problem $PROBLEM_ID" >&2
    exit 1
fi

if [[ -z "$INPUT_FILE" ]]; then
    if [[ -d "$TEST_DIR" ]]; then
        INPUT_FILE=$(find "$TEST_DIR" -maxdepth 1 -name '*.txt' | sort | head -n1 || true)
    fi
    if [[ -z "$INPUT_FILE" ]]; then
        echo "[error] No test input file found under '$TEST_DIR'" >&2
        exit 1
    fi
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "[error] Input file '$INPUT_FILE' does not exist" >&2
    exit 1
fi

COMMAND=()
case "$LANGUAGE" in
    py)
        SCRIPT_FILE="${LANG_DIR}/main.py"
        if [[ ! -f "$SCRIPT_FILE" ]]; then
            echo "[error] Missing $SCRIPT_FILE" >&2
            exit 1
        fi
        COMMAND=(python3 "$SCRIPT_FILE")
        ;;
    cpp)
        SOURCE_FILE="${LANG_DIR}/main.cpp"
        if [[ ! -f "$SOURCE_FILE" ]]; then
            echo "[error] Missing $SOURCE_FILE" >&2
            exit 1
        fi
        OUTPUT_FILE="build/${PROBLEM_ID}_${LANGUAGE}"
        mkdir -p build
        g++ -std=c++17 -O2 -pipe "$SOURCE_FILE" -o "$OUTPUT_FILE"
        COMMAND=("$OUTPUT_FILE")
        ;;
    rs)
        MANIFEST_FILE="${LANG_DIR}/Cargo.toml"
        if [[ ! -f "$MANIFEST_FILE" ]]; then
            echo "[error] Missing $MANIFEST_FILE" >&2
            exit 1
        fi
        COMMAND=(cargo run --quiet --manifest-path "$MANIFEST_FILE")
        ;;
    *)
        echo "[error] Unsupported language '$LANGUAGE'" >&2
        exit 1
        ;;
esac

echo "[info] Running problem ${PROBLEM_ID} (${LANGUAGE}) with input '${INPUT_FILE}'"
"${COMMAND[@]}" < "$INPUT_FILE"
