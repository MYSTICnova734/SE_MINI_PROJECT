# Quality Attributes & Acceptance Tests

## Exit Criteria for Acceptance
System acceptance for deployment requires meeting the following criteria:
1. **Functional Completeness:** 100% of high-priority Functional Requirements (`SYS-F-001` through `SYS-F-020`) implemented and verified against acceptance criteria.
2. **NFR Compliance:** Performance response time ($\le 800\text{ ms}$ at 95th percentile) and concurrency (200 simultaneous transactions) validated through automated test scripts.
3. **Security Standards:** Zero high or critical security vulnerabilities detected; pass criteria met for all security requirements (`PRJ-SR-001` to `PRJ-SR-005`).
4. **Traceability Matrix:** 100% test case coverage verified across all requirements in the Requirements Traceability Matrix.

## Acceptance Test Suites

| Test Suite ID | Target Module / Area | Primary Test Focus | Target Criteria |
| :--- | :--- | :--- | :--- |
| **TS-AUTH** | Account Provisioning | User creation, temporary credential display, mandatory password reset. | TC-ACC-01 to TC-ACC-04 Pass |
| **TS-CRS** | Course & Schedule | Registration, student self-enrollment (max 6), roster visibility. | TC-CRS-01 to TC-CRS-04 Pass |
| **TS-ATT** | Attendance marking | Roll-call input, 48-hour automated lock, admin override. | TC-ATT-01 to TC-ATT-04 Pass |
| **TS-GRD** | Grade Lifecycle | Rubric calculation, `Draft` $\rightarrow$ `Published` states, regrade dispute. | TC-GRD-01 to TC-GRD-05 Pass |
| **TS-PERF** | System Performance | Latency $\le 800\text{ ms}$, 200 concurrent submission transactions. | TC-PERF-01, TC-PERF-02 Pass |
| **TS-SEC** | System Security | TLS enforcement, bcrypt hashing, JWT 48h timeout, RBAC check. | TC-SEC-01 to TC-SEC-05 Pass |
