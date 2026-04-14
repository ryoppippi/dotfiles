# Zig TDD Reference

## Running Tests

```bash
# Run tests in a specific file
zig test src/cart.zig

# Run tests matching a name pattern
zig test src/cart.zig --test-filter "returns zero for empty cart"

# Run with verbose output (shows all test names)
zig test src/cart.zig --verbose

# Run build-step tests (if using build.zig)
zig build test
```

## Test Blocks

- `test "name" { ... }` — Define a test. The name is a string literal.
- `std.testing.expect(condition)` — Assert a boolean condition.
- `std.testing.expectEqual(expected, actual)` — Assert equality.
- `std.testing.expectError(expected_error, expr)` — Assert an error is returned.
- `return error.SkipZigTest;` — Skip a test at runtime (like `it.skip`). Use to sketch behaviours you plan to implement.

## TDD Example

```zig
const std = @import("std");
const testing = std.testing;
const calculateTotal = @import("cart.zig").calculateTotal;

// Step 1: Sketch behaviours with SkipZigTest
test "applies percentage discount" {
    return error.SkipZigTest;
}

test "never returns negative total" {
    return error.SkipZigTest;
}

// Step 2: Implement one at a time (Red → Green → Refactor)
test "returns zero for empty slice" {
    const items = &[_]Item{};
    try testing.expectEqual(@as(i64, 0), calculateTotal(items));
}

test "sums item prices" {
    const items = &[_]Item{
        .{ .price = 10 },
        .{ .price = 20 },
    };
    try testing.expectEqual(@as(i64, 30), calculateTotal(items));
}

// Test expected errors
test "rejects negative price" {
    const items = &[_]Item{
        .{ .price = -5 },
    };
    try testing.expectError(error.NegativePrice, calculateTotal(items));
}
```

## Comptime Tests

Zig's comptime enables compile-time testing — useful for type-level invariants:

```zig
test "buffer size is power of two" {
    comptime {
        const size = Buffer.capacity;
        try testing.expect(size > 0 and (size & (size - 1)) == 0);
    }
}
```

## Allocator-Aware Tests

Use `testing.allocator` to detect memory leaks — it fails the test if any allocation is not freed:

```zig
test "no memory leaks in parse" {
    const allocator = testing.allocator;
    const result = try parse(allocator, "hello world");
    defer allocator.free(result);
    try testing.expectEqual(@as(usize, 11), result.len);
}
```
