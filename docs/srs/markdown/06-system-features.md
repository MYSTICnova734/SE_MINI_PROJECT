# 5. System Features

<!--
One subsection per feature from reqs.txt. Each REQ-ID should be unique - use the feature
prefix shown so IDs never collide when everyone edits this file.
Prefixes: ONB (onboarding), REC (edit records), ATT (attendance), GRD (grades), RET (retrieval), RBAC (roles)
-->

## 5.1 Onboarding

### 5.1.1 Description and Priority

**Description.** Onboarding is how user accounts are created in the Student Record System. An authenticated Admin creates Student and Teacher accounts and assigns each account a role. Self-registration is out of scope. The Admin never sets or knows the user's password. The user sets their own password through a secure initial-password setup, then logs in separately using their registered email address and password.

**Priority:** High. Every other feature needs an existing, authenticated account.

**Preconditions.**
- A pre-seeded Admin account exists (created during initial system setup).
- The Admin performing onboarding is authenticated.

**Inputs.**

| Account type | Unique identifier | Other required fields |
|---|---|---|
| Student | SRN | Name, email, academic/program details |
| Teacher | Staff ID | Name, email, department details |
| Admin (pre-seeded only) | Admin ID | Name, email, password |

The Admin also selects the role (Student or Teacher). Field lengths, data types and the final field list are defined in Appendix B.

**Assumptions and dependencies.**
- What each role may do after onboarding is defined in Section 5.6.
- The hashing algorithm, session handling, setup-credential validity period and delivery mechanism are defined in Section 6.3 (TBD).
- Email verification is out of scope.
- Identifier and email comparisons ignore letter case and leading/trailing whitespace.

### 5.1.2 Stimulus/Response Sequences

| # | Stimulus (trigger) | System validation | System response |
|---|---|---|---|
| SR-1 | Admin submits a valid account-creation request with a unique identifier and email. | Admin authenticated; required fields valid; identifier and email unique. | Account created as Active; password setup initiated; Admin sees a confirmation. No session is created for the new user. |
| SR-2 | Admin submits a request with a missing or invalid field. | Field validation fails. | No account created; every failing field is identified; entered non-password values are retained. |
| SR-3 | Admin submits an SRN, Staff ID, Admin ID or email already in use. | Uniqueness check finds a match. | Request rejected; existing account unchanged; error names the duplicated field. |
| SR-4 | A non-Admin or unauthenticated user attempts account creation. | Authentication/role check fails. | Access denied; no account created. |
| SR-5 | New user submits a valid password and matching confirmation using a valid setup credential. | Credential valid, unused, unexpired; password rules met. | Password hashed and stored; credential invalidated; user directed to log in separately. |
| SR-6 | New user submits a password that breaks the rules, does not match, or uses an invalid/expired credential. | Password or credential check fails. | Nothing stored; message states what failed. |
| SR-7 | User tries to log in before setting a password. | No password set for the account. | Login rejected with a generic authentication-failure message. |

### 5.1.3 Functional Requirements

- **REQ-ONB-001:** The system shall allow only an authenticated Admin to create accounts, and shall reject any other attempt with an access-denied message and no account created.
- **REQ-ONB-002:** The system shall provide no self-registration function, and shall provide a pre-seeded Admin account created during initial system setup (handling of its initial credential is specified in Section 6.3).
- **REQ-ONB-003:** The system shall require the Admin to select exactly one role (Student or Teacher) for each new account, and shall store the selected role with the account.
- **REQ-ONB-004:** For a Student account, the system shall require SRN, name, email and academic/program details (as defined in Appendix B).
- **REQ-ONB-005:** For a Teacher account, the system shall require Staff ID, name, email and department details (as defined in Appendix B).
- **REQ-ONB-006:** The system shall neither require nor accept a password from the Admin when creating a Student or Teacher account.
- **REQ-ONB-007:** The system shall trim leading and trailing whitespace from text inputs, and shall reject a request in which a required field is missing or blank, an email is not in a valid format (one "@" with non-empty parts and a "." in the domain), or any value violates the limits in Appendix B.
- **REQ-ONB-008:** When validation fails, the system shall create no account, shall display an error message identifying every invalid or missing field, and shall retain the entered non-password values.
- **REQ-ONB-009:** The system shall ensure that no two accounts share the same SRN, Staff ID, Admin ID or email address (compared without regard to letter case), including when two requests are submitted simultaneously.
- **REQ-ONB-010:** When a submitted identifier or email duplicates an existing account, the system shall reject the request, leave the existing account unchanged, and display an error message that names the duplicated field and discloses no other data of the existing account.
- **REQ-ONB-011:** The system shall set a successfully created account to Active with no approval step, and shall record the creation time and the creating Admin.
- **REQ-ONB-012:** Upon successful account creation, the system shall initiate a secure initial-password setup through which the user sets their own password, and shall never reveal that password to the Admin or any other user.
- **REQ-ONB-013:** The system shall issue the setup credential as single-use, bound to one account and valid for a limited period (period and delivery mechanism TBD in Section 6.3).
- **REQ-ONB-014:** The system shall reject a setup credential that is used, expired or invalid, shall set no password, and shall inform the user that the credential is not valid.
- **REQ-ONB-015:** The system shall require the password to be entered twice with matching entries, to have at least 8 characters, and to contain at least one uppercase letter, one lowercase letter, one digit and one special character; otherwise it shall not store the password and shall state which rule was not met.
- **REQ-ONB-016:** The system shall store a password only as a salted, adaptive, one-way hash (algorithm defined in Section 6.3), and shall not store, log or display it in plaintext.
- **REQ-ONB-017:** Upon successful password setup, the system shall invalidate the setup credential, shall create no authenticated session, and shall direct the user to log in separately.
- **REQ-ONB-018:** The system shall use the registered email address as the login identifier, and shall reject login for an account whose password is not yet set with the same generic message used for incorrect credentials.
- **REQ-ONB-019:** Upon successful account creation, the system shall show the Admin a confirmation containing the new account's identifier, name and role, and no password, hash or setup credential.
- **REQ-ONB-020:** The system shall create an account atomically, leaving no partial account if any step fails, and shall show a generic error message that exposes no internal details when an unexpected error occurs.

