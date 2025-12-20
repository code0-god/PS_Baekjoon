use std::io::{self, Read};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let n: usize = input.trim().parse::<usize>().unwrap_or(0);

    for i in 0..n {
        for _ in 0..=i {
            print!("*");
        }
        println!();
    }
}
