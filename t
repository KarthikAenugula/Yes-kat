For CPLCONFIG-36717, first locate the Step Function where performance optimization was previously implemented. Analyze its Git history, Lambda changes, optimization patterns, and tests. Use it as a reference for the Workflow Handler Step Function. Compare the implementations and identify which optimizations are applicable. Do not blindly copy changes. Preserve Workflow Handler business logic and show the proposed file-level changes with line numbers before editing.




Proceed with the minimal optimization for the `updateInitiative` flow only.

Before making changes, verify that the proposed TASK partition query retrieves all required records for all four handlers and preserves the existing filtering, record ordering, version numbering, VOID/PAPR transitions, and response behavior.

Once verified, implement the following:

1. Replace the four full-table GSI retrievals with the targeted TASK partition query.
2. Ensure DynamoDB pagination is handled correctly.
3. Add lightweight logging for DynamoDB query duration, page count, item count, and total request execution time.
4. Preserve all existing business logic, validations, writes, and exception handling.
5. Update the affected unit tests and add regression coverage for all four handlers.
6. Keep `getAllCardProdBuildInitiative()` unchanged for other consumers.
7. Do not modify TTL settings, WCDS template calls, repeated INIT queries, or unrelated endpoints.

If the targeted query cannot be proven functionally equivalent, stop and explain the differences before implementing.

After implementation, provide the exact files changed, a before-and-after comparison, and test results. Do not deploy or commit automatically.
