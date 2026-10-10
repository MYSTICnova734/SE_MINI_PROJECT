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
<!-- Pick 2-3 that matter: maintainability, usability, reliability - and be specific. -->

TODO

## Business Rules
<!-- Who can do what under which circumstances - ties directly into RBAC and grading rules. -->

TODO
