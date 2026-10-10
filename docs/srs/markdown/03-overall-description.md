# Overall Description
 
## Product Perspective
 
The Student Record System is a new, self-contained product. It replaces the spreadsheets and departmental registers the institution currently uses for student details, attendance and grades (Appendix D). It is not a follow-on to an earlier system and is not a component of a larger one. In this release it does not exchange data with any other institutional system. Integration with the university's single sign-on service has been deferred (Section 1.3).
 
The system is a three-tier web application, shown below.
 
```
  Administrator / Faculty / Student
  (web browser running the frontend)
                  |
                  |  HTTP(S), JSON
                  v
  +-------------------------------------+
  |  Backend: Flask application         |
  |  Authentication, role-based access, |
  |  validation, business rules,        |
  |  audit trail                        |
  +-------------------------------------+
                  |
                  |  ORM / SQL
                  v
  +-------------------------------------+
  |  Database: MySQL                    |
  +-------------------------------------+
 
  Frontend: React single-page application,
  served to the browser by the system.
 
  All components run as Docker containers on
  the institution's own servers (self-hosted).
```
 
Users reach the system through a standard web browser. The React frontend presents the user interface. The Flask backend is the only component that reads or writes data, and it enforces authentication, role-based access, validation and business rules on every request, so checks in the frontend are only a convenience (REQ-RBAC-003). MySQL stores all persistent data, including the audit trail, and is the same database in development, testing and deployment. The system is self-hosted because the institution's users are mostly on or near the campus, so a cloud provider's wide geographic reach offers little benefit, and the institution's own IT team can maintain it (Appendix D).
 
**Interfaces to the outside.** The system has only two:
 
- the users' web browsers (Sections 3.1 and 3.3); and
- the means of delivering the setup credential that lets a new user set their own password. The delivery mechanism is TBD in Section 6.3.
**How the major parts relate.** Account management and role-based access (5.1 and 5.6) underlie every other function, since nothing can be done without an authenticated account that has the right role. Student records (5.2) are the foundation that attendance (5.3) and grading (5.4) attach to. Retrieval (5.5) reads all of them. The audit trail records changes made through every function.
 
Because deferred features such as fee management and a parent portal are expected to follow, the parts above are kept separate so that new functions can be added without changing the existing ones.
 
## Product Functions
 
The system provides the functions below. Each is specified in detail in the Section 5 subsection shown.
 
| Function | Summary | Main users | Section |
|----------|----------------------------------------------|-----------|-----|
| Onboarding | Administrators create Student and Faculty accounts. Each new user sets their own password through a secure one-time setup and then logs in with their email address. There is no self-registration. | Administrator | 5.1 |
| Edit Records | Administrators correct and update student records. Every edit is audited. A student who leaves is set to Inactive, which blocks login but keeps the record, attendance and grades. | Administrator | 5.2 |
| Mark Attendance | Faculty mark attendance for the class sessions of courses they teach. The system enforces the attendance rules: attendance can be marked only for scheduled sessions, a student cannot be present in two overlapping sessions, and entries can be corrected only within a limited window, after which only an Administrator can amend them. | Faculty, Administrator | 5.3 |
| Mark Grades | The anchor faculty of each course defines that course's rubric. Faculty teaching the course enter marks against it, and the system calculates each student's weighted total. The anchor faculty publishes the grades, after which students can view their own. Later corrections need a recorded reason. | Faculty, Student | 5.4 |
| Retrieval | Users search for and view student records, attendance and grades, limited to what their role allows. | Administrator, Faculty, Student | 5.5 |
| Role-Based Access | Every account has exactly one role: Administrator, Faculty or Student. Anything not explicitly permitted to a role is denied, and the backend enforces this on every request. Administrators can change roles between Student and Faculty and can deactivate or reactivate accounts. | All users | 5.6 |
 
**Capabilities that apply across the functions.**
 
- **Authentication.** Users log in with their registered email address and password. See Sections 5.1 and 6.3.
- **Audit trail.** Changes to records, rubrics, marks, attendance and roles, and denied requests, are recorded and cannot be altered through the application. See Sections 5.2, 5.4, 5.6 and 6.3.
- **Performance and security.** Retrieval and updates must meet the response-time target, and student data must be protected in line with the DPDP Act, 2023. See Sections 6.1 and 6.3.

## User Classes and Characteristics
 
