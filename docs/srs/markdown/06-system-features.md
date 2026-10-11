# System Features

<!--
One subsection per feature from reqs.txt. Each REQ-ID should be unique - use the feature
prefix shown so IDs never collide when everyone edits this file.
Prefixes: ONB (onboarding), REC (edit records), ATT (attendance), GRD (grades), RET (retrieval), RBAC (roles)
-->

## Onboarding
 
### Description and Priority
 
**Description.** Onboarding is how user accounts are created in the Student Record System. An authenticated Administrator creates Student and Faculty accounts and assigns each account a role. Self-registration is out of scope. The Administrator never sets or knows the user's password. The user sets their own password through a secure initial-password setup, then logs in separately using their registered email address and password.
 
**Priority:** High. Every other feature needs an existing, authenticated account.
 
**Preconditions.**
- A pre-seeded Administrator account exists (created during initial system setup).
- The Administrator performing onboarding is authenticated.
**Inputs.**
 
| Account type | Unique identifier | Other required fields |
|---|---|---|
| Student | SRN | Name, email, academic/programme details |
| Faculty | Staff ID | Name, email, department details |
| Administrator (pre-seeded only) | Administrator ID | Name, email, password |
 
The Administrator also selects the role (Student or Faculty). Field lengths, data types and the final field list are defined in Appendix B.
 
**Assumptions and dependencies.**
- What each role may do after onboarding is defined in Section 5.6.
- The hashing algorithm, session handling, setup-credential validity period and delivery mechanism are defined in Section 6.3 (TBD).
- Email verification is out of scope.
- Identifier and email comparisons ignore letter case and leading/trailing whitespace.

### Stimulus/Response Sequences
 
| # | Stimulus (trigger) | System validation | System response |
|---|---|---|---|
| SR-1 | Administrator submits a valid account-creation request with a unique identifier and email. | Administrator authenticated; required fields valid; identifier and email unique. | Account created as Active; password setup initiated; Administrator sees a confirmation. No session is created for the new user. |
| SR-2 | Administrator submits a request with a missing or invalid field. | Field validation fails. | No account created; every failing field is identified; entered non-password values are retained. |
| SR-3 | Administrator submits an SRN, Staff ID, Administrator ID or email already in use. | Uniqueness check finds a match. | Request rejected; existing account unchanged; error names the duplicated field. |
| SR-4 | A non-Administrator or unauthenticated user attempts account creation. | Authentication/role check fails. | Access denied; no account created. |
| SR-5 | New user submits a valid password and matching confirmation using a valid setup credential. | Credential valid, unused, unexpired; password rules met. | Password hashed and stored; credential invalidated; user directed to log in separately. |
| SR-6 | New user submits a password that breaks the rules, does not match, or uses an invalid/expired credential. | Password or credential check fails. | Nothing stored; message states what failed. |
| SR-7 | User tries to log in before setting a password. | No password set for the account. | Login rejected with a generic authentication-failure message. |
 
### Functional Requirements
 