## 5.2 Edit Records

### 5.2.1 Description and Priority
TODO

### 5.2.2 Stimulus/Response Sequences
TODO

### 5.2.3 Functional Requirements
- REQ-REC-1:
- REQ-REC-2:

## 5.3 Mark Attendance (with constraints)

### 5.3.1 Description and Priority
TODO

### 5.3.2 Stimulus/Response Sequences
TODO

### 5.3.3 Functional Requirements
<!-- Nail down the actual constraint rules here, e.g. edit window, overlapping sessions, etc. -->
- REQ-ATT-1:
- REQ-ATT-2:

## 5.4 Mark Grades (with rubric)

### 5.4.1 Description and Priority
TODO

### 5.4.2 Stimulus/Response Sequences
TODO

### 5.4.3 Functional Requirements
<!-- Decide: fixed-schema rubric vs teacher-configurable rubric - document the decision. -->
- REQ-GRD-1:
- REQ-GRD-2:

## 5.5 Retrieval

### 5.5.1 Description and Priority
TODO

### 5.5.2 Stimulus/Response Sequences
TODO

### 5.5.3 Functional Requirements
- REQ-RET-1:
- REQ-RET-2:

## 5.6 Role-Based Access

### 5.6.1 Description and Priority

**Description.** Role-Based Access Control (RBAC) decides which functions and records each authenticated user may use. Every account has exactly one role: Admin, Teacher or Student. The role is assigned at account creation (Section 5.1), and only an Admin can change it. Permissions are enforced in both the frontend and the backend, and the backend is the authoritative enforcement layer. Anything not explicitly permitted to a role is denied. Authentication (Section 5.1 and Section 6.3) establishes who the user is, and authorization (this section) decides what that user may do.

**Priority:** High. Features 5.2 to 5.5 read and modify student data and depend on correct authorization.

**Roles and permissions.**

| Role | Permitted | Scope boundary | Not permitted |
|---|---|---|---|
| Admin | Create, update, deactivate Student and Teacher accounts; assign and change roles; view and manage student records, attendance and grades; view all Teacher and Student records | All relevant records | None defined in this version |
| Teacher | View assigned students; mark and edit attendance and enter and edit grades for assigned students; view academic records of assigned students | Assigned students only | Students outside the assignment; account and role management |
| Student | View own profile, attendance, grades and academic records | Own records only | Other students' records; modifying own grades or attendance |

**Assumptions and dependencies.**
- Attendance rules (Section 5.3) and grading rules (Section 5.4) apply in addition to RBAC.
- Session/token mechanism, audit-log retention and who may view the audit log are defined in Section 6.3 (TBD).
- How a Teacher is assigned to a Student is TBD. RBAC only requires that the assignment exists.
- TBD in this version: whether an Admin may deactivate their own or the last remaining Admin account, and how records and assignments are handled when an account's role changes.

### 5.6.2 Stimulus/Response Sequences