The Student Record System has three user classes: Administrator, Faculty and Student. Every account holds exactly one of these roles, and access to functions and records depends on that role (Section 5.6). Accounts are created only by an Administrator (Section 5.1), so a person cannot register themselves into any user class. Administrator accounts are pre-seeded during initial system setup and cannot be created or assigned through the application. The detailed permissions of each class are specified in Section 5.6 and are not repeated here.
 
The descriptions of technical proficiency and frequency of use below are assumptions made for this project, not established requirements. They are based on an institution of about 10,000 students and staff (Appendix D). The user classes, their access levels and their limitations follow from Sections 5.1 and 5.6.
 
### Administrator
 
- **Purpose:** Administers the system. The Administrator creates and maintains user accounts and keeps the student data accurate.
- **Main functions:** Creates, updates, deactivates and reactivates Student and Faculty accounts; changes roles between Student and Faculty; edits student records; views all attendance and grades and amends attendance as allowed by Section 5.3; designates and reassigns the anchor faculty of each course.
- **Access level:** Highest privilege, with deliberate limits (see below). The Administrator can access all relevant student and faculty records.
- **Information accessed:** Account details of all users, and the records, attendance and grades (including unpublished grades) of all students.
- **Technical proficiency (assumed):** Moderate. The Administrator is expected to be comfortable with administrative web applications and data entry, but needs no programming knowledge.
- **Frequency of use (assumed):** Periodic. Use is concentrated around account setup and record maintenance, with ad hoc use whenever accounts or records need correction.
- **Important characteristics and limitations:** Only an Administrator can manage accounts and roles. An Administrator cannot create, alter or delete rubrics, and cannot enter or amend marks, which keeps grading with the faculty who teach the course. Administrator accounts exist only because they were pre-seeded at initial setup. The Administrator never sets or knows a user's password, because each user sets their own.

### Faculty
 
- **Purpose:** Records and maintains the academic information of the students in the courses they teach.
- **Main functions:** Views the students enrolled in the courses they teach, marks and edits attendance (within the rules in Section 5.3), enters and edits marks against the course rubric, and views the relevant academic records of those students.
- **Anchor faculty:** For each course, an Administrator designates one of the faculty teaching it as the anchor faculty. In addition to the functions above, the anchor faculty creates and alters that course's rubric, publishes its grades, and amends published marks (Section 5.4). Other faculty teaching the course can view the rubric but not change it.
- **Access level:** Restricted to the courses they teach and the students enrolled in them.
- **Information accessed:** Attendance, marks and academic records of the students enrolled in their courses only.
- **Technical proficiency (assumed):** Basic to moderate. Faculty are expected to use standard web forms and tables for data entry and lookup.
- **Frequency of use (assumed):** Regular during the academic term, mainly for attendance and mark entry. Use peaks at the start and end of class periods, when attendance is marked.
- **Important characteristics and limitations:** A Faculty member cannot access students outside their courses, cannot manage accounts or roles, and cannot edit student records. Only the anchor faculty of a course can change its rubric.

### Student
 
- **Purpose:** Views their own academic information held by the institution.
- **Main functions:** Views their own profile, attendance, published grades and academic records.
- **Access level:** Lowest privilege. Access is limited to the Student's own records and is read-only.
- **Information accessed:** Their own profile, attendance, published grades and academic records only. Grades are visible only after the anchor faculty has published them.
- **Technical proficiency (assumed):** Basic. The Student is expected to be able to log in and read information presented on screen.
- **Frequency of use (assumed):** Occasional, typically to check attendance or grades. Use rises sharply when results are published.
- **Important characteristics and limitations:** A Student cannot access any other student's records and cannot modify their own grades or attendance. Students are by far the most numerous user class, and their access depends on an Administrator creating their account. A Student whose account is Inactive cannot log in.
**Priority of user classes.** Faculty are the most important class to satisfy. They enter most of the data, so the accuracy and timeliness of attendance and grades depend on the system being quick and easy for them to use. Administrators come next, because correct accounts and records underlie every other function. Students are the largest class but only read information, so their needs centre on simple login and clear results.

## Operating Environment
 
**Server environment.** The system runs on servers owned and operated by the institution (decision of 24 September 2026, Appendix D). It is packaged as Docker containers, one each for the frontend, the backend and the MySQL database, defined together in a Docker Compose file. The host therefore needs only to support Docker. A Linux server is expected, but the host operating system and hardware are for the institution's IT team to choose (TBD with the IT team). The system must coexist with the other systems the IT team already runs, and must not require changes to them.
 
