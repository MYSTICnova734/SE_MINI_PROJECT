# Non-Functional & Security Requirements

## Non-Functional Requirements

| Req ID | Requirement Statement | Category | Priority | Acceptance Criteria / Measurement |
| :--- | :--- | :--- | :--- | :--- |
| **SYS-NF-001** | The backend API shall process 95% of standard HTTP requests with a response time of less than 800 ms under a baseline load of 500 active sessions. | Performance | High | 95th percentile latency $< 800\text{ ms}$ verified via automated load suite. Test: TC-PERF-01 |
| **SYS-NF-002** | The database shall process 200 concurrent attendance and grade submission transactions without locking failures or transaction drops. | Concurrency | High | Automated concurrency test executes 200 simultaneous POST requests with 0% failure. Test: TC-PERF-02 |
| **SYS-NF-003** | The application shall maintain 99.0% operational availability during active academic term periods, excluding scheduled maintenance windows. | Availability | High | System uptime monitoring logs show $\ge 99.0\%$ monthly uptime. Test: TC-OPS-01 |
| **SYS-NF-004** | The web application interface shall be fully responsive across display viewports from 375px to 1920px width, allowing key workflows within 3 clicks. | Usability | Medium | UI audit passes responsiveness tests; roll-call execution completes in $\le 3$ clicks. Test: TC-UX-01 |
| **SYS-NF-005** | The software architecture shall strictly separate Presentation, Application, and Data layers with automated unit test coverage of $\ge 70\%$. | Maintainability | High | Automated test coverage tools confirm $\ge 70\%$ branch/statement coverage. Test: TC-QUAL-01 |

## Security

### Security Objectives

| ID | Objective Title | Description |
| :--- | :--- | :--- |
| **PRJ-SO-001** | Data Isolation & RBAC | Guarantee complete role-based data isolation so that student academic records, grades, and personal details are strictly confidential and accessible only to authorized users. |
| **PRJ-SO-002** | Workflow State Integrity | Ensure non-repudiation and integrity of academic records by enforcing immutable attendance rules (48-hour lock) and rigid grade state transitions (`Draft` $\rightarrow$ `Submitted` $\rightarrow$ `Under Review` $\rightarrow$ `Published`). |

### Security Requirements

| Req ID | Requirement Statement | Type | Priority | Source / Stakeholder | Acceptance Criteria / Test Ref | Comments / Dependencies |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **PRJ-SR-001** | All network communications between client web applications and system backend API services shall enforce TLS 1.3 encryption. | Security | High | Security | AC-PRJ-SR-001: Plain HTTP requests redirect to HTTPS; weak ciphers rejected. Test: TC-SEC-01 | TLS 1.3 configuration. |
| **PRJ-SR-002** | User account passwords shall be salted and hashed using bcrypt with a minimum work factor of 12 prior to database storage. | Security | High | Security | AC-PRJ-SR-002: Passwords stored strictly as bcrypt hashes in database tables. Test: TC-SEC-02 | Auth Module. |
| **PRJ-SR-003** | User sessions shall be authorized using HTTP-only JSON Web Tokens (JWT) with an automated expiration lifetime of 48 hours. | Security | High | Security | AC-PRJ-SR-003: Requests with tokens older than 48 hours return HTTP 401 Unauthorized. Test: TC-SEC-03 | Auth Middleware. |
| **PRJ-SR-004** | The system shall enforce Role-Based Access Control (RBAC) middleware on every API endpoint to restrict resource access according to user role. | Security | High | Security | AC-PRJ-SR-004: Accessing unauthorized role endpoints returns HTTP 403 Forbidden. Test: TC-SEC-04 | RBAC Middleware. |
| **PRJ-SR-005** | All user inputs shall be sanitized and parameterized using Object-Relational Mapping (ORM) queries to prevent SQL Injection and XSS attacks. | Security | High | Security | AC-PRJ-SR-005: Security vulnerability scans confirm 0 SQLi and XSS flaws on input forms. Test: TC-SEC-05 | Input Sanitization. |
