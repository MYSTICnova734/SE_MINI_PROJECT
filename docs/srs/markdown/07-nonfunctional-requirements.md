# Other Nonfunctional Requirements

## Performance Requirements
<!-- From reqs.txt: speed/efficiency. Be specific - response time targets, expected concurrent users. -->

These requirements give the response-time and capacity targets that Sections 5.2 to 5.5 refer to (for example REQ-REC-013 and REQ-GRD-024). They are based on the stakeholder discussion of 24 September 2026 (Appendix D), which established a design capacity of about 10,000 users with a few hundred concurrent users at peak (when faculty mark attendance at the start and end of class periods and when results are published) and a target of under two seconds for record retrieval under normal load. The numeric load levels below are team decisions that make those statements measurable.

**Definitions.**

| Term | Meaning |
|---|---|
| Response time | The time from the backend receiving a request to the backend completing its response, excluding network transfer and browser rendering. |
| Normal load | Up to 100 concurrent authenticated users. |
| Peak load | Up to 300 concurrent authenticated users. |
| Target met | At least 95% of the requests of that kind complete within the stated time. |


**Response time**
- **REQ-PER-001:** The system shall complete a student search or record retrieval (Section 5.5) within 2 seconds under normal load.
- **REQ-PER-002:** The system shall complete the saving of a record edit (Section 5.2), of an attendance submission for a class of up to 60 students (Section 5.3), and of a mark entry (Section 5.4) within 2 seconds under normal load. This is the response-time target referred to in REQ-REC-013, REQ-ATT-015 and REQ-GRD-024.
- **REQ-PER-003:** The system shall complete a login, from submission of the email and password to the start of the authenticated session, within 2 seconds under normal load.
- **REQ-PER-004:** The system shall complete the publication of a course's grades, including recalculation of the weighted totals of up to 60 students, within 5 seconds under normal load.
- **REQ-PER-005:** Under peak load, the system shall complete the operations in REQ-PER-001 to REQ-PER-003 within 5 seconds.

- 
**Capacity and verification**
- **REQ-PER-006:** The system shall support 10,000 user accounts and 300 concurrent authenticated users at peak load, with at least 99% of requests completing without a server error caused by load.
- **REQ-PER-007:** The system shall meet the targets in REQ-PER-001 to REQ-PER-005 with the volume of accumulated data stated in REQ-QUA-018.
- **REQ-PER-008:** Under peak load, the system shall not lose or duplicate any attendance entry, record edit or mark that it has confirmed to a user (REQ-QUA-003).
- **REQ-PER-009:** Before each release, the targets in this section shall be verified by a load test of the system, started from its Docker Compose configuration with the data volume stated in REQ-QUA-018, and the 95th-percentile response time for each operation at normal and peak load shall be recorded.

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
 
These are the operating principles of the system: who may do what, and under which circumstances. They are not functional requirements in themselves, but each is enforced by the requirements named in the Source column. The final group states the domain rules of the academic setting that the system models.
 
**Accounts and roles**
 
| ID | Rule | Source |
|------|----------------------------------------------|--------------|
| BR-001 | Every user holds exactly one role: Administrator, Faculty or Student. | 5.6 |
| BR-002 | Accounts are created only by an Administrator. There is no self-registration. Administrator accounts are pre-seeded during setup and cannot be created or assigned through the application. | 5.1, 5.6 |
| BR-003 | Each user sets their own password. No one else, including an Administrator, ever sets or knows it. | 5.1 |
| BR-004 | Every SRN, Staff ID, Administrator ID and email address is unique across all accounts. | 5.1 |
| BR-005 | Only an Administrator can change a role, and only between Student and Faculty. | 5.6 |
| BR-006 | Records are never deleted. A user who leaves is set to Inactive, which blocks their login while their details are retained and remain viewable by Administrators. | 5.2, 5.6 |
 
**Access to records**
 
| ID | Rule | Source |
|------|----------------------------------------------|--------------|
| BR-007 | A Faculty member can act only on the courses they teach and the students enrolled in them. | 5.6 |
| BR-008 | A Student can view only their own profile, attendance, published grades and academic records, and cannot change any of them. | 5.6 |
| BR-009 | Only an Administrator can edit student records. | 5.2 |
| BR-010 | Anything not explicitly permitted to a role is denied. | 5.6 |
 
**Attendance**
 
| ID | Rule | Source |
|------|----------------------------------------------|--------------|
| BR-011 | Attendance can be marked only for a scheduled class session. | 5.3 |
| BR-012 | A student cannot be marked present in two overlapping class sessions. | 5.3 |
| BR-013 | A Faculty member can correct an attendance entry only within the edit window. After it closes, only an Administrator can amend the entry, and the change is logged. | 5.3 |
 
**Grading**
 
| ID | Rule | Source |
|------|----------------------------------------------|--------------|
| BR-014 | Each course offering has exactly one anchor faculty, designated by an Administrator from the faculty teaching the course. | 5.4 |
| BR-015 | Only the anchor faculty can create or alter a course's rubric. Administrators and other faculty cannot. | 5.4 |
| BR-016 | The weights of a rubric's components add up to exactly 100%, and each mark lies between 0 and its component's maximum mark. | 5.4 |
| BR-017 | Grades are visible to students only after the anchor faculty publishes them. After publication the rubric is locked, and only the anchor faculty can amend a mark, with a recorded reason. | 5.4 |
 
**Traceability and data protection**
 
| ID | Rule | Source |
|------|----------------------------------------------|--------------|
| BR-018 | Every change to a student record, rubric, mark, attendance entry or role is recorded in the audit trail with who made it and when, and audit-trail entries cannot be altered. | 5.2, 5.4, 5.6, 6.3 |
| BR-019 | Personal data is handled in line with the Digital Personal Data Protection Act, 2023, and is visible only to the roles permitted to see it. | 6.3, 7.2 |
 
**Domain rules**
 
| ID | Rule | Source |
|------|----------------------------------------------|--------------|
| BR-020 | A student's weighted total for a course offering is the sum, over all rubric components, of (mark ÷ maximum mark) × weight. | 5.4 |
| BR-021 | A rubric belongs to a course offering, so the same course can have a different rubric in each term. | 5.4 |
| BR-022 | Conversion of a weighted total to a letter grade follows the institution's grade bands (TBD, Section 5.4). | 5.4 |
| BR-023 | A student's attendance and grades belong to a course offering, which is a course in a particular term. | 5.3, 5.4 |
