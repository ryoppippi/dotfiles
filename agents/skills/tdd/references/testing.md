# Test Design Reference

## Good Tests

Good tests describe behaviour through a public interface. They use representative inputs, an independent expected result, and an assertion that would remain valid after an internal refactor.

```typescript
it('sums item prices', () => {
	expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```

Prefer one logical behaviour per test. Name the test after what a caller can observe, not after the function or implementation being exercised.

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
