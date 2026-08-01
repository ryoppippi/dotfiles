# Mocking Reference

## Mock at System Boundaries

Use test doubles for dependencies outside the system under test:

- External APIs such as payment or email providers
- Databases when a test database is not practical
- Time and randomness
- The filesystem when an isolated filesystem is not practical

Do not mock modules, classes, or collaborators owned by the project. Test those through the public interface so the test follows behaviour rather than the call graph.

## HTTP APIs

For JavaScript and TypeScript HTTP clients, prefer request-level interception such as [MSW](https://mswjs.io/) over mocking `fetch`, Axios, or the project's API module. The production request code remains active, while the test controls the response at the network boundary.

```typescript
server.use(
	http.get('/api/products/:id', () => {
		return HttpResponse.json({ id: 'p-1', name: 'Mug' });
	}),
);

const product = await loadProduct('p-1');

expect(product).toEqual({ id: 'p-1', name: 'Mug' });
```

Model success, error, empty, and boundary responses with handlers. Assert the observable result or UI state, not that a handler or mock function was called.

## Designing for Boundaries

Pass external dependencies into the boundary-facing code when direct substitution is needed. Keep the interface specific to the external operation so each test double represents one meaningful scenario instead of reproducing a generic dispatcher.
