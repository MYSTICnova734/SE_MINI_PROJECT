# 3. External Interface Requirements

## 3.1 User Interfaces

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

## 3.2 Software Interfaces

The implementation stack (languages, frameworks, database product, hosting operating system) has not yet been fixed in the SRS (Sections 2.4 and 2.5 and Appendix D are incomplete). Items below are therefore marked TBD where not established.

| Component | Data exchanged | Purpose and conventions |
|---|---|---|
| **Frontend ↔ Backend** | Requests carrying user input, and responses carrying displayed records, confirmations and error messages. Sent from the frontend are the session identifier and, on state-changing requests, an anti-forgery token. | The frontend presents role-appropriate functions. The backend validates all input and authorizes every protected request through one common enforcement layer (REQ-SEC-011, REQ-SEC-013). The client cannot supply its own role, identity or ownership claim (REQ-RBAC-005). Frontend and backend frameworks: TBD. |
| **Backend ↔ Database** | Data categories established by the SRS: user accounts (identifier, name, email, role, status), password hashes, setup credentials, student records, attendance, grades, teacher–student assignments and audit-log entries. | Persistent storage for all system data. User input reaches the database only as bound parameters (REQ-SEC-014). Account creation is atomic (REQ-ONB-020), and uniqueness of SRN, Staff ID, Admin ID and email is guaranteed even for simultaneous requests (REQ-ONB-009). Database product, schema and the teacher–student assignment mechanism: TBD. |
| **Backend ↔ Session store** | Server-side session state and account status. | The server keeps session state and gives the client only an opaque identifier containing no role or personal data. Role and status are read from stored data on every protected request (REQ-SEC-008). The storage mechanism is TBD. |
| **Backend ↔ Password-hashing library** | Plain password in, salted hash out. | Passwords are hashed with bcrypt, a unique salt and cost factor of at least 10 (REQ-SEC-003). |
| **Backend ↔ Email delivery service** | Outbound email carrying the initial-password setup credential to the user's registered address. | Used only for onboarding. No student records are sent by email (REQ-SEC-006, REQ-SEC-018). Email-sending mechanism or provider: TBD. |
| **Continuous integration** | Source code in, static-analysis findings out. | Static code analysis runs in CI, and a release is blocked while high-severity findings remain (REQ-SEC-019). Not a runtime interface. |

No third-party APIs are used, and student and user data is not disclosed to third parties (REQ-SEC-018). The server operating system and other runtime dependencies are TBD pending Section 2.4.

## 3.3 Communications Interfaces

- **Client–server communication:** Users reach the system through a web browser. All client–server communication uses an encrypted connection (HTTPS). Unencrypted requests are rejected or redirected, and the session identifier is sent only over the encrypted connection and in a form not readable by client-side scripts (REQ-SEC-010). Protocol version and certificate arrangements are TBD.
- **Request/response model:** The frontend sends each user action to the backend and shows the backend's response. Every protected request carries the session identifier and is checked for authentication and authorization before processing (REQ-RBAC-003, REQ-RBAC-006). State-changing requests also carry a valid anti-forgery token tied to the session (REQ-SEC-015). A REST/JSON message format and API route conventions have not been established and are TBD.
- **Session communication:** The session identifier is opaque, is reissued at every successful login, and expires after 30 minutes of inactivity or 8 hours after login. A logged-out or expired session is rejected (REQ-SEC-008, REQ-SEC-009).
- **Backend–database communication:** The backend communicates with the database as described in Section 3.2. The connection mechanism and its security are TBD.
- **Email communication:** Email is used only to deliver the single-use initial-password setup credential, which is valid for 24 hours, to the user's registered address (REQ-SEC-006). Email contains no student records (REQ-SEC-018). Email verification, password-reset email and other notifications are out of scope in this version (Sections 5.1 and 6.3).
- **Other interfaces:** No communication with external systems or third-party services is required in this version. Transfer rates and synchronization requirements are not specified.
