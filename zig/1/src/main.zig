const std = @import("std");

fn solve(input: []const u8) ![2]u32 {
    var calories = std.ArrayList(u32).init(std.heap.page_allocator);
    defer calories.deinit();

    var currentCalories: u32 = 0;
    var iter = std.mem.split(u8, input, "\n");
    while (iter.next()) |line| {
        if (line.len > 0) {
            currentCalories += try std.fmt.parseInt(u32, line, 10);
        } else {
            try calories.append(currentCalories);
            currentCalories = 0;
        }
    }

    std.mem.sort(u32, calories.items, {}, comptime std.sort.desc(u32));
    const highest = calories.items[0];
    const topThreeHighest = sum: {
        var sum: u32 = 0;
        for (calories.items[0..3]) |num| {
            sum += num;
        }
        break :sum sum;
    };

    return [_]u32{ highest, topThreeHighest };
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const answer = try solve(input);
    try std.io.getStdOut().writer().print("The heaviest bag weighs {d}\n", .{answer});
}

test "Sample" {
    const input =
        \\1000
        \\2000
        \\3000
        \\
        \\4000
        \\
        \\5000
        \\6000
        \\
        \\7000
        \\8000
        \\9000
        \\
        \\10000
        \\
    ;
    const answer = try solve(input);
    try std.testing.expect(answer[0] == 24_000);
    try std.testing.expect(answer[1] == 45_000);
}
