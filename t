For CPLCONFIG-36717, first locate the Step Function where performance optimization was previously implemented. Analyze its Git history, Lambda changes, optimization patterns, and tests. Use it as a reference for the Workflow Handler Step Function. Compare the implementations and identify which optimizations are applicable. Do not blindly copy changes. Preserve Workflow Handler business logic and show the proposed file-level changes with line numbers before editing.




Yesterday, I completed the optimization changes for the Workflow Handler Step Function story and deployed them to Dev2.

I also completed the Lambda-level testing. The execution time improved from around 4.8 seconds to 591 milliseconds, which is approximately an 85% improvement.

All 124 unit tests passed, and three direct Lambda invocations were successful. The DynamoDB records were also verified, and the existing functionality is working as expected in those tests.



Act as a senior Java Spring Boot and AWS DynamoDB performance engineer.

We are investigating a high-priority UAT timeout in the product-build-update-service (PBUS), specifically the updateInitiative API.

BACKGROUND:
- DEV1 has DynamoDB TTL cleanup, approximately every three days, whereas UAT and Production do not have this cleanup enabled.
- UAT contains accumulated records and updateInitiative is timing out.
- We previously fixed a similar issue in PBDS getTasksByUserRole, where DynamoDB queries were repeatedly executed inside nested product-line/team/entitlement loops. Fetching once per unique entitlement resolved that timeout.
- We need to determine whether updateInitiative has a similar issue, without assuming the root cause.

TASK 1 — TRACE THE ACTUAL API:
1. Locate UpdateInitiativeController.java and the updateInitiative endpoint.
2. Identify its HTTP method, request DTO, service implementation and all downstream calls.
3. Verify whether CardProdBuildRequest, newProductDetails, and cardProdBldTeamEnttlRoleCd are involved in this exact flow.
4. Distinguish normal initiative processing from expansion flow and confirm which path this endpoint executes.

TASK 2 — ANALYZE DYNAMODB OPERATIONS:
1. List every DynamoDB read, query, scan, batch operation and write along the reachable execution path.
2. Find operations inside loops or nested loops and determine their call-count formulas for one request.
3. Identify repeated reads using identical keys, filters or entitlement combinations.
4. Check scans, pagination, large result sets, unnecessary record processing, filtering of expired records and downstream API calls.
5. Identify whether the same data is retrieved repeatedly and whether it can safely be reused within a single request.
6. Separate required writes from redundant reads. Do not eliminate required updates.
7. Distinguish statically inferred call counts from counts that require runtime logs or instrumentation.

TASK 3 — ROOT CAUSE AND OPTIMIZATION:
1. Identify the most likely bottlenecks with evidence from code.
2. Propose the smallest safe optimization, similar to the PBDS deduplication approach where applicable.
3. Preserve existing business logic, approval status changes, DynamoDB updates, response structures, exception handling and ordering.
4. Do not introduce cross-request caching or change TTL configuration.
5. Suggest focused logging to count DynamoDB operations and measure their durations using one request/correlation ID.

TASK 4 — REPORT BEFORE CODING:
Provide a table containing file name, method, line number, DynamoDB operation, loop context, estimated calls per request, whether duplicate calls exist and proposed optimization.

Also provide:
- Full execution flow
- Evidence-backed potential root cause
- Expected before/after call counts
- Risks and required regression tests
- UAT validation approach

IMPORTANT: Do not modify any files yet. Do not invent call counts or claim the root cause is confirmed without evidence. First share your analysis and wait for my approval before implementing changes.
