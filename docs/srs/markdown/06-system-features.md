# System Features

<!--
One subsection per feature from reqs.txt. Each REQ-ID should be unique - use the feature
prefix shown so IDs never collide when everyone edits this file.
Prefixes: ONB (onboarding), REC (edit records), ATT (attendance), GRD (grades), RET (retrieval), RBAC (roles)
-->

## Onboarding

### Description and Priority

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

### Stimulus/Response Sequences

| # | Stimulus (trigger) | System validation | System response |
|---|---|---|---|
| SR-1 | Admin submits a valid account-creation request with a unique identifier and email. | Admin authenticated; required fields valid; identifier and email unique. | Account created as Active; password setup initiated; Admin sees a confirmation. No session is created for the new user. |
| SR-2 | Admin submits a request with a missing or invalid field. | Field validation fails. | No account created; every failing field is identified; entered non-password values are retained. |
| SR-3 | Admin submits an SRN, Staff ID, Admin ID or email already in use. | Uniqueness check finds a match. | Request rejected; existing account unchanged; error names the duplicated field. |
| SR-4 | A non-Admin or unauthenticated user attempts account creation. | Authentication/role check fails. | Access denied; no account created. |
| SR-5 | New user submits a valid password and matching confirmation using a valid setup credential. | Credential valid, unused, unexpired; password rules met. | Password hashed and stored; credential invalidated; user directed to log in separately. |
| SR-6 | New user submits a password that breaks the rules, does not match, or uses an invalid/expired credential. | Password or credential check fails. | Nothing stored; message states what failed. |
| SR-7 | User tries to log in before setting a password. | No password set for the account. | Login rejected with a generic authentication-failure message. |

### Functional Requirements

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

## Edit Records
 
### Description and Priority
 
**Description.** Edit Records lets an authorised user modify an existing student record after it has been created through onboarding (Section 5.1): personal and contact details, programme and section, and enrolment status. Records are never deleted. A student who leaves is marked Inactive instead, so that historical attendance and grades remain intact. Every edit is written to an audit trail. Corrections to attendance entries are covered in Section 5.3, and amendments to grades in Section 5.4.
 
**Priority:** High. Attendance, grading and retrieval all depend on the accuracy of the student record, so uncorrected errors spread to every other feature.
 
**Preconditions.**
- The student record exists (created through Section 5.1).
- The Administrator performing the edit is authenticated.
**Inputs.**
 
| Field | Editable | Notes |
|---|---|---|
| SRN and system-generated identifiers | No | Fixed once the record is created. |
| Name | Yes | |
| Email | Yes | Must remain unique. |
| Phone number, address | Yes | |
| Programme, section | Yes | |
| Enrolment status | Yes | Active or Inactive. Changing it requires confirmation. |
 
Field lengths, data types, mandatory status and the final field list are defined in Appendix B.
 
**Assumptions and dependencies.**
- Only Administrators may edit student records. What each role may do is defined in Section 5.6.
- The Administrator finds the record to edit using retrieval, defined in Section 5.5.
- The response-time target is defined in Section 6.1.
- Email comparisons ignore letter case and leading/trailing whitespace, as in Section 5.1.

### Stimulus/Response Sequences
 
| # | Stimulus (trigger) | System validation | System response |
|---|---|---|---|
| SR-1 | Administrator selects "Edit" on a student record found through retrieval. | Administrator authenticated; record exists. | Record displayed in an editable form showing the current values. |
| SR-2 | Administrator submits valid changes to one or more fields. | Role check passes; every field valid; unique fields remain unique; record unchanged by anyone else since it was opened. | All changes saved together; audit entry written; updated record displayed as confirmation. |
| SR-3 | Administrator submits an invalid value (for example a malformed email). | Field validation fails. | Nothing saved; message shown beside each invalid field; other entered values retained. |
| SR-4 | Administrator submits changes to a record that another user saved after it was opened. | Version check finds the record has changed. | Update rejected; user told the record has changed; latest values displayed so the edit can be re-applied. |
| SR-5 | Administrator sets a student's status to Inactive. | Confirmation required and given. | Record retained; student excluded from new attendance and grade entry; change logged. |
| SR-6 | A Teacher or Student attempts to edit a student record. | Role check fails. | Access denied; no record data disclosed; attempt logged. |
 
### Functional Requirements
 