- **REQ-ONB-001:** The system shall allow only an authenticated Administrator to create accounts, and shall reject any other attempt with an access-denied message and no account created.
- **REQ-ONB-002:** The system shall provide no self-registration function, and shall provide a pre-seeded Administrator account created during initial system setup (handling of its initial credential is specified in Section 6.3).
- **REQ-ONB-003:** The system shall require the Administrator to select exactly one role (Student or Faculty) for each new account, and shall store the selected role with the account.
- **REQ-ONB-004:** For a Student account, the system shall require SRN, name, email and academic/programme details (as defined in Appendix B).
- **REQ-ONB-005:** For a Faculty account, the system shall require Staff ID, name, email and department details (as defined in Appendix B).
- **REQ-ONB-006:** The system shall neither require nor accept a password from the Administrator when creating a Student or Faculty account.
- **REQ-ONB-007:** The system shall trim leading and trailing whitespace from text inputs, and shall reject a request in which a required field is missing or blank, an email is not in a valid format (one "@" with non-empty parts and a "." in the domain), or any value violates the limits in Appendix B.
- **REQ-ONB-008:** When validation fails, the system shall create no account, shall display an error message identifying every invalid or missing field, and shall retain the entered non-password values.
- **REQ-ONB-009:** The system shall ensure that no two accounts share the same SRN, Staff ID, Administrator ID or email address (compared without regard to letter case), including when two requests are submitted simultaneously.
- **REQ-ONB-010:** When a submitted identifier or email duplicates an existing account, the system shall reject the request, leave the existing account unchanged, and display an error message that names the duplicated field and discloses no other data of the existing account.
- **REQ-ONB-011:** The system shall set a successfully created account to Active with no approval step, and shall record the creation time and the creating Administrator.
- **REQ-ONB-012:** Upon successful account creation, the system shall initiate a secure initial-password setup through which the user sets their own password, and shall never reveal that password to the Administrator or any other user.
- **REQ-ONB-013:** The system shall issue the setup credential as single-use, bound to one account and valid for a limited period (period and delivery mechanism TBD in Section 6.3).
- **REQ-ONB-014:** The system shall reject a setup credential that is used, expired or invalid, shall set no password, and shall inform the user that the credential is not valid.
- **REQ-ONB-015:** The system shall require the password to be entered twice with matching entries, to have at least 8 characters, and to contain at least one uppercase letter, one lowercase letter, one digit and one special character; otherwise it shall not store the password and shall state which rule was not met.
- **REQ-ONB-016:** The system shall store a password only as a salted, adaptive, one-way hash (algorithm defined in Section 6.3), and shall not store, log or display it in plaintext.
- **REQ-ONB-017:** Upon successful password setup, the system shall invalidate the setup credential, shall create no authenticated session, and shall direct the user to log in separately.
- **REQ-ONB-018:** The system shall use the registered email address as the login identifier, and shall reject login for an account whose password is not yet set with the same generic message used for incorrect credentials.
- **REQ-ONB-019:** Upon successful account creation, the system shall show the Administrator a confirmation containing the new account's identifier, name and role, and no password, hash or setup credential.
- **REQ-ONB-020:** The system shall create an account atomically, leaving no partial account if any step fails, and shall show a generic error message that exposes no internal details when an unexpected error occurs.

## Edit Records
 
### Description and Priority
 
**Description.** Edit Records lets an authorised user modify an existing student record after it has been created through onboarding (Section 5.1): personal and contact details, programme and section, and account status. Records are never deleted. A student who leaves is set to Inactive instead, which blocks their login while their record, attendance and grades are retained and remain viewable by Administrators. Every edit is written to an audit trail. Corrections to attendance entries are covered in Section 5.3, and amendments to grades in Section 5.4.
 
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
| Account status | Yes | Active or Inactive. Setting it to Inactive deactivates the account (login is blocked) and requires confirmation. |
 
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
| SR-5 | Administrator sets a student's account status to Inactive. | Confirmation required and given. | Account deactivated: login blocked and authenticated sessions invalidated; record retained and viewable by Administrators; student excluded from new attendance and grade entry; change logged. |
| SR-6 | A Faculty member or Student attempts to edit a student record. | Role check fails. | Access denied; no record data disclosed; attempt logged. |
 
### Functional Requirements
 
- **REQ-REC-001:** The system shall allow only users with the Administrator role to edit student records.
- **REQ-REC-002:** The system shall allow the following fields to be edited: name, email, phone number, address, programme, section and account status (full field list in Appendix B).
- **REQ-REC-003:** The system shall not allow the student's SRN or any system-generated identifier to be changed.
- **REQ-REC-004:** The system shall validate every submitted field against its type, length, format and mandatory status as defined in Appendix B, and shall reject invalid input with a message that names the field and the problem.
- **REQ-REC-005:** The system shall reject an edit that would make a unique field (such as email) duplicate that of another student record, and shall name the field in conflict.
- **REQ-REC-006:** The system shall apply all changes in a single submission together or not at all, leaving the record exactly as it was and showing an error message if saving fails for any reason.
- **REQ-REC-007:** The system shall detect when a record has been modified by someone else since the user opened it, shall reject the stale update, and shall display the current values.
- **REQ-REC-008:** The system shall write an audit entry for every successful edit containing the user, the date and time, the field changed, and its old and new values, and shall provide no means to modify or delete audit entries.
- **REQ-REC-009:** The system shall not permit a student record to be permanently deleted through the application; removing a student from active use shall be done by setting the account status to Inactive, which deactivates the account as specified in REQ-RBAC-018 and REQ-RBAC-019, after the Administrator confirms the action.
- **REQ-REC-010:** The system shall retain Inactive students' records, attendance and grades in full, shall keep them viewable and retrievable by Administrators, and shall exclude the students from new attendance and grade entry.
- **REQ-REC-011:** The system shall allow an Administrator to reactivate an Inactive student, restoring the student's ability to log in, and shall log the change.
- **REQ-REC-012:** The system shall deny any edit attempt by an unauthorised user without disclosing record contents, and shall log the attempt with the user and time.
- **REQ-REC-013:** The system shall complete a record edit within the response-time target defined in Section 6.1.

