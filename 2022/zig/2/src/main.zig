const std = @import("std");

const inputFilepath = "input.txt";

const pointsForLosing: u8 = 0;
const pointsForDrawing: u8 = 3;
const pointsForWinning: u8 = 6;

fn solveRound(input: []const u8) u32 {
    const theirs = input[0];
    const ours = input[2];
    return 3 * ((ours - theirs - 1) % 3) + ours - 'X' + 1;
}

fn solvePart2(input: []const u8) u32 {
    const theirs = input[0];
    const ours = input[2];
    return ((ours + theirs - 1) % 3 + 1) + 3 * (ours - 'X');
}

fn solveGame(input: []const u8) [2]u32 {
    var playerPoints: u32 = 0;
    var part2: u32 = 0;
    var iter = std.mem.split(u8, input, "\n");
    while (iter.next()) |roundInput| {
        if (roundInput.len <= 0) continue;
        playerPoints += solveRound(roundInput);
        part2 += solvePart2(roundInput);
    }

    return [2]u32{ playerPoints, part2 };
}

pub fn main() !void {
    const input = @embedFile(inputFilepath);
    const result = solveGame(input);
    try std.io.getStdOut().writer().print("Player got {} points.\n", .{result[0]});
    try std.io.getStdOut().writer().print("Part 2 {} points.\n", .{result[1]});
}

test "Sample" {
    const input =
        \\A Y
        \\B X
        \\C Z
    ;
    const result = solveGame(input);
    try std.testing.expect(result[0] == 15);
    try std.testing.expect(result[1] == 12);
}
