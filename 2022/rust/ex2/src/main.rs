use std::fs;

#[repr(u32)]
#[derive(Copy, Clone)]
enum Choice { Rock = 1, Paper = 2, Scissors = 3 }

#[repr(u32)]
#[derive(Copy, Clone)]
enum RoundOutcome { Win = 6, Draw = 3, Lose = 0 }

fn get_opponent_choice(input: char) -> Choice {
    match input {
        'A' => Choice::Rock,
        'B' => Choice::Paper,
        'C' => Choice::Scissors,
        _ => panic!("{} is not a recognized input for opponent", input)
    }
}

fn get_player_choice(input: char) -> Choice {
    match input {
        'X' => Choice::Rock,
        'Y' => Choice::Paper,
        'Z' => Choice::Scissors,
        _ => panic!("{} is not a recognized input for opponent", input)
    }
}

fn get_round_outcome(input: char) -> RoundOutcome {
    match input {
        'X' => RoundOutcome::Lose,
        'Y' => RoundOutcome::Draw,
        'Z' => RoundOutcome::Win,
        _ => panic!("{} is not a recognized input for player", input)
    }
}

fn calculate_round_outcome(player_choice: Choice, opponent_choice: Choice) -> RoundOutcome {
    match player_choice {
        Choice::Rock => match opponent_choice {
            Choice::Rock => RoundOutcome::Draw,
            Choice::Paper => RoundOutcome::Lose,
            Choice::Scissors => RoundOutcome::Win,
        },
        Choice::Paper => match opponent_choice {
            Choice::Rock => RoundOutcome::Win,
            Choice::Paper => RoundOutcome::Draw,
            Choice::Scissors => RoundOutcome::Lose,
        },
        Choice::Scissors => match opponent_choice {
            Choice::Rock => RoundOutcome::Lose,
            Choice::Paper => RoundOutcome::Win,
            Choice::Scissors => RoundOutcome::Draw,
        },
    }
}

fn calculate_player_choice_points(opponent_choice: Choice, outcome: RoundOutcome) -> u32 {
    match outcome {
        RoundOutcome::Win => (opponent_choice as u32) % 3 + 1,
        RoundOutcome::Draw => opponent_choice as u32,
        RoundOutcome::Lose => (opponent_choice as u32 + 1) % 3 + 1,
    }
}

fn solve(input: &str) -> [u32; 2] {
    let lines = input.split("\n");
    let mut part1: u32 = 0;
    let mut part2: u32 = 0;

    for raw_round in lines {
        let round = raw_round.trim();
        let first = round.chars().nth(0).unwrap();
        let second = round.chars().nth(2).unwrap();

        let opponent_choice = get_opponent_choice(first);
        let player_choice = get_player_choice(second);
        part1 += player_choice as u32 + calculate_round_outcome(player_choice, opponent_choice) as u32;

        let round_outcome = get_round_outcome(second);
        part2 += round_outcome as u32 + calculate_player_choice_points(opponent_choice, round_outcome);
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
    use super::solve;

    #[test]
    fn example() {
        let input = "A Y
            B X
            C Z";
        let answer = solve(input);
        assert_eq!(answer[0], 15);
        assert_eq!(answer[1], 12);
    }
}