| # | Stimulus (trigger) | System validation | System response |
|---|---|---|---|
| SR-1 | Admin requests an Admin-permitted function (e.g. view any record, edit grades, deactivate an account). | Session valid; account Active; role is Admin. | Request processed and result shown. |
| SR-2 | Teacher requests an assigned student's record or attendance/grade function. | Session valid; role is Teacher; student is assigned to this Teacher. | Request processed, subject to Sections 5.3 and 5.4. |
| SR-3 | Teacher requests a student who is not assigned to them. | Student not in this Teacher's assignment. | "Access Denied/Unauthorized"; no data returned; attempt logged. |
| SR-4 | Student requests their own profile, attendance, grades or academic records. | Session valid; role is Student; record belongs to this Student. | Record displayed read-only. |
| SR-5 | Student requests another student's record, or tries to modify their own grades or attendance. | Record not owned, or modification not permitted for Student. | "Access Denied/Unauthorized"; data unchanged; attempt logged. |
| SR-6 | Any user requests a function not permitted for their role (e.g. Teacher changes a role). | Function not in the role's permission set. | "Access Denied/Unauthorized"; no change; attempt logged. |
| SR-7 | Admin changes a user's role. | Requester is Admin; account exists; new role is valid. | Role updated and effective immediately; change recorded; confirmation shown. |
| SR-8 | Deactivated user tries to log in or uses an existing session. | Account status is Deactivated. | Request rejected; no data returned; no new session created. |
| SR-9 | Unauthenticated user, or user with an expired/invalid session, requests a protected function. | Authentication check fails. | Request rejected; user directed to log in; no data returned. |

### 5.6.3 Functional Requirements

- **REQ-RBAC-001:** The system shall support exactly three roles (Admin, Teacher and Student) and shall associate every account with exactly one role at all times.
- **REQ-RBAC-002:** The system shall deny any function or record access that is not explicitly permitted to the requesting user's role.
- **REQ-RBAC-003:** The backend shall verify authentication and authorization (role and record scope) on every protected request before processing it, regardless of any frontend check.
- **REQ-RBAC-004:** The frontend shall display only the functions permitted to the logged-in user's role.
- **REQ-RBAC-005:** The system shall associate the authenticated user's role with the authenticated session, check it on every protected request, and not accept a client-supplied role, identity or ownership claim in its place.
- **REQ-RBAC-006:** The system shall deny a protected request whose session is missing, expired, invalid or inconsistent with the stored account, and for an unauthenticated user shall direct the user to log in without returning protected data.
- **REQ-RBAC-007:** The system shall allow an Admin to create, update and deactivate Student and Teacher accounts, and to assign and change roles.
- **REQ-RBAC-008:** The system shall allow an Admin to view and manage the records, attendance and grades of all students (subject to Sections 5.3 and 5.4) and to view all Teacher records.
- **REQ-RBAC-009:** The system shall allow a Teacher to view the list of students assigned to them, to mark and edit attendance and enter and edit grades for those students (subject to Sections 5.3 and 5.4), and to view those students' relevant academic records.
- **REQ-RBAC-010:** The system shall deny a Teacher any read or write access to a student who is not assigned to that Teacher, and shall evaluate the assignment on every request so a change takes effect on the next request (assignment mechanism TBD).
- **REQ-RBAC-011:** The system shall deny a Teacher the creation, update and deactivation of accounts and the assignment or change of roles.
- **REQ-RBAC-012:** The system shall allow a Student to view their own profile, attendance, grades and academic records.
- **REQ-RBAC-013:** The system shall deny a Student any access to another student's records, any modification of their own grades or attendance, and any Teacher or Admin function.
- **REQ-RBAC-014:** When a request is denied for lack of authorization, the system shall return a clear "Access Denied/Unauthorized" message, process no part of the request, leave data unchanged, and give the same response for a nonexistent record as for an unauthorized one.
- **REQ-RBAC-015:** When an authorization check cannot be completed because of an internal error, the system shall deny the request and show a generic error message that exposes no internal details.
- **REQ-RBAC-016:** The system shall allow only an Admin to assign or change a role, shall accept only Admin, Teacher or Student as the new role, and shall reject a role change for a nonexistent account with an error message.
- **REQ-RBAC-017:** The system shall apply a role change immediately, so that every later protected request (including from existing sessions) is authorized against the new role, shall keep exactly one role on the account, and shall record the affected account, previous role, new role, Admin and time.
- **REQ-RBAC-018:** The system shall allow only an Admin to deactivate an account, and shall invalidate all active sessions of that account immediately.
- **REQ-RBAC-019:** The system shall reject login by a deactivated account without creating a session, and shall deny every protected request made with a session of a deactivated account.
- **REQ-RBAC-020:** The system shall log every denied protected request and every failed authentication or session validation on a protected request (recording time, user identity and role if known, requested function or record, and outcome), shall not record passwords, hashes or session secrets in the log, and shall allow no role to modify or delete log entries through application functions.
- **REQ-RBAC-046:** The system shall not record passwords, password hashes or session secrets in the audit log.
- **REQ-RBAC-047:** Audit-log retention period and which roles may view the log are TBD and defined in Section 6.3.
