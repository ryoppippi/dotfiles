# Rust TDD Reference

## Running Tests

```bash
# Run all tests
cargo test

# Run tests in a specific module
cargo test cart::tests

# Run tests matching a name pattern
cargo test returns_zero_for_empty_cart

# Run only ignored tests (useful for slow/integration tests)
cargo test -- --ignored

# Show stdout even for passing tests
cargo test -- --nocapture
```

## Test Attributes

- `#[test]` — Mark a function as a test.
- `#[ignore]` — Skip this test by default. Use to sketch behaviours (like `it.todo`). Run with `cargo test -- --ignored`.
- `#[should_panic]` — Expect the test to panic. Optionally specify the message: `#[should_panic(expected = "out of bounds")]`.
- `#[cfg(test)]` — Compile the module only when testing.

## TDD Example

```rust
#[cfg(test)]
mod tests {
    use super::*;

    // Step 1: Sketch behaviours with #[ignore]
    #[test]
    #[ignore]
    fn applies_percentage_discount() {
        todo!()
    }

    #[test]
    #[ignore]
    fn never_returns_negative_total() {
        todo!()
    }

    // Step 2: Implement one at a time (Red → Green → Refactor)
    #[test]
    fn returns_zero_for_empty_cart() {
        assert_eq!(calculate_total(&[]), 0);
    }

    #[test]
    fn sums_item_prices() {
        let items = vec![Item { price: 10 }, Item { price: 20 }];
        assert_eq!(calculate_total(&items), 30);
    }

    // Use #[should_panic] for expected failure cases
    #[test]
    #[should_panic(expected = "price must be non-negative")]
    fn rejects_negative_price() {
        let items = vec![Item { price: -5 }];
        calculate_total(&items);
    }
}
```

## Doc Tests

Rust doc tests also run with `cargo test`. They serve as both documentation and tests:

````rust
/// Calculates the total price of items in the cart.
///
/// # Examples
///
/// ```
/// let items = vec![Item { price: 10 }, Item { price: 20 }];
/// assert_eq!(calculate_total(&items), 30);
/// ```
pub fn calculate_total(items: &[Item]) -> i64 {
    items.iter().map(|i| i.price).sum()
}
````

## Result-Based Tests

For tests that need error handling instead of panics:

```rust
#[test]
fn parses_valid_input() -> Result<(), Box<dyn std::error::Error>> {
    let result = parse("42")?;
    assert_eq!(result, 42);
    Ok(())
}
```
