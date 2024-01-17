use std::cmp::min;
use std::collections::LinkedList;
use std::fs;

struct Number {
    x: usize,
    y: usize,
    width: usize,
    height: usize,
    number: u32,
}

fn solve(input: &str) -> [u32; 2] {
    let lines: Vec<&str> = input.split("\n").collect();
    let width: usize = lines[0].len();
    let height: usize = lines.len();

    let mut numbers: LinkedList<Number> = LinkedList::new();

    for (y, line) in lines.iter().enumerate() {
        let mut offset: usize = 0;
        while offset < width {
            let number_start_raw = line[offset..].find(|c: char| c.is_digit(10));
            match number_start_raw {
                Some(start_raw) => {
                    let start = start_raw + offset;
                    let number_end = line[start..].find(|c: char| !c.is_digit(10));
                    match number_end {
                        Some(end) => {
                            let num = line[start..start+end].parse::<u32>().unwrap();
                            numbers.push_back(Number {
                                x: start,
                                y: y,
                                width: end,
                                height: 1,
                                number: num,
                            });
                            offset = start + end;
                        },
                        None => {
                            let num = line[start..width].parse::<u32>().unwrap();
                            numbers.push_back(Number {
                                x: start,
                                y: y,
                                width: width - start,
                                height: 1,
                                number: num,
                            });
                            offset = width;
                        },
                    }
                },
                None => { offset = width; },
            }
        }
    }

    let mut counter: u32 = 0;
    let map = lines.join("");
    for num in numbers {
        let min_x = if num.x == 0 { num.x } else { num.x - 1 };
        let min_y = if num.y == 0 { num.y } else { num.y - 1 };
        let max_x = min(num.x + num.width + 1, width);
        let max_y = min(num.y + num.height + 1, height);

        for x in min_x..max_x {
            for y in min_y..max_y {
                let current_char = map.chars().nth(y * width + x).unwrap();
                if !current_char.is_digit(10) && current_char != '.' {
                    counter += num.number;
                }
            }
        }
    }

    [counter, 0]
}

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();
    let answer = solve(input.as_str().trim());
    println!("Answer: {{{}, {}}}", answer[0], answer[1]);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn example() {
        let input = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..";

        let answer = solve(input);
        assert_eq!(answer[0], 4361);
    }
}
