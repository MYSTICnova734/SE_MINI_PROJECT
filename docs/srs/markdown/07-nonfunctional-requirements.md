# Other Nonfunctional Requirements

## Performance Requirements
<!-- From reqs.txt: speed/efficiency. Be specific - response time targets, expected concurrent users. -->

TODO

## Safety Requirements
 
The Student Record System does not control any physical equipment, so it poses no physical safety hazard and no safety certification is required. The harm it could cause is to the institution's data and to the people the data describes: records that are lost or corrupted, grades that are calculated wrongly, or consequential actions taken by mistake. The requirements below guard against these. Protection of personal data from unauthorised access is covered in Section 6.3.
 
**Data loss and recovery**
 
- **REQ-SAF-001:** The system shall support a full backup of the database at least once every 24 hours, and the 14 most recent backups shall be retained.
- **REQ-SAF-002:** Backups shall be stored on storage separate from the storage that holds the live database.
- **REQ-SAF-003:** The project shall provide a documented procedure for restoring the database from a backup, and the procedure shall be tested successfully before release. A restored system shall be in a consistent state, with the audit trail intact up to the time of the backup.
- **REQ-SAF-004:** After a restore, no more than 24 hours of changes shall be lost.
**Data integrity**
 
- **REQ-SAF-005:** The system shall run every operation that changes several records together as a single transaction, so that it completes in full or leaves no change (see REQ-REC-006, REQ-ONB-020 and Section 3.2).
- **REQ-SAF-006:** The database shall itself enforce uniqueness and referential integrity, so that an application defect cannot create orphaned data, such as a mark for a student or rubric component that does not exist.
- **REQ-SAF-007:** The system shall calculate marks and weighted totals using exact decimal arithmetic rather than floating-point arithmetic, so that rounding errors cannot change a student's result.
- **REQ-SAF-008:** When the database is unavailable, the system shall reject any request that would change data, shall show a clear message saying so, shall not apply any part of the request, and shall resume normal operation automatically when the database returns.
**Preventing mistakes**
 
- **REQ-SAF-009:** The system shall require explicit confirmation before it deactivates an account, publishes a course's grades, amends a published mark, or changes a rubric after marks have been recorded (see REQ-REC-009, REQ-GRD-006, REQ-GRD-018 and REQ-GRD-021).
- **REQ-SAF-010:** Development and test environments shall use synthetic data only, and shall never hold real student data.

## Security Requirements
<!-- From reqs.txt: auth. Password hashing approach, session handling, RBAC enforcement point. -->

Security requirements for authentication, password protection, session handling, authorization enforcement, and protection of student data. They complete the items that Sections 5.1 and 5.6 defer to this section: hashing algorithm, session mechanism, setup-credential rules, and audit-log rules. Functional behaviour of onboarding and role-based access is in Sections 5.1 and 5.6 and is not repeated here. The numeric values below (for example timeouts and the lockout threshold) are team decisions for this project; the other numbers are reasonable defaults for a student record system.

**Scope note.** Password change and password reset are not part of this version. Email is used only to deliver the initial-password setup credential (Section 5.1).

**Authentication and password protection**

- **REQ-SEC-001:** The system shall authenticate a user only by verifying the submitted password against the stored hash of the account matching the submitted registered email, and shall create a session only when verification succeeds for an Active account whose password has been set.
- **REQ-SEC-002:** The system shall return the same generic authentication-failure message, with no indication of which part was wrong, for an unknown email, an incorrect password, a deactivated account, a locked account, and an account whose password is not yet set.
- **REQ-SEC-003:** The system shall hash passwords with bcrypt using a unique random salt per password and a cost factor of at least 10, and shall verify passwords only by comparing against this hash.
- **REQ-SEC-004:** The system shall never return, display, log or export a password or password hash in any response, screen, report or log entry.
- **REQ-SEC-005:** The system shall lock login for an account for 15 minutes after 5 consecutive failed login attempts, shall reset the failure count after a successful login, and shall show the generic message of REQ-SEC-002 while the lock is active.
- **REQ-SEC-006:** The system shall generate each initial-password setup credential with a cryptographically secure random generator and at least 128 bits of randomness, deliver it to the user's registered email address, make it valid for 24 hours and for one use only, and invalidate it if the account is deactivated.
- **REQ-SEC-007:** The system shall take the pre-seeded Admin's initial credential from the initial system setup, apply the password rules of REQ-ONB-015 and the hashing of REQ-SEC-003 to it, and shall not hard-code it in source code or commit it to the project repository.

**Session and token security**

- **REQ-SEC-008:** The system shall keep session state on the server, shall give the client only an opaque session identifier generated with a cryptographically secure random generator and containing no role or personal data, shall issue a new identifier at every successful login, and shall obtain the user's role and account status from the server's stored data on every protected request.
- **REQ-SEC-009:** The system shall expire a session after 30 minutes without activity or 8 hours after login, whichever comes first, and shall invalidate the session on the server immediately when the user logs out; an expired or logged-out session shall be rejected on every protected request.
- **REQ-SEC-010:** The system shall carry all client-server communication over an encrypted connection, shall reject or redirect unencrypted requests, and shall send the session identifier only over that connection and in a form not readable by client-side scripts.

