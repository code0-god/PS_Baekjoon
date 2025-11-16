use std::io::{self, Read};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    // 입력을 파싱하고 정답을 출력하세요.
    println!("{}", input.trim());
}
