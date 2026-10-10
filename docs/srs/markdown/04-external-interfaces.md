# External Interface Requirements

## User Interfaces

The Student Record System is accessed by Admin, Teacher and Student users through a web-based frontend (Sections 2.3 and 5.6). Wireframes and mockups have not been produced for this version. Screen layouts and the interfaces for Sections 5.2 to 5.5 (records, attendance, grades, retrieval) are TBD until those sections are finalised.

**Interfaces required by the current requirements**

| Interface | Used by | Logical characteristics | Reference |
|---|---|---|---|
| Login | All roles | Takes the registered email address and password. Authentication failures show one generic message that does not reveal which part was wrong. A user with a missing, expired or invalid session is directed here. | REQ-ONB-018, REQ-SEC-002, REQ-RBAC-006 |
| Initial password setup | New Student/Teacher | Takes a password and a confirmation, using a single-use setup credential. On success the user is directed to log in separately and no session is created. | REQ-ONB-012 to 017 |
| Account creation | Admin | Takes role, unique identifier (SRN or Staff ID), name, email and program/department details (fields in Appendix B). No password field is shown. A confirmation shows identifier, name and role only. | REQ-ONB-001 to 012, REQ-ONB-019 |
| Account and role management | Admin | Provides update and deactivation of accounts and role assignment. Layout is TBD. | REQ-RBAC-007, 016 to 018 |
| Assigned-student view | Teacher | Lists the students assigned to the Teacher. Detailed screens for attendance and grade entry are TBD (Sections 5.3 and 5.4). | REQ-RBAC-009 |
| Own-record view | Student | Shows the Student's own profile, attendance, grades and academic records, read-only. | REQ-RBAC-012, 013 |

**Role-specific behaviour**

- The frontend displays only the functions permitted to the logged-in user's role (REQ-RBAC-004). The frontend is a convenience layer, and the backend enforces authorization on every request (REQ-RBAC-003).
- A request the user's role does not permit, including access to another user's record, produces an "Access Denied/Unauthorized" message and changes no data. Nonexistent and unauthorized records get the same response (REQ-RBAC-014).

**Message conventions**

- **Validation errors:** The message identifies every missing or invalid field and keeps the entered non-password values (REQ-ONB-008).
- **Duplicate identifier or email:** The message names the duplicated field and discloses no other data of the existing account (REQ-ONB-010).
- **Password rules and setup credential:** The message states which password rule failed, or that the credential is invalid (REQ-ONB-014, REQ-ONB-015).
- **Unexpected or authorization-check errors:** Only a generic message is shown, without stack traces, file paths, query text or other internal details (REQ-SEC-016, REQ-RBAC-015).
- **Passwords and hashes:** These are never displayed on any screen (REQ-SEC-004).

## Software Interfaces
 
The Student Record System is a three-tier web application: a React frontend, a Flask backend and a MySQL database, packaged as Docker containers on a Linux host (Sections 2.4 and 2.5). This section describes the software components the product connects to and the data that crosses each connection. Protocol-level details (HTTP conventions, encryption, message formats) are covered in Section 3.3, and detailed API definitions will be given in the design document. Requirement identifiers in brackets point to the requirements that govern each interface: `REQ-SEC` identifiers are in Section 6.3, and the others are in Section 5.
 
**Software components and interfaces**
 
| Component | Data exchanged | Purpose and conventions |
|----------|----------------------|----------------------------------------|
| **Frontend ↔ Backend** | Requests carrying user input, and responses carrying displayed records, confirmations and error messages, as JSON over HTTP(S). With each request the frontend sends the session identifier and, on state-changing requests, an anti-forgery token. | The React frontend presents role-appropriate functions and runs in a current version of Chrome, Firefox or Edge. The Flask backend exposes a REST API, validates all input and authorises every protected request through one common enforcement layer (REQ-SEC-011, REQ-SEC-013). The client cannot supply its own role, identity or ownership claim (REQ-RBAC-005). |
| **Backend ↔ Database** | Data categories established by this SRS: user accounts (identifier, name, email, role, account status), password hashes, setup credentials, student records, courses, course offerings, teaching assignments, enrolments, class sessions, attendance, rubrics, marks, and audit-trail entries. | MySQL stores all persistent data, in every environment (development, testing and deployment). The backend accesses it through an ORM such as SQLAlchemy (to be confirmed in the design document). User input reaches the database only as bound parameters (REQ-SEC-014). Account creation is atomic (REQ-ONB-020), and the uniqueness of SRN, Staff ID, Administrator ID and email is guaranteed even for simultaneous requests (REQ-ONB-009). The database schema is defined in the design document. |
| **Backend ↔ Session store** | Server-side authenticated session state and account status. | The server keeps the session state and gives the client only an opaque session identifier that contains no role or personal data. Role and account status are read from stored data on every protected request (REQ-SEC-008). The storage mechanism is TBD. |
| **Backend ↔ Password-hashing library** | Plain password in, salted hash out. | The backend hashes passwords with bcrypt, a unique salt and a cost factor of at least 10 (REQ-SEC-003, REQ-ONB-016). |
| **Backend ↔ Email delivery service** | Outbound email carrying the initial-password setup credential to the user's registered address. | Used only for onboarding (Section 5.1). No student records are sent by email (REQ-SEC-006, REQ-SEC-018). The email provider is TBD. |
| **Docker and Docker Compose** | Container images and configuration. | Packages the frontend, backend and MySQL database as containers on the institution's Linux server. A Compose file defines the services and the network between them. |
| **Continuous integration (Jenkins) and pytest** | Source code in; test results and static-analysis findings out. | The pipeline runs the pytest suite against the backend, with MySQL running in a container, and runs static code analysis. A release is blocked while high-severity findings remain (REQ-SEC-019). This is not a runtime interface. |
 