## Mark Attendance (with constraints)

### Description and Priority
**Description.** Mark Attendance lets Faculty members record whether each student was present or absent at a scheduled class session, and lets students view their own attendance. Attendance is recorded per student per class session, and only for sessions that have been scheduled. Two constraints apply. A student cannot be marked Present in two class sessions whose scheduled times overlap, and a Faculty member can correct an entry only within a limited edit window after the session. After that window only an Administrator can amend an entry, with a written reason and the change logged (Appendix D). Every entry and change is written to the audit trail.

**Priority:** High. Attendance is one of the system's core purposes, and the institution reported that attendance is currently entered late and cannot be traced to a person (Appendix D).

**Preconditions.**
- The class session exists in the schedule, for a course offering that the Faculty member teaches.
- The student is enrolled in that course offering and is Active.
- The user is authenticated.

**Inputs.**

| Data | Provided by | Details |
|---|---|---|
| Class session | Faculty member | A scheduled session of a course offering, with its date, start time and end time. |
| Attendance status | Faculty member | One status per listed student: Present or Absent. |
| Amendment reason | Administrator | Free text, required for every entry or amendment made by an Administrator. |

**Edit window.** A Faculty member can mark attendance for a session from its scheduled start time until 24 hours after its scheduled end time. The window is measured against the server clock. The length of the window is a team decision, since Appendix D leaves it open.

**Assumptions and dependencies.**
- What each role may do is defined in Section 5.6. A Faculty member's right to mark attendance depends on teaching the course offering.
- The schedule of class sessions is assumed to exist. How it reaches the system is TBD, and timetable generation is out of scope (Section 2.6).
- Enrolment of students in course offerings is assumed to exist (Section 2.6).
- Inactive students are excluded from new attendance entry (REQ-REC-010).
- Only the statuses Present and Absent are provided in this version. Other statuses, such as late or excused, are not.
- The response-time target is defined in Section 6.1. Marking attendance for a class of up to 60 students in under 2 minutes is covered by REQ-QUA-006.

### Stimulus/Response Sequences
| # | Stimulus (trigger) | System validation | System response |
|---|---|---|---|
| SR-1 | Faculty member opens attendance for a scheduled session of a course they teach, at or after its start time. | Authenticated; teaches the course offering; session is scheduled; start time reached. | Enrolled Active students listed, one entry each, showing the current status where one exists. |
| SR-2 | Faculty member submits a status for every listed student. | Every student has a status; no overlap conflict; records unchanged since opened. | All entries saved together; audit entries written; confirmation shows the number of students marked Present and Absent. |
| SR-3 | Faculty member submits Present for a student who is already Present in an overlapping session. | Overlap check fails. | Nothing from the submission saved; each conflicting student and session is named. |
| SR-4 | Faculty member tries to mark a session that is not scheduled, has not yet started, or belongs to a course they do not teach. | Schedule, time or teaching check fails. | Request rejected with a message stating the reason; a request for a course they do not teach is denied and logged. |
| SR-5 | Faculty member corrects an entry while the edit window is open. | Role, teaching and window checks pass. | Entry updated; old and new status logged. |
| SR-6 | Faculty member corrects an entry after the edit window has closed. | Window check fails. | Entry unchanged; user told that only an Administrator can amend it. |
| SR-7 | Administrator enters or amends an entry and supplies a reason. | Role is Administrator; reason supplied; overlap check passes. | Entry saved and flagged as amended; old status, new status and reason logged. |
| SR-8 | Faculty member or Administrator submits changes to attendance that another user saved after it was opened. | Version check finds the data has changed. | Update rejected; current values displayed so the edit can be re-applied. |
| SR-9 | Student opens their own attendance. | Authenticated; role is Student. | Own attendance shown read-only for each course, with a summary of sessions marked, sessions present and the attendance percentage. |
| SR-10 | A Student attempts to mark or change attendance, or a Faculty member requests attendance of a course they do not teach. | Role or teaching check fails. | Access denied; no data disclosed; attempt logged. |

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
**Description.** Retrieval lets users search for students and view stored information: student records, attendance and grades. It is read-only, and changes are made through Sections 5.2 to 5.4. Results are always limited to what the user's role permits (Section 5.6). An Administrator can retrieve all students, both Active and Inactive. A Faculty member can retrieve only Active students enrolled in the course offerings they teach. A Student can view only their own information and has no search function.

