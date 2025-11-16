#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<'USAGE'
Usage: ./create_problem.sh <problem_id> [language ...]

새 문제 폴더를 만들고 지정된 언어별 기본 템플릿을 생성합니다.
언어를 생략하면 기본값으로 cpp python rust 를 만듭니다.
USAGE
}

if [[ $# -lt 1 ]]; then
    usage
    exit 1
fi

PROBLEM_ID="$1"
shift || true
if [[ $# -gt 0 ]]; then
    LANGS=("$@")
else
    LANGS=(cpp python rust)
fi

PROBLEM_DIR="problems/${PROBLEM_ID}"
TEST_DIR="${PROBLEM_DIR}/tests"

if [[ -e "$PROBLEM_DIR" ]]; then
    echo "[error] ${PROBLEM_DIR} 이미 존재합니다." >&2
    exit 1
fi

mkdir -p "$TEST_DIR"
cat <<'SAMPLE' > "${TEST_DIR}/sample1.txt"
# 입력 예시를 여기에 작성하세요
SAMPLE

generate_cpp() {
    local dir="$1/cpp"
    mkdir -p "$dir"
    cat <<'CPP' > "${dir}/main.cpp"
#include <bits/stdc++.h>
using namespace std;

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    // 입력/출력 로직을 작성하세요.
    return 0;
}
CPP
}

generate_python() {
    local dir="$1/python"
    mkdir -p "$dir"
    cat <<'PY' > "${dir}/main.py"
import sys

def solve() -> None:
    data = sys.stdin.read().strip().split()
    # 입력을 파싱하고 정답을 출력하세요.
    print(data)

if __name__ == "__main__":
    solve()
PY
}

generate_rust() {
    local dir="$1/rust"
    mkdir -p "${dir}/src"
    cat <<EOF > "${dir}/Cargo.toml"
[package]
name = "boj_${PROBLEM_ID}"
version = "0.1.0"
edition = "2021"

[dependencies]
EOF
    cat <<'RS' > "${dir}/src/main.rs"
use std::io::{self, Read};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    // 입력을 파싱하고 정답을 출력하세요.
    println!("{}", input.trim());
}
RS
}

for lang in "${LANGS[@]}"; do
    case "$lang" in
        cpp)
            generate_cpp "$PROBLEM_DIR"
            ;;
        python)
            generate_python "$PROBLEM_DIR"
            ;;
        rust)
            generate_rust "$PROBLEM_DIR"
            ;;
        *)
            echo "[warn] 지원하지 않는 언어: $lang" >&2
            ;;
    esac
done

echo "[info] 생성 완료: ${PROBLEM_DIR}"
