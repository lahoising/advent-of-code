use std::collections::HashSet;
use std::fs;

fn get_character_points(character: &char) -> u32 {
    let ret = if character.is_lowercase() {
        (*character as u8) - 'a' as u8 + 1
    } else {
        (*character as u8) - 'A' as u8 + 27
    };
    ret as u32
}

fn solve(input: &str) -> [u32; 2] {
    let mut part1: u32 = 0;
    let mut part2: u32 = 0;

    let mut part2_buffer: HashSet<char> = HashSet::new();
    let lines = input.split("\n").collect::<Vec<_>>();
    for i in 0..lines.len() {
        let raw_line = lines[i];
        let line = raw_line.trim();
        let line_length = line.len();
        let split = line.split_at(line_length/2);

        let characters_in_first_half: HashSet<char> = HashSet::from_iter(split.0.chars());
        let characters_in_second_half: HashSet<char> = HashSet::from_iter(split.1.chars());
        let common_characters = characters_in_first_half.intersection(&characters_in_second_half);

        part1 += common_characters
            .map(get_character_points)
            .sum::<u32>();

        let characters_in_line = HashSet::from_iter(line.chars());
        match i % 3 {
            0 => part2_buffer = characters_in_line,
            1 => part2_buffer.retain(|element| characters_in_line.contains(element)),
            2 => {
                part2_buffer.retain(|element| characters_in_line.contains(element));
                part2 += part2_buffer.iter()
                    .map(get_character_points)
                    .sum::<u32>();
            },
            _ => panic!("literally how")
        }
    }

    [part1, part2]
}

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();
    let answer = solve(input.to_string().trim());
    println!("Answers: [{}, {}]", answer[0], answer[1]);
}

#[cfg(test)]
mod tests {
    use crate::solve;

    #[test]
    fn example() {
        let input = "vJrwpWtwJgWrhcsFMMfFFhFp
            jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
            PmmdzqPrVvPwwTWBwg
            wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
            ttgJtRGJQctTZtZT
            CrZsJsPPZsGzwwsLwLmpwMDw";

        let answer = solve(input);
        assert_eq!(answer[0], 157);
        assert_eq!(answer[1], 70);
    }
}