**Priority:** High. Every other feature depends on finding the right record, and Section 5.2 relies on retrieval to select the record to edit. The stakeholder agreed a response-time target for retrieval (Appendix D).

**Preconditions.**
- The user is authenticated.
- For a Faculty member, at least one Teaching Assignment exists.

**Inputs.**

| Search criterion | Available to | Details |
|---|---|---|
| SRN | Administrator, Faculty member | Exact match. |
| Name | Administrator, Faculty member | Partial match, not case-sensitive, at least 2 characters. |
| Programme, section | Administrator, Faculty member | Exact match. |
| Course offering | Administrator, Faculty member | A Faculty member can choose only course offerings they teach. |
| Account status (Active or Inactive) | Administrator only | Faculty members see only Active students. |

Criteria are optional and can be combined. Maximum lengths are defined in Appendix B. Phone number and address are not search criteria.

**What can be viewed.** Student records (Section 5.2), attendance (Section 5.3) and marks and grades (Section 5.4). Unpublished marks are visible only to the Faculty members teaching the course and to Administrators, and Students see only published grades (REQ-GRD-019, REQ-GRD-020).

**Assumptions and dependencies.**
- What each role may do is defined in Section 5.6.
- A Faculty member sees a student's academic details (SRN, name, programme, section) but not contact details (email, phone, address). This is a team decision.
- Results are shown 25 per page, which is a team decision.
- The response-time target is defined in Section 6.1.

### Stimulus/Response Sequences
TODO

### Functional Requirements
- **REQ-ATT-001:** The system shall allow only a Faculty member who teaches a course offering to mark attendance for that offering's class sessions, and shall deny any such attempt by other Faculty members, Students and Administrators, except as permitted by REQ-ATT-010.
- **REQ-ATT-002:** The system shall accept attendance only for a class session that exists in the schedule, and shall reject an attempt to mark any other session.
- **REQ-ATT-003:** The system shall allow a Faculty member to mark or correct attendance for a session only from its scheduled start time until 24 hours after its scheduled end time, measured against the server clock, and shall otherwise reject the attempt with a message stating why.
- **REQ-ATT-004:** The system shall list for marking only the students who are enrolled in the session's course offering and are Active, and shall not accept attendance for any other student.
- **REQ-ATT-005:** The system shall accept only the statuses Present and Absent, and shall reject a submission in which any listed student has no status, naming each such student.
- **REQ-ATT-006:** The system shall hold at most one attendance record per student per class session, and shall update that record rather than create a second one when attendance is submitted again.
- **REQ-ATT-007:** The system shall reject a Present entry for a student who is already Present in another class session whose scheduled time overlaps, where two sessions overlap if each starts before the other ends, and shall name the conflicting session. Sessions that only touch at a boundary do not overlap, and Absent entries are not checked.
- **REQ-ATT-008:** The system shall save a submission for a class session in full or not at all, and when any entry is invalid shall report every invalid entry and save none of them.
- **REQ-ATT-009:** After the edit window has closed, the system shall reject any correction by a Faculty member and shall tell the user that only an Administrator can amend the entry.
- **REQ-ATT-010:** The system shall allow an Administrator to enter or amend an attendance entry for any session at any time, shall require a written reason, shall apply REQ-ATT-007, and shall flag the entry as amended.
- **REQ-ATT-011:** The system shall detect and reject an attendance update based on stale data, in the same way as REQ-REC-007, and shall display the current values.
- **REQ-ATT-012:** The system shall write an audit entry for every attendance entry and change containing the user, the date and time, the student, the class session, the old and new status and any reason, and shall provide no means to modify or delete audit entries.
- **REQ-ATT-013:** The system shall show a Student only their own attendance, read-only, for each class session with its course, date, time and status, together with the number of sessions marked, the number marked Present and the attendance percentage (Present divided by marked, to two decimal places, or "Not available" when no session has been marked).
- **REQ-ATT-014:** The system shall deny a Student any marking or change of attendance, and shall deny a Faculty member any access to attendance of a course they do not teach, without disclosing any attendance data, and shall log the attempt (REQ-RBAC-020).
- **REQ-ATT-015:** The system shall complete an attendance save or retrieval within the response-time target defined in Section 6.1.

