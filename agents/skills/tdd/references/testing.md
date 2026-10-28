# Test Design Reference

## Good Tests

Good tests describe behaviour through a public interface. They use representative inputs, an independent expected result, and an assertion that would remain valid after an internal refactor.

```typescript
it('sums item prices', () => {
	expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```

Prefer one logical behaviour per test. Name the test after what a caller can observe, not after the function or implementation being exercised.

## Judging a test

Judge every test you write, change or keep against two imagined edits:

- **Break the behaviour.** Make the code return a wrong value, skip an effect or do it twice. If the test still passes, it proves nothing: its assertion is looser than the contract, its expected value comes from the code under test, or it asserts on data the test built itself.
- **Change the internals.** Keep every observable result and restructure the code underneath. If the test now fails, it is pinned to the implementation and catches no bug.

Keep a test that catches the first edit and survives the second; rewrite or delete the rest. The contract decides what is behaviour: the payload an external service receives is behaviour, a call to an internal helper is not; the error type callers branch on is the contract, the exact message wording usually is not.

Do not add a test that only replays the reported input through a small fix the diff already explains, copies a neighbouring test's setup for one more input (add a case to that test, or nothing), guards a dependency's bug, or asserts that a string, constant or config value still exists. The repository's own testing guidance, where it has some, takes precedence over this reference.

## Anti-patterns

### Implementation-coupled tests

Do not test private methods, internal call order, call counts, or mocks of collaborators owned by the project. These tests fail when the implementation changes even if the behaviour is unchanged.

### Tautological tests

Do not calculate the expected value with the same algorithm as the production code.

```typescript
it('sums item prices', () => {
	const items = [{ price: 10 }, { price: 5 }];
	const expected = items.reduce((sum, item) => sum + item.price, 0);

	expect(calculateTotal(items)).toBe(expected);
});
```

Use an independent, known result instead:

```typescript
it('sums item prices', () => {
	expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```

### Horizontal slicing

Do not write a complete batch of tests and then implement everything. Work in vertical slices: one test, one minimal implementation, and the feedback from that slice before choosing the next behaviour.
