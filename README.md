# PS_Baekjoon Template

이 저장소는 백준 문제 풀이를 언어별(C++/Python/Rust)로 관리하면서, 문제별 예시 stdin 을 사용해 루트에서 손쉽게 테스트할 수 있도록 구성되어 있습니다.

## 디렉터리 구조

```
PS_Baekjoon/
├── run_problem.sh           # 루트에서 문제/언어 테스트 실행 스크립트
├── problems/
│   └── 1000/
│       ├── tests/           # 예시 stdin (*.txt)
│       │   └── sample1.txt
│       ├── cpp/main.cpp
│       ├── python/main.py
│       └── rust/
│           ├── Cargo.toml
│           └── src/main.rs
└── build/                   # C++ 실행 파일 출력 위치 (자동 생성)
```

- `problems/<번호>/tests/*.txt` : 문제별 예시 입력을 여러 개 둘 수 있습니다.
- `problems/<번호>/<언어>/` : 언어별 풀이 파일을 배치합니다. (필요한 언어만 만들어도 됩니다.)

## 실행 방법

루트에서 `run_problem.sh` 스크립트를 실행하면 됩니다.

```bash
./run_problem.sh <문제번호> <언어> [입력파일경로]
```

- 언어 키워드: `cpp`, `python`, `rust`
- 입력 파일 경로를 생략하면 `problems/<번호>/tests` 폴더의 첫 번째 `*.txt` 파일을 사용합니다.

### 예시

```bash
# Python 풀이 실행 (tests/sample1.txt 가 자동으로 stdin 으로 주입)
./run_problem.sh 1000 python

# C++ 풀이 실행, 특정 입력 파일 지정
./run_problem.sh 1000 cpp problems/1000/tests/sample1.txt

# Rust 풀이 실행
./run_problem.sh 1000 rust
```

## 새로운 문제 추가 절차

### 자동 스캐폴딩 스크립트 사용 (권장)

루트에서 `create_problem.sh` 를 호출하면 문제 폴더 + 테스트 + 언어별 기본 템플릿이 한 번에 생성됩니다.

```bash
# 기본 언어(cpp/python/rust) 세트를 한꺼번에 생성
./create_problem.sh 2557

# 원하는 언어만 지정해서 생성
./create_problem.sh 2557 python cpp
```

생성 후에는 각 언어 `main` 파일을 열어 로직을 채워 넣으면 됩니다.

### 수동으로 만들 경우

1. `problems/<번호>/tests` 폴더를 만들고 예시 입력 파일(`sample1.txt` 등)을 추가합니다.
2. 필요한 언어 폴더(`cpp`, `python`, `rust`)를 만든 뒤 `main` 소스 파일을 작성합니다.
   - C++: `problems/<번호>/cpp/main.cpp`
   - Python: `problems/<번호>/python/main.py`
   - Rust: `problems/<번호>/rust/` 안에 `Cargo.toml` + `src/main.rs` (독립 Cargo crate)
3. 루트에서 `./run_problem.sh <번호> <언어>` 명령으로 실행하면 예시 stdin 이 주입된 상태로 테스트됩니다.

Rust 풀이가 여럿 생기면 Cargo workspaces 로 확장하거나, 언어별 템플릿을 `problems/templates` 등에 마련해 복사하여 사용하면 됩니다.