## Role-Based Access
 
### Description and Priority
 
**Description.** Role-Based Access Control (RBAC) decides which functions and records each authenticated user may use. Every account has exactly one role: Administrator, Faculty or Student. The role is assigned at account creation (Section 5.1), and only an Administrator can change it, and only between Student and Faculty. Administrator accounts are pre-seeded only (Section 5.1), so the Administrator role can neither be assigned nor removed through the application. Some permissions also depend on a user's relationship to a course, such as being its anchor faculty (Section 5.4). Permissions are enforced in both the frontend and the backend, and the backend is the authoritative enforcement layer. Anything not explicitly permitted to a role is denied. Authentication (Section 5.1 and Section 6.3) establishes who the user is, and authorisation (this section) decides what that user may do.
 
**Priority:** High. Features 5.2 to 5.5 read and modify student data and depend on correct authorisation.
 
**Roles and permissions.**
 
| Role | Permitted | Scope boundary | Not permitted |
|---|---|---|---|
| Administrator | Create, update and deactivate Student and Faculty accounts; change roles between Student and Faculty; view and manage student records (Section 5.2); view all attendance and grades, and amend attendance as allowed by Section 5.3; designate and reassign the anchor faculty of each course (Section 5.4); view all Faculty and Student records | All relevant records | Create, alter or delete rubrics; enter or amend marks |
| Faculty | View students enrolled in courses they teach; mark and edit attendance and enter and edit marks for those students; view the academic records of those students; as the anchor faculty of a course, also create and alter its rubric, publish its grades and amend published marks (Section 5.4) | Courses they teach, and the students enrolled in them | Students outside those courses; account and role management; editing student records; changing the rubric of a course for which they are not the anchor faculty |
| Student | View own profile, attendance, published grades and academic records | Own records only | Other students' records; modifying own grades or attendance |
 
**Assumptions and dependencies.**
- Attendance rules (Section 5.3) and grading rules (Section 5.4) apply in addition to RBAC.
- The authenticated session mechanism, audit-trail retention and who may view the audit trail are defined in Section 6.3 (TBD).
- A Faculty member's scope is determined by the courses they teach and the students enrolled in them. How courses, teaching assignments and enrolments are created is TBD (see Section 5.4). RBAC only requires that they exist.
- TBD in this version: whether an Administrator may deactivate their own or the last remaining Administrator account (Administrator accounts cannot be created through the application, so this could lock everyone out); and how records and teaching assignments are handled when an account's role changes between Student and Faculty.

### Stimulus/Response Sequences
 
| # | Stimulus (trigger) | System validation | System response |
|---|---|---|---|
| SR-1 | Administrator requests an Administrator-permitted function (e.g. view any record, designate an anchor faculty, deactivate an account). | Authenticated session valid; account Active; role is Administrator. | Request processed and result shown. |
| SR-2 | Faculty member requests the record, or an attendance or grade function, for a student enrolled in a course they teach. | Authenticated session valid; role is Faculty; student is enrolled in a course taught by this Faculty member. | Request processed, subject to Sections 5.3 and 5.4. |
| SR-3 | Faculty member requests a student who is not enrolled in any course they teach. | Student not enrolled in a course taught by this Faculty member. | "Access Denied/Unauthorized"; no data returned; attempt logged. |
| SR-4 | Student requests their own profile, attendance, grades or academic records. | Authenticated session valid; role is Student; record belongs to this Student. | Record displayed read-only. |
| SR-5 | Student requests another student's record, or tries to modify their own grades or attendance. | Record not owned, or modification not permitted for Student. | "Access Denied/Unauthorized"; data unchanged; attempt logged. |
| SR-6 | Any user requests a function not permitted for their role (e.g. Faculty member changes a role). | Function not in the role's permission set. | "Access Denied/Unauthorized"; no change; attempt logged. |
| SR-7 | Administrator changes a user's role. | Requester is Administrator; account exists; account is not an Administrator account; new role is Student or Faculty. | Role updated and effective immediately; change recorded; confirmation shown. A request involving the Administrator role is rejected with an error message. |
| SR-8 | Inactive user tries to log in or uses an existing authenticated session. | Account status is Inactive. | Request rejected; no data returned; no new authenticated session created. |
| SR-9 | Unauthenticated user, or user with an expired/invalid authenticated session, requests a protected function. | Authentication check fails. | Request rejected; user directed to log in; no data returned. |
 
