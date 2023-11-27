const std = @import("std");

const UserErrors = error{InvalidInput};

const Range = struct {
    lowerLimit: u32,
    upperLimit: u32,

    fn contains(self: *const Range, other: Range) bool {
        return self.lowerLimit <= other.lowerLimit and self.upperLimit >= other.upperLimit;
    }

    fn overlaps(self: *const Range, other: Range) bool {
        return (self.lowerLimit <= other.lowerLimit and self.upperLimit >= other.lowerLimit) or (self.lowerLimit <= other.upperLimit and self.upperLimit >= other.upperLimit);
    }

    fn fromString(string: []const u8) !Range {
        const limitsSeparatorIndex = for (string, 0..) |char, index| {
            if (char == '-') break index;
        } else return UserErrors.InvalidInput;

        return Range{
            .lowerLimit = try std.fmt.parseInt(u32, string[0..limitsSeparatorIndex], 10),
            .upperLimit = try std.fmt.parseInt(u32, string[limitsSeparatorIndex + 1 ..], 10),
        };
    }
};

fn solve(input: []const u8) ![2]u32 {
    var part1Counter: u32 = 0;
    var part2Counter: u32 = 0;
    var pairIterator = std.mem.splitSequence(u8, input, "\n");
    while (pairIterator.next()) |pair| {
        const rangeSeparatorIndex: usize = for (pair, 0..) |char, index| {
            if (char == ',') break index;
        } else {
            std.log.err("This input is invalid {s}. Skipping", .{pair});
            continue;
        };
        const firstRangeRaw = pair[0..rangeSeparatorIndex];
        const firstRange = try Range.fromString(firstRangeRaw);

        const secondRangeRaw = pair[rangeSeparatorIndex + 1 ..];
        const secondRange = try Range.fromString(secondRangeRaw);

        if (firstRange.contains(secondRange) or secondRange.contains(firstRange)) {
            part1Counter += 1;
        }

        if (firstRange.overlaps(secondRange) or secondRange.overlaps(firstRange)) {
            part2Counter += 1;
        }
    }
    return [_]u32{ part1Counter, part2Counter };
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result = try solve(input);
    std.log.info("Result: {}, {}", .{ result[0], result[1] });
}

test "Sample" {
    const input =
        \\2-4,6-8
        \\2-3,4-5
        \\5-7,7-9
        \\2-8,3-7
        \\6-6,4-6
        \\2-6,4-8
    ;
    const result = try solve(input);
    try std.testing.expectEqual(result[0], 2);
    try std.testing.expectEqual(result[1], 4);
}