**Capacity.** The system is designed for about 10,000 users, with a few hundred concurrent users at peak times, such as when faculty mark attendance at the start and end of class periods and when results are published (Appendix D). Hardware sizing is TBD and will be given in the deployment documentation.
 
**Client environment.** Users need only a standard web browser, namely a current version of Chrome, Firefox or Edge. No client software is installed. The interface is designed mainly for desktop and laptop screens. Whether phones and tablets are supported is TBD in Section 3.1.
 
**Network.** Users reach the system over the institution's network. Nearly all users are on or near the campus (Appendix D), so the system does not need to serve a geographically distributed user base or balance load across regions. Whether it is also reachable from off-campus is a matter for the IT team's network arrangements and is not specified here. Browsers communicate with the server over HTTP(S) (Section 3.3).
 
**Other software.** Apart from the software inside its own containers, the system relies on the institution's backup facilities, since the database is backed up regularly (Appendix D). If an email service is used to deliver setup credentials, it must also be reachable from the server. This is TBD in Section 6.3.

<!-- Cite the deployment decision, e.g.: "Per stakeholder discussion,
     DD-Mon-YYYY (Appendix D), the system will be self-hosted via Docker." -->

## Design and Implementation Constraints
 
The following constraints limit the options available to the developers. Where a constraint comes from the stakeholder discussions, the date is given (Appendix D).
 
**Deployment**
 
- The system shall be self-hosted on the institution's own servers and packaged with Docker (24 September 2026). Cloud and serverless deployment were considered and rejected, so the design must not depend on any cloud provider's services.
- The software shall be open source and maintainable by the institution's existing IT team, with no paid licences.
**Technology**
 
- The frontend shall be built with React and the backend with Flask (Python).
- The database shall be MySQL in every environment: development, testing and deployment. No other database is used.
- The frontend and backend shall communicate through a REST API using JSON (Section 3.2).
- Exact versions of all components shall be pinned in the project's dependency files and recorded in the design document.
**Architecture**
 
- The backend shall be the only component that accesses the database. The frontend shall never access it directly.
- All authentication, authorisation and validation shall be enforced in the backend. Checks in the frontend are for convenience only (REQ-RBAC-003).
- Operations that change several rows together shall run in a single database transaction, and editable records shall carry a version number so that stale updates are detected (Section 3.2).
- The design shall be modular and extensible, so that the deferred features (fee management, timetable generation, a parent portal and single sign-on integration) can be added later without reworking the existing functions (6 October 2026).
**Security and privacy**
 
- Passwords shall be stored only as salted, adaptive, one-way hashes, never in plaintext (REQ-ONB-016). The algorithm is defined in Section 6.3.
- Access shall be role-based and deny by default (Section 5.6).
- Student records are personal data and shall be handled in compliance with the Digital Personal Data Protection Act, 2023 (24 September 2026).
- The audit trail shall be append-only and shall not be modifiable through the application.
- Student records shall not be permanently deleted through the application (REQ-REC-009). Their retention period follows the university's records policy (TBD).
- The database shall be backed up regularly.
**Performance**
 
- Record retrieval shall take under two seconds under normal load, with the system designed for about 10,000 users and a few hundred concurrent users at peak (24 September 2026). See Section 6.1.
**Development process (course guidelines)**
 
- Development shall follow an Agile process, using Git and GitHub with Jira or a similar tool for user stories and the backlog.
- A CI/CD pipeline (Jenkins), code reviews and security validation are mandatory.
- Automated tests shall use pytest, with unit test reports showing code and branch coverage, and static analysis (SonarQube or similar) shall be applied.
- Documentation is as important as code, and the design shall be modular, maintainable and debuggable.
- A coding standard (for example PEP 8 for Python) shall be fixed in the design document.

<!-- Cite the stack decision the same way, referencing the relevant
     Appendix D entry rather than just stating the conclusion. -->

## Assumptions and Dependencies
<!-- E.g. assumes single institution scale, single term of data, etc. -->

TODO

<!-- Include explicitly: "No real customer was available for this academic
     project; a hypothetical stakeholder (Appendix D) was used to ground
     scope and design decisions." This is the assumption itself, not a
     footnote — call it out as one. -->
