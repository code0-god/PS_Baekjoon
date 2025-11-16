use std::io::{self, Read};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut iter = input.split_whitespace();
    let a: i64 = iter.next().and_then(|v| v.parse().ok()).unwrap_or(0);
    let b: i64 = iter.next().and_then(|v| v.parse().ok()).unwrap_or(0);
    println!("{}", a + b);
}
