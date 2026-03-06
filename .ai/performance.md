# Performance Considerations

- Cache product prices for 5 minutes
- Batch database operations where possible
- Use database indexes for frequently queried fields
- Implement pagination for list endpoints (default: 20 items per page)
- Avoid N+1 queries — use eager loading