**Authorization enforcement and record confidentiality**

- **REQ-SEC-011:** The system shall perform all authorization checks in the backend in one common enforcement layer through which every protected request passes, so that a protected function is unreachable without passing the checks of REQ-RBAC-003, and a newly added protected function is denied until a role permission is defined for it.
- **REQ-SEC-012:** The system shall apply the access boundaries of Section 5.6 to every way of obtaining student data, including retrieval, search, lists, reports and exports, so that a result contains only records the requesting user is authorized to see.

**Input validation and protection against common attacks**

- **REQ-SEC-013:** The system shall validate the type, length and format of every user-supplied input in the backend, regardless of any frontend validation, and shall reject invalid input without processing it.
- **REQ-SEC-014:** The system shall never interpret user-supplied input as part of a query or command (it shall be passed to the data store only as bound parameters), and shall encode user-supplied data when displaying it so that it cannot run as script in the user's browser.
- **REQ-SEC-015:** The system shall reject any state-changing request that does not carry a valid anti-forgery token tied to the user's session.

**Secure error handling and audit logging**

- **REQ-SEC-016:** In every feature, the system shall show only generic error messages that contain no stack traces, file paths, query text, or other internal details, and shall record such details only in server-side logs.
- **REQ-SEC-017:** In addition to the events required by REQ-RBAC-020, the system shall log successful and failed logins, account lockouts, account creations, role changes and account deactivations, each with time, acting user, affected account and outcome; the log shall be retained for at least 1 year and shall be viewable only by Admins, read-only.

**Data protection and security validation**

- **REQ-SEC-018:** The system shall use student and user data only within the Student Record System, shall not disclose it to third parties, and shall not include student records in any email.
- **REQ-SEC-019:** The project's continuous integration shall run static code analysis, and a release shall not be made while high-severity security findings remain unresolved.

## Software Quality Attributes
 
The quality attributes below matter most to the institution and to the development team. They are listed in order of importance when two of them conflict:
 
1. **Correctness and data protection.** A wrong grade or a lost record does more harm than a slow page.
2. **Reliability.** Faculty must be able to rely on the system at the moments they need it, such as the start and end of class periods.
3. **Usability for Faculty,** who enter most of the data, over usability for occasional users.
4. **Maintainability and testability,** which the institution's IT team and the course guidelines both require.
5. **Performance beyond the targets in Section 6.1,** which is the lowest priority once the targets are met.

**Correctness**
 
- **REQ-QUA-001:** A release shall pass all of its automated tests and shall have no open defect of high or critical severity.

**Reliability and availability**
 
- **REQ-QUA-002:** The system shall be available at least 99% of the time in each calendar month during the institution's working hours, excluding planned maintenance announced at least 24 hours in advance.
- **REQ-QUA-003:** A change that the system has confirmed to the user shall not be lost, except through restoring a backup (REQ-SAF-004).
- **REQ-QUA-004:** If a container stops unexpectedly, the system shall restart it automatically and resume service without manual intervention.

**Usability**
 
- **REQ-QUA-005:** At least 90% of first-time users in usability testing shall be able to set their password and log in for the first time, without assistance, in under 5 minutes.
- **REQ-QUA-006:** A Faculty member shall be able to mark attendance for a class of up to 60 students in under 2 minutes.
- **REQ-QUA-007:** Every error message shall say what went wrong and, where possible, how to correct it, and shall expose no internal details (see REQ-RBAC-015).
- **REQ-QUA-008:** All functions shall be operable using the keyboard alone, and all text shall meet the WCAG 2.1 level AA colour-contrast requirement.

**Maintainability and debuggability**
 
- **REQ-QUA-009:** The software shall be organised in layers that separate request handling, business logic and data access, and each function in Section 5 shall be implemented in its own module.
- **REQ-QUA-010:** The system shall not hard-code configuration such as database addresses, credentials or email settings. They shall be supplied through environment variables or configuration files.
- **REQ-QUA-011:** The backend shall log errors with the time, a request identifier, the user identifier and the function involved, so that a failure can be traced without reproducing it. The log shall contain no passwords, session secrets or personal data other than identifiers.
- **REQ-QUA-012:** Static code analysis shall report no blocker or critical issues at release (see REQ-SEC-019).
- **REQ-QUA-013:** Every API endpoint shall be documented, with its purpose, inputs, outputs and error responses.

**Testability**
 
- **REQ-QUA-014:** Automated unit tests shall cover at least 80% of backend lines and at least 70% of backend branches, and the coverage shall be reported on every run of the CI pipeline.
- **REQ-QUA-015:** Every functional requirement in Section 5 shall be traced in Appendix C to at least one test case.

**Portability, extensibility and scalability**
 
- **REQ-QUA-016:** The whole system shall start on any Linux host that has Docker and Docker Compose installed, using one command, with no manual steps other than supplying configuration.
- **REQ-QUA-017:** A new function shall be addable without changing the existing Section 5 modules, other than registering the new function with the application.
- **REQ-QUA-018:** The system shall continue to meet the response-time targets in Section 6.1 with four years of accumulated data, which is about 20 million attendance records.

## Business Rules
<!-- Who can do what under which circumstances - ties directly into RBAC and grading rules. -->

TODO
