use std::fs;

fn solve(input: &str) -> [u32; 2] {
    let lines = input.split("\n\n");
    let mut bags: Vec<u32> = lines
        .map(|raw_calories| {
            let calories: Vec<u32> = raw_calories
                .split("\n")
                .map(|value| value.trim().parse::<u32>().unwrap())
                .collect();
            calories.iter().sum()
        })
        .collect();
    bags.sort();
    bags.reverse();
    let sum_of_3_highest: u32 = bags.iter().take(3).sum();
    [bags[0], sum_of_3_highest]
}

fn main() {
    let input = fs::read_to_string("input.txt").unwrap();
    let answer: [u32; 2] = solve(input.as_str().trim());
    println!("Answers: [{}, {}]", answer[0], answer[1]);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn example() {
        let input = "1000
            2000
            3000

            4000

            5000
            6000

            7000
            8000
            9000

            10000";
        let answer = solve(input);
        assert_eq!(answer[0], 24000);
        assert_eq!(answer[1], 45000);
    }
}