Exact versions of all components will be pinned in the project's dependency files (`requirements.txt`, `package.json`) and recorded in the design document. The current stable release of each component at the start of implementation will be used.
 
No third-party APIs are used, and student and user data is not disclosed to third parties (REQ-SEC-018).
 
**Data items exchanged between the frontend and backend**
 
| Data item | Direction | Purpose |
|------------------|-----------|--------------------------------------|
| Login credentials | In | Authenticate a user. The backend creates an authenticated session and returns an opaque session identifier, together with what the frontend needs to show the functions allowed for the user's role (Section 6.3). |
| Session identifier and anti-forgery token | In | Sent with each protected request to identify the authenticated session. The anti-forgery token is sent on state-changing requests. |
| Setup credential and new password | In | Submitted by a new user to set their own password (Section 5.1). |
| Student record fields | In and out | Create a record (Section 5.1), submit edits (Section 5.2), and display a record. Field definitions are in Appendix B. |
| Record version number | In and out | Sent with every edit so that the backend can detect stale updates (REQ-REC-007, REQ-GRD-015). |
| Account status and role changes | In | Submitted by an Administrator to deactivate or reactivate an account, or to change a role between Student and Faculty (Section 5.6). |
| Rubric definition (component name, maximum mark, weight) | In and out | Submitted by the anchor faculty to define or change a rubric. Returned to display the rubric (Section 5.4). |
| Anchor faculty assignment (course, faculty member) | In and out | Submitted by an Administrator to designate or reassign the anchor faculty for a course. |
| Marks (student, component, mark) | In | Submitted by faculty when entering or amending marks. |
| Grade results (marks, maximums, weights, weighted total, published and amended status) | Out | Returned to faculty and Administrators for the gradebook, and to a student for their own published results. |
| Amendment reason | In | Required text sent when a published mark is amended (REQ-GRD-021). |
| Attendance entries | In and out | Marking and viewing attendance (Section 5.3). |
| Search criteria and result sets | In and out | Retrieval of records, attendance and grades (Section 5.5). |
| Audit-trail entries | Out | Returned to the users permitted to review the history of changes (who may do so is defined in Section 6.3). They are written only by the backend and never submitted by the frontend. |
| Error messages | Out | Returned with the reason a request failed, such as invalid input, access denied or a conflicting update. They never include data the user is not permitted to see. |
 
**Data shared across components**
 
All persistent data is held in the database and shared between features through the following entities. Field-level layouts are in Appendix B, and the entity-relationship diagram is in Section 4.
 
- **User and Role:** the login identity (email), the role (Administrator, Faculty or Student), the account status (Active or Inactive) and the password hash. Used by every feature.
- **Setup Credential:** the single-use, time-limited token that lets a new user set their password (Section 5.1).
- **Student:** the student record created in Section 5.1 and edited in Section 5.2. Referenced by enrolment, attendance and grades.
- **Course and Course Offering:** a course in a particular term. Each offering has one anchor faculty and one or more teaching faculty.
- **Teaching Assignment:** links a Faculty member to a course offering they teach. It decides which students a faculty member can view and which courses they can mark attendance and marks for.
- **Enrolment:** links a student to a course offering.
- **Class Session:** a scheduled meeting of a course offering (Section 5.3).
- **Rubric and Rubric Component:** belongs to a course offering. Components hold the name, maximum mark and weight.
- **Mark:** one mark per student per rubric component, with its publication and amendment status.
- **Attendance Record:** one record per student per class session (Section 5.3).
- **Audit Trail:** an append-only record of every change to student records, rubrics, marks, attendance and roles, and of denied requests and failed authentications.
- **Authenticated Session state:** held in the session store, and not in the database unless the design document decides so.
**Implementation constraints on data sharing**
 
- The frontend shall never access the database directly. All data access goes through the backend API, which re-checks the user's role and ownership on every request, regardless of what the user interface displays.
- Operations that change several rows together, such as saving an edited record with its audit entry, or changing a rubric and recalculating totals, shall run in a single database transaction so that they succeed or fail as a whole.
- Every editable record carries a version number so that concurrent edits can be detected.

## Communications Interfaces

- **Client–server communication:** Users reach the system through a web browser. All client–server communication uses an encrypted connection (HTTPS). Unencrypted requests are rejected or redirected, and the session identifier is sent only over the encrypted connection and in a form not readable by client-side scripts (REQ-SEC-010). Protocol version and certificate arrangements are TBD.
- **Request/response model:** The frontend sends each user action to the backend and shows the backend's response. Every protected request carries the session identifier and is checked for authentication and authorization before processing (REQ-RBAC-003, REQ-RBAC-006). State-changing requests also carry a valid anti-forgery token tied to the session (REQ-SEC-015). A REST/JSON message format and API route conventions have not been established and are TBD.
- **Session communication:** The session identifier is opaque, is reissued at every successful login, and expires after 30 minutes of inactivity or 8 hours after login. A logged-out or expired session is rejected (REQ-SEC-008, REQ-SEC-009).
- **Backend–database communication:** The backend communicates with the database as described in Section 3.2. The connection mechanism and its security are TBD.
- **Email communication:** Email is used only to deliver the single-use initial-password setup credential, which is valid for 24 hours, to the user's registered address (REQ-SEC-006). Email contains no student records (REQ-SEC-018). Email verification, password-reset email and other notifications are out of scope in this version (Sections 5.1 and 6.3).
- **Other interfaces:** No communication with external systems or third-party services is required in this version. Transfer rates and synchronization requirements are not specified.