- **REQ-REC-001:** The system shall allow only users with the Administrator role to edit student records.
- **REQ-REC-002:** The system shall allow the following fields to be edited: name, email, phone number, address, programme, section and enrolment status (full field list in Appendix B).
- **REQ-REC-003:** The system shall not allow the student's SRN or any system-generated identifier to be changed.
- **REQ-REC-004:** The system shall validate every submitted field against its type, length, format and mandatory status as defined in Appendix B, and shall reject invalid input with a message that names the field and the problem.
- **REQ-REC-005:** The system shall reject an edit that would make a unique field (such as email) duplicate that of another student record, and shall name the field in conflict.
- **REQ-REC-006:** The system shall apply all changes in a single submission together or not at all, leaving the record exactly as it was and showing an error message if saving fails for any reason.
- **REQ-REC-007:** The system shall detect when a record has been modified by someone else since the user opened it, shall reject the stale update, and shall display the current values.
- **REQ-REC-008:** The system shall write an audit entry for every successful edit containing the user, the date and time, the field changed, and its old and new values, and shall provide no means to modify or delete audit entries.
- **REQ-REC-009:** The system shall not permit a student record to be permanently deleted through the application; removing a student from active use shall be done by setting the enrolment status to Inactive, after the user confirms the action.
- **REQ-REC-010:** The system shall retain Inactive students' records, attendance and grades, shall keep them retrievable by Administrators, and shall exclude them from new attendance and grade entry.
- **REQ-REC-011:** The system shall allow an Administrator to reactivate an Inactive student, and shall log the change.
- **REQ-REC-012:** The system shall deny any edit attempt by an unauthorised user without disclosing record contents, and shall log the attempt with the user and time.
- **REQ-REC-013:** The system shall complete a record edit within the response-time target defined in Section 6.1.

## Mark Attendance (with constraints)

### Description and Priority
TODO

### Stimulus/Response Sequences
TODO

### Functional Requirements
<!-- Nail down the actual constraint rules here, e.g. edit window, overlapping sessions, etc. -->
- REQ-ATT-1:
- REQ-ATT-2:

## Mark Grades (with rubric)
 
### Description and Priority
 
**Description.** Mark Grades lets faculty record marks for students against a grading rubric, and lets students see their published results. A rubric is a set of weighted components (for example assignments, internal tests and a final exam). It is specific to each course rather than a fixed scheme for the whole institution. Each course has one **anchor faculty**: a faculty member teaching that course, designated by an Administrator. Only the anchor faculty can create or alter the course's rubric, which keeps the grading scheme consistent for every student in the course. Other faculty teaching the course can view the rubric and enter marks against it but cannot change it. Administrators can reassign the anchor faculty but cannot edit rubrics themselves. Marks are entered as drafts and become visible to students only when the anchor faculty publishes them. Changes after publication are restricted and logged.
 
**Priority:** High. Grading is one of the system's core purposes, and the rubric rules directly affect the correctness of every student's result.
 
**Preconditions.**
- The course exists and has at least one faculty member assigned to teach it.
- The user is authenticated.
- To enter marks, the course's rubric for that term has been defined, and the students are enrolled in the course.
**Inputs.**
 
| Data | Provided by | Details |
|---|---|---|
| Anchor faculty assignment | Administrator | The course, and the faculty member designated as its anchor. |
| Rubric component | Anchor faculty | Name (unique within the rubric), maximum mark greater than zero, weight greater than zero. |
| Mark | Faculty teaching the course | Student, rubric component, and a number from 0 to the component's maximum with at most two decimal places. |
| Amendment reason | Anchor faculty | Free text; required for every change made after publication. |
 
**Assumptions and dependencies.**
- What each role may do is defined in Section 5.6. Being the anchor faculty is an additional permission that applies to one course only.
- Courses, terms and the enrolment of students in courses are assumed to exist. How they are created is TBD.
- Marks and rubric changes are written to the same audit trail used in Section 5.2.
- The institution's letter-grade bands are TBD (see REQ-GRD-023).
- The response-time target is defined in Section 6.1.

### Stimulus/Response Sequences
 
| # | Stimulus (trigger) | System validation | System response |
|---|---|---|---|
| SR-1 | Anchor faculty submits a rubric whose weights total 100%. | User is the course's anchor faculty; component names unique; maximum marks and weights greater than zero; weights total 100%. | Rubric saved; change logged; confirmation displayed. |
| SR-2 | Anchor faculty submits a rubric whose weights do not total 100%. | Weight total check fails. | Nothing saved; current total displayed so it can be corrected. |
| SR-3 | A faculty member who is not the course's anchor opens the rubric page, or sends a change request directly. | Anchor check fails for any change. | Rubric displayed read-only with no editing controls; a direct change request is denied and logged. |
| SR-4 | Faculty member opens the gradebook for a course they teach. | User teaches the course; rubric exists. | Enrolled active students listed, with one column per rubric component. |
| SR-5 | Faculty member submits valid marks. | Every mark is a number within its component's range; faculty teaches the course; records unchanged since opened. | Marks saved as drafts; each student's weighted total recalculated and displayed. |
| SR-6 | Faculty member submits a mark that is outside the allowed range or not a number. | Range or number check fails. | Nothing from the submission saved; each invalid entry listed with its student, component and allowed range. |
| SR-7 | Anchor faculty selects "Publish". | User is the course's anchor faculty; all enrolled active students checked for missing marks. | If marks are missing, the students are listed and confirmation requested. On confirmation, grades become visible to students. |
| SR-8 | Student opens their results. | Student authenticated; grades published. | Only that student's grades shown, with each component's mark, maximum and weight, and the weighted total. |
| SR-9 | Anchor faculty corrects a mark after publication. | User is the anchor faculty; written reason supplied. | Mark updated and flagged as amended; old value, new value and reason logged; student sees the updated value. |
 
