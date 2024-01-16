use std::{collections::HashMap, fs};
use std::cmp::max;

const DEFAULT_CUBES_IN_BAG: [(&str, u32); 3] = [
                                         ("red", 12),
                                         ("green", 13),
                                         ("blue", 14),
];

fn solve(input: &str, cubes_in_bag: HashMap<&str, u32>) -> [u32; 2] {
    let games = input.split("\n");

    let mut res: u32 = 0;
    let mut sum_of_powers: u32 = 0;
    for line in games {
        let mut max_cube_count_per_color_in_round: HashMap<&str, u32> = HashMap::from([
                                                                                      ("red", 0),
                                                                                      ("green", 0),
                                                                                      ("blue", 0),
        ]);
        let (game_id, rounds_raw) = line.split_at(line.find(": ").unwrap());
        println!("game_id: {game_id}, rounds_raw: {rounds_raw}");

        let mut is_invalid_game: bool = false;
        rounds_raw[2..].split("; ").for_each(|round| {
            println!("round: {round}");
            round.split(", ").for_each(|pull| {
                println!("pull: {pull}");
                let (count_str, color_raw) = pull.split_at(pull.find(" ").unwrap());
                let color = color_raw.trim();

                println!("count_str: {count_str}, color: {color}");
                let max_possible_cubes_of_color: u32 = *cubes_in_bag.get(color).unwrap();
                let actual_cube_count_of_color: u32 = count_str.parse().unwrap();

                let current_color_max = *max_cube_count_per_color_in_round.get(color).unwrap();
                max_cube_count_per_color_in_round.insert(color, max(current_color_max, actual_cube_count_of_color));

                is_invalid_game = is_invalid_game || (max_possible_cubes_of_color < actual_cube_count_of_color);
            })
        });

        if !is_invalid_game {
            let (_, game_number) = game_id.split_at(game_id.find(" ").unwrap() + 1);
            println!("valid game: {game_number}");
            res += game_number.parse::<u32>().unwrap();
        }

        let round_power = max_cube_count_per_color_in_round.values().fold(1, |accumulator, value| -> u32 { accumulator * value });
        println!("round power: {round_power}");
        sum_of_powers += round_power;
    }

    [res, sum_of_powers]
}

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();
    let answer = solve(input.as_str().trim(), HashMap::from(DEFAULT_CUBES_IN_BAG));
    println!("answer: {}, {}", answer[0], answer[1]);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn example() {
        let input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green";

        let answer = solve(input, HashMap::from(DEFAULT_CUBES_IN_BAG));
        assert_eq!(answer[0], 8);
        assert_eq!(answer[1], 2286);
    }
}
