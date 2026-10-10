# Appendix A: Glossary {.unnumbered}

This glossary defines the terms and abbreviations used in this SRS. Terms are grouped by topic and listed alphabetically within each group. The role names defined in A.1 are used consistently throughout the document.

## A.1 Users and Roles {.unnumbered}

| Term | Definition |
|------------|------------------------------------------------|
| Administrator | A user responsible for creating accounts, changing roles between Student and Faculty, deactivating and reactivating accounts, maintaining student records, designating the anchor faculty of each course, and amending attendance after the edit window has closed. Administrators can view rubrics and marks but cannot edit rubrics or enter or amend marks. Identified by an Administrator ID. |
| Anchor Faculty | The one faculty member, among those teaching a course, who has been designated by an Administrator as responsible for that course's rubric. Only the anchor faculty can create or alter the rubric, publish the course's grades, and amend published grades. |
| Faculty | A user who teaches one or more courses. Faculty mark attendance and enter grades only for courses they teach. Identified by a Staff ID. |
| Pre-seeded Administrator | An Administrator account created during initial system setup. Administrator accounts exist only this way: they cannot be created, assigned or removed through the application. |
| Role | The category of a user account (Administrator, Faculty or Student), which determines what the user may see and do. |
| Role-Based Access Control (RBAC) | The mechanism by which the system grants or denies each action according to the user's role and, where relevant, their relationship to a course (for example, being its anchor faculty). |
| Student | A user enrolled at the institution. A student can view only their own record, attendance and published grades. Identified by an SRN. |

## A.2 Accounts and Records {.unnumbered}

| Term | Definition |
|------------|------------------------------------------------|
| Account | The login identity of a user, consisting of a registered email address, a role and a password. |
| Account Status | Whether an account is Active or Inactive. An Inactive account cannot log in and has no valid authenticated sessions, but its record and all details are retained and remain viewable by Administrators. Only an Administrator can deactivate or reactivate an account. |
| Administrator ID | The unique identifier of an Administrator. |
| Audit Trail | The append-only log of changes made to student records, rubrics, marks, attendance and roles, and of denied requests and failed authentications. Each entry records who, when and what, including the old and new values for changes. It cannot be modified or deleted through the application, and it never contains passwords, hashes or authenticated-session secrets. |
| Active | The status of an account that is in use. New accounts are created as Active. |
| Inactive | The status of a deactivated account. The user cannot log in and their authenticated sessions are invalidated. For a student, the student is also excluded from new attendance and grade entry. The record, attendance, grades and all other details are retained and remain viewable by Administrators. Records are never deleted. |
| Onboarding | The process by which an Administrator creates a Student or Faculty account and assigns its role. Self-registration is not supported. |
| Record Version | A number stored with each editable record and changed on every update, used to detect stale updates. |
| Retrieval | Searching for and viewing records, attendance or grades, subject to the user's role. |
| Setup Credential | A single-use, time-limited token issued when an account is created, which allows the new user to set their own password. |
| SRN | Student Registration Number: the unique identifier of a student. It cannot be changed after the record is created. |
| Staff ID | The unique identifier of a Faculty member. |
| Stale Update | An attempt to save changes to a record that has been modified by someone else since the user opened it. The system rejects such updates. |
| Student Record | The stored details about a student: SRN, name, contact details, programme, section and account status. |

## A.3 Academic Structure {.unnumbered}

| Term | Definition |
|------------|------------------------------------------------|
| Course | A subject taught at the institution. |
| Course Offering | A course as taught in a particular term. Rubrics, enrolments and grades belong to a course offering. |
| Department | The academic department to which a Faculty member belongs. |
| Enrolment | The link between a student and a course offering. It determines which students a faculty member can mark attendance and grades for. |
| Programme | The degree or course of study that a student is following. |
| Section | A group of students within a programme who attend classes together. |
| Term | A defined period of teaching, such as a semester. |

## A.4 Attendance {.unnumbered}

| Term | Definition |
|------------|------------------------------------------------|
| Attendance Record | The record of one student's attendance status for one class session. |
| Class Session | A single scheduled meeting of a course offering at which attendance can be marked. This is distinct from an authenticated session (A.6). |
| Edit Window | The limited period after a class session during which a faculty member can correct an attendance entry. After it closes, only an Administrator can amend the entry, and the change is logged. Its length is specified in Section 5.3. |
| Overlapping Sessions | Class sessions whose times overlap. A student cannot be marked present in two overlapping sessions. |