### Functional Requirements
 
- **REQ-GRD-001:** The system shall allow an Administrator to designate exactly one anchor faculty for each course, who must be a faculty member assigned to teach that course.
- **REQ-GRD-002:** The system shall allow only the anchor faculty of a course to create, modify or delete that course's rubric, and shall give other faculty of the same course and Administrators read-only access to it.
- **REQ-GRD-003:** The system shall define a rubric as one or more components, each having a name that is unique within the rubric, a maximum mark greater than zero, and a weight greater than zero.
- **REQ-GRD-004:** The system shall accept a rubric only if the component weights add up to exactly 100%, and shall otherwise reject it and display the current total.
- **REQ-GRD-005:** The system shall maintain a separate rubric for each course in each term, and shall allow the anchor faculty to copy a previous term's rubric as the starting point for a new one.
- **REQ-GRD-006:** The system shall allow the rubric to be modified freely while no marks have been recorded against it; if marks have been recorded but not published, the system shall warn the anchor faculty, require confirmation before saving and recalculate all affected totals; once grades are published, the system shall not allow the rubric to be changed.
- **REQ-GRD-007:** The system shall record every rubric creation and modification in the audit trail with the user, date and time, and the old and new values.
- **REQ-GRD-008:** The system shall allow an Administrator to reassign the anchor faculty of a course to another faculty member teaching it, with the change taking effect immediately, removing the previous anchor's rubric rights and being logged.
- **REQ-GRD-009:** The system shall not allow marks to be entered for a course until its rubric exists.
- **REQ-GRD-010:** The system shall allow a faculty member to enter and edit marks only for active students enrolled in courses that the faculty member teaches.
- **REQ-GRD-011:** The system shall accept a mark for a rubric component only if it is a number between 0 and that component's maximum mark inclusive, with at most two decimal places.
- **REQ-GRD-012:** The system shall reject an invalid mark with a message naming the student, the component and the allowed range, and when several marks are submitted together and any is invalid, shall report all invalid entries and save none of the submission.
- **REQ-GRD-013:** The system shall distinguish a mark of zero from a mark not yet entered, and shall display a student's total as "Incomplete" until every component has a mark.
- **REQ-GRD-014:** The system shall calculate each student's weighted total as the sum, over all components, of (mark ÷ maximum mark) × weight, rounded to two decimal places, and shall recalculate it automatically whenever a mark or the rubric changes.
- **REQ-GRD-015:** The system shall detect and reject a mark update based on stale data, in the same way as REQ-REC-007, and shall display the current value.
- **REQ-GRD-016:** The system shall record every mark entry and change in the audit trail with the user, date and time, student, component, and old and new values.
- **REQ-GRD-017:** The system shall deny any attempt by a user to view or change marks for a course they do not teach, without disclosing any marks, and shall log the attempt.
- **REQ-GRD-018:** The system shall allow only the anchor faculty to publish a course's grades, and if any enrolled active student has missing marks, shall list them and require confirmation before publishing.
- **REQ-GRD-019:** The system shall make unpublished marks visible only to the faculty teaching the course and to Administrators.
- **REQ-GRD-020:** The system shall allow a student to view only their own published grades, showing for each component the mark, maximum and weight, together with the weighted total.
- **REQ-GRD-021:** After publication, the system shall allow only the anchor faculty to amend a mark, shall require a written reason, shall flag the grade as amended, and shall record the old value, new value and reason in the audit trail.
- **REQ-GRD-022:** The system shall retain the marks of students who later become Inactive.
- **REQ-GRD-023:** The system shall convert a weighted total to a letter grade according to the institution's grade bands (TBD: the bands have not yet been confirmed and will be added once the grading policy is fixed).
- **REQ-GRD-024:** The system shall complete a mark entry or retrieval within the response-time target defined in Section 6.1.

## Retrieval

### Description and Priority
TODO

### Stimulus/Response Sequences
TODO

### Functional Requirements
- REQ-RET-1:
- REQ-RET-2:

## Role-Based Access

### Description and Priority

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

### Stimulus/Response Sequences

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

### Functional Requirements

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
