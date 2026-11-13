<!-- Context: development/principles/guides/api-design | Priority: low | Version: 1.1 | Updated: 2026-02-15 -->

# Guide: API Design Patterns

**Core Idea**: REST APIs use nouns not verbs, proper HTTP methods, consistent response formats. GraphQL uses schema-first design with DataLoader for N+1.

---

## REST API

### Resource URLs
```
GET    /users      # List
POST   /users      # Create
PUT    /users/123  # Replace
PATCH  /users/123  # Partial update
DELETE /users/123  # Delete
```

### Status Codes
| Code | Use |
|------|-----|
| 200 | OK |
| 201 | Created |
| 204 | No Content (delete) |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 500 | Server Error |

### Response Format
```json
// Success
{ "data": {...}, "meta": { "timestamp": "..." } }

// Error
{ "error": { "code": "...", "message": "..." }, "meta": {...} }

// Collection
{ "data": [...], "meta": { "total": 100, "page": 1 } }
```

---

## GraphQL

### Schema Design
```graphql
type Query {
  user(id: ID!): User
  users(filter: UserFilter, page: Int): UserConnection!
}
type Mutation {
  createUser(input: CreateUserInput!): User!
}
```

### DataLoader (N+1 Prevention)
```javascript
const userLoader = new DataLoader(async (userIds) => {
  const users = await db.users.findMany({ where: { id: { in: userIds } } });
  return userIds.map(id => users.find(u => u.id === id));
});
```

---

## Versioning

- **URL path**: `GET /v1/users`
- **Header**: `Accept: application/vnd.api.v2+json`
- **Deprecation**: Use `Deprecation`, `Sunset`, `Link` headers

---

## Best Practices

- Use HTTPS
- Validate all inputs
- Paginate collections
- Implement rate limiting
- Use UUIDs (not internal IDs)
- Document with OpenAPI/GraphQL introspection

---

## Related

- `development/principles/clean-code.md`
