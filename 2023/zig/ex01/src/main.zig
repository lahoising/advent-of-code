const std = @import("std");

const Digit = struct {
    value: u32,
    repr: []const u8,
};

const DigitIndexTracker = struct {
    digit: u32,
    index: usize,
};

const numericalDigits = [_]Digit{
    .{ .value = 0, .repr = "0" },
    .{ .value = 1, .repr = "1" },
    .{ .value = 2, .repr = "2" },
    .{ .value = 3, .repr = "3" },
    .{ .value = 4, .repr = "4" },
    .{ .value = 5, .repr = "5" },
    .{ .value = 6, .repr = "6" },
    .{ .value = 7, .repr = "7" },
    .{ .value = 8, .repr = "8" },
    .{ .value = 9, .repr = "9" },
};

const alphabeticalDigits = [_]Digit{
    .{ .value = 0, .repr = "zero" },
    .{ .value = 1, .repr = "one" },
    .{ .value = 2, .repr = "two" },
    .{ .value = 3, .repr = "three" },
    .{ .value = 4, .repr = "four" },
    .{ .value = 5, .repr = "five" },
    .{ .value = 6, .repr = "six" },
    .{ .value = 7, .repr = "seven" },
    .{ .value = 8, .repr = "eight" },
    .{ .value = 9, .repr = "nine" },
};

const alphaNumericDigits = numericalDigits ++ alphabeticalDigits;

fn findCalibrationValue(line: []const u8, possibleDigits: []const Digit) u32 {
    var firstDigitIndex: ?DigitIndexTracker = null;
    var lastDigitIndex: ?DigitIndexTracker = null;

    if (line.len <= 0) return 0;

    for (possibleDigits) |digit| {
        if (std.mem.indexOf(u8, line, digit.repr)) |currDigitIdx| {
            const currDigitIdxTracker = DigitIndexTracker{
                .digit = digit.value,
                .index = currDigitIdx,
            };

            if (firstDigitIndex) |firstDigitIndexValue| {
                if (currDigitIdx < firstDigitIndexValue.index) {
                    firstDigitIndex = currDigitIdxTracker;
                }
            } else {
                firstDigitIndex = currDigitIdxTracker;
            }
        }

        if (std.mem.lastIndexOf(u8, line, digit.repr)) |currDigitIdx| {
            const currDigitIdxTracker = DigitIndexTracker{
                .digit = digit.value,
                .index = currDigitIdx,
            };

            if (lastDigitIndex) |lastDigitIndexValue| {
                if (currDigitIdx > lastDigitIndexValue.index) {
                    lastDigitIndex = currDigitIdxTracker;
                }
            } else {
                lastDigitIndex = currDigitIdxTracker;
            }
        }
    }

    return firstDigitIndex.?.digit * 10 + lastDigitIndex.?.digit;
}

fn solve(input: []const u8, possibleDigits: []const Digit) u32 {
    var iter = std.mem.splitSequence(u8, input, "\n");

    var answer: u32 = 0;
    while (iter.next()) |line| {
        answer += findCalibrationValue(line, possibleDigits);
    }

    return answer;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const part1 = solve(input, &numericalDigits);
    const part2 = solve(input, &alphaNumericDigits);
    std.log.info("answers: {d}, {d}", .{ part1, part2 });
}

test "simple test" {
    const input =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;

    const input2 =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;

    const part1 = solve(input, &numericalDigits);
    try std.testing.expectEqual(part1, 142);

    const part2 = solve(input2, &alphaNumericDigits);
    try std.testing.expectEqual(part2, 281);
}