## A.5 Grading {.unnumbered}

| Term | Definition |
|------------|------------------------------------------------|
| Amended Grade | A published mark that was changed by the anchor faculty after publication. It is flagged as amended and the reason is recorded in the audit trail. |
| Draft Grade | A mark that has been entered but not yet published. Draft grades are visible only to the faculty teaching the course and to Administrators. |
| Grade Bands | The ranges of weighted total that correspond to each letter grade. To be confirmed once the institution's grading policy is fixed. |
| Incomplete | The state of a student's weighted total while one or more rubric components have no mark entered. A mark of zero is different from a mark not yet entered. |
| Mark | The score awarded to one student for one rubric component. It must lie between 0 and that component's maximum mark. |
| Maximum Mark | The highest mark possible for a rubric component. |
| Publish | The action by which the anchor faculty makes a course's grades visible to its students. After publication, the rubric is locked and changes to marks require a recorded reason. |
| Published Grade | A grade that has been made visible to students by publication. |
| Rubric | The set of weighted components against which students in a course offering are graded. It is defined per course offering and altered only by the anchor faculty. |
| Rubric Component | One assessed item within a rubric, such as an assignment, internal test or final exam, with a name, a maximum mark and a weight. |
| Weight | The percentage that a rubric component contributes to the weighted total. The weights of all components in a rubric must add up to 100%. |
| Weighted Total | A student's overall result for a course offering, calculated as the sum over all components of (mark ÷ maximum mark) × weight. |

## A.6 Security and Technical Terms {.unnumbered}

| Term | Definition |
|------------|------------------------------------------------|
| API | Application Programming Interface: the set of requests through which the frontend communicates with the backend. |
| Atomic Operation | An operation that either completes in full or has no effect at all, leaving no partial changes. |
| Authentication | Verifying that a user is who they claim to be, by means of their email address and password. |
| Authenticated Session | The period after a successful login during which the system accepts a user's requests. This is distinct from a class session (A.4). The mechanism is defined in Section 6.3. |
| Authorisation | Deciding whether an authenticated user is permitted to perform a particular action. |
| Backend | The server-side application, built with Flask, that enforces access control, validation and business rules and is the only component that accesses the database. |
| Cloud Deployment | Running the system on a third-party provider's infrastructure (for example AWS, GCP, Azure or Firebase). Considered and not chosen (Appendix D). |
| Docker | A tool that packages an application and its dependencies into containers so that it runs the same way on any server. |
| Flask | The Python web framework used to build the backend. |
| Frontend | The browser-based user interface, built with React. |
| Hash (Salted Hash) | A one-way transformation of a password into a fixed string, combined with a random value (the salt) so that identical passwords produce different results. Passwords are stored only in this form. |
| MySQL | The relational database used by the system in development, testing and deployment. |
| ORM | Object-Relational Mapper: a library that lets the backend work with database tables as program objects. |
| Protected Request | A request for a function or data that requires the user to be authenticated and authorised. |
| React | The JavaScript library used to build the frontend. |
| REST API | An API in which the frontend requests data and actions from the backend over HTTP using standard methods. |
| Self-hosted Deployment | Running the system on servers owned and operated by the institution. This is the deployment model chosen for the system (Appendix D). |
| Serverless | A cloud model in which code runs as short-lived functions without a continuously running server. Considered and not chosen (Appendix D). |

## A.7 Project and Document Terms {.unnumbered}

| Term | Definition |
|------------|------------------------------------------------|
| Hypothetical Stakeholder | The fictional institutional representative used in place of a real customer to ground scope and design decisions. See Appendix D. |
| Requirement ID | The unique tag given to each functional requirement, in the form REQ-XXX-nnn. The prefixes are ONB (onboarding), REC (edit records), ATT (attendance), GRD (grades), RET (retrieval) and RBAC (role-based access). |
| Stimulus/Response Sequence (SR) | A numbered pairing of a user action (stimulus) and the system's behaviour in response, used to describe each feature. |
| TBD | To be determined: information not yet available at the time of writing. |

## A.8 Abbreviations {.unnumbered}

| Abbreviation | Expansion |
|------------|------------------------------------------------|
| CI/CD | Continuous Integration / Continuous Deployment |
| DPDP Act | Digital Personal Data Protection Act, 2023 (India) |
| HTTP(S) | Hypertext Transfer Protocol (Secure) |
| JSON | JavaScript Object Notation |
| NFR | Nonfunctional Requirement |
| SRS | Software Requirements Specification |
| UI | User Interface |