### Functional Requirements
 
- **REQ-RBAC-001:** The system shall support exactly three roles (Administrator, Faculty and Student) and shall associate every account with exactly one role at all times.
- **REQ-RBAC-002:** The system shall deny any function or record access that is not explicitly permitted to the requesting user's role.
- **REQ-RBAC-003:** The backend shall verify authentication and authorisation (role and record scope) on every protected request before processing it, regardless of any frontend check.
- **REQ-RBAC-004:** The frontend shall display only the functions permitted to the logged-in user's role.
- **REQ-RBAC-005:** The system shall associate the authenticated user's role with the authenticated session, check it on every protected request, and not accept a client-supplied role, identity or ownership claim in its place.
- **REQ-RBAC-006:** The system shall deny a protected request whose authenticated session is missing, expired, invalid or inconsistent with the stored account, and for an unauthenticated user shall direct the user to log in without returning protected data.
- **REQ-RBAC-007:** The system shall allow an Administrator to create, update and deactivate Student and Faculty accounts, and to change roles between Student and Faculty (REQ-RBAC-016).
- **REQ-RBAC-008:** The system shall allow an Administrator to view and manage the records of all students (Section 5.2), to view the attendance and grades of all students and amend attendance as allowed by Section 5.3, to designate and reassign the anchor faculty of a course (Section 5.4), and to view all Faculty records, and shall not allow an Administrator to create, alter or delete rubrics or to enter or amend marks.
- **REQ-RBAC-009:** The system shall allow a Faculty member to view the students enrolled in the courses they teach, to mark and edit attendance and enter and edit marks for those students (subject to Sections 5.3 and 5.4), and to view those students' relevant academic records.
- **REQ-RBAC-010:** The system shall deny a Faculty member any read or write access to a student who is not enrolled in a course that the Faculty member teaches, and shall evaluate this on every request so that a change takes effect on the next request (how teaching assignments and enrolments are created is TBD).
- **REQ-RBAC-011:** The system shall deny a Faculty member the creation, update and deactivation of accounts, the assignment or change of roles, and the editing of student records.
- **REQ-RBAC-012:** The system shall allow a Student to view their own profile, attendance, published grades and academic records.
- **REQ-RBAC-013:** The system shall deny a Student any access to another student's records, any modification of their own grades or attendance, and any Faculty or Administrator function.
- **REQ-RBAC-014:** When a request is denied for lack of authorisation, the system shall return a clear "Access Denied/Unauthorized" message, process no part of the request, leave data unchanged, and give the same response for a nonexistent record as for an unauthorised one.
- **REQ-RBAC-015:** When an authorisation check cannot be completed because of an internal error, the system shall deny the request and show a generic error message that exposes no internal details.
- **REQ-RBAC-016:** The system shall allow only an Administrator to change an account's role, shall accept only Student or Faculty as the new role, shall not allow any account to be given the Administrator role or an Administrator account's role to be changed (Administrator accounts are pre-seeded only), and shall reject a role change for a nonexistent account with an error message.
- **REQ-RBAC-017:** The system shall apply a role change immediately, so that every later protected request (including from existing authenticated sessions) is authorised against the new role, shall keep exactly one role on the account, and shall record the affected account, previous role, new role, Administrator and time.
- **REQ-RBAC-018:** The system shall allow only an Administrator to deactivate or reactivate an account, shall invalidate all active authenticated sessions of that account immediately on deactivation, and shall retain all details of the account and keep them viewable by Administrators.
- **REQ-RBAC-019:** The system shall reject login by an Inactive account without creating an authenticated session, and shall deny every protected request made with an authenticated session of an Inactive account.
- **REQ-RBAC-020:** The system shall record in the audit trail every denied protected request and every failed authentication or session validation on a protected request (recording time, user identity and role if known, requested function or record, and outcome), shall not record passwords, hashes or authenticated-session secrets in it, and shall allow no role to modify or delete audit-trail entries through application functions.
