const std = @import("std");

const inputFilepath = "input.txt";

fn calculatePriority(character: u8) u32 {
    return if (std.ascii.isLower(character)) character - 'a' + 1 else (character - 'A' + 27);
}

fn getGroupPriorityIfPresent(group: std.AutoHashMap(u8, u32)) ?u32 {
    var mostCommonCharacter: ?u8 = null;
    var iter = group.iterator();
    while (iter.next()) |entry| {
        if (mostCommonCharacter == null or entry.value_ptr.* > group.get(mostCommonCharacter.?).?) {
            mostCommonCharacter = entry.key_ptr.*;
        }
    }
    return if (mostCommonCharacter != null and group.get(mostCommonCharacter.?).? == 3) calculatePriority(mostCommonCharacter.?) else null;
}

fn solve(input: []const u8) ![2]u32 {
    const allocator = std.heap.page_allocator;
    var currentGroup = std.AutoHashMap(u8, u32).init(allocator);
    defer currentGroup.deinit();

    var sumOfGroupPriorities: u32 = 0;
    var sumOfPriorities: u32 = 0;
    var iter = std.mem.split(u8, input, "\n");
    while (iter.next()) |line| {
        var charactersInLine = std.AutoHashMap(u8, void).init(allocator);
        defer charactersInLine.deinit();

        var firstHalf = std.AutoHashMap(u8, void).init(allocator);
        defer firstHalf.deinit();

        var secondHalf = std.AutoHashMap(u8, void).init(allocator);
        defer secondHalf.deinit();

        const halfLength = line.len / 2;
        for (line, 0..) |character, index| {
            if (index < halfLength) {
                try firstHalf.put(character, {});
            } else if (firstHalf.contains(character)) {
                try secondHalf.put(character, {});
            }
            try charactersInLine.put(character, {});
        }

        var firstHalfIter = firstHalf.keyIterator();
        while (firstHalfIter.next()) |character| {
            if (secondHalf.contains(character.*)) {
                sumOfPriorities += calculatePriority(character.*);
                break;
            }
        }

        var charactersInLineIter = charactersInLine.keyIterator();
        while (charactersInLineIter.next()) |character| {
            const value = if (currentGroup.contains(character.*)) (currentGroup.get(character.*).? + 1) else 1;
            try currentGroup.put(character.*, value);
        }

        const groupPriority = getGroupPriorityIfPresent(currentGroup);
        if (groupPriority != null) {
            sumOfGroupPriorities += groupPriority.?;
            currentGroup.clearRetainingCapacity();
        }
    }

    return [2]u32{ sumOfPriorities, sumOfGroupPriorities };
}

pub fn main() !void {
    const input = @embedFile(inputFilepath);
    const result = try solve(input);
    try std.io.getStdOut().writer().print("The answers are {} and {}\n", .{ result[0], result[1] });
}

test "Sample" {
    const input =
        \\vJrwpWtwJgWrhcsFMMfFFhFp
        \\jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
        \\PmmdzqPrVvPwwTWBwg
        \\wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
        \\ttgJtRGJQctTZtZT
        \\CrZsJsPPZsGzwwsLwLmpwMDw
    ;

    const result = try solve(input);
    try std.testing.expectEqual(result[0], 157);
    try std.testing.expectEqual(result[1], 70);
}
