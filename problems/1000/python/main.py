import sys

def solve() -> None:
    data = sys.stdin.read().strip().split()
    if len(data) < 2:
        print(0)
        return
    a, b = map(int, data[:2])
    print(a + b)

if __name__ == "__main__":
    solve()
