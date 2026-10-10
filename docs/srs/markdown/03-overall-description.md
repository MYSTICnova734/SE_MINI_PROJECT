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
<!-- e.g. Admin, Teacher, Student - what can each do, how tech-savvy are they assumed to be? -->

The Student Record System has three user classes: Admin, Teacher and Student. Every account holds exactly one of these roles, and access to functions and records depends on that role (Section 5.6). Accounts are created only by an Admin (Section 5.1), so a person cannot register themselves into any user class. The detailed permissions of each class are specified in Section 5.6 and are not repeated here.

The descriptions of technical proficiency and frequency of use below are assumptions made for this project, not established requirements. The user classes, their access levels and their access limitations follow from Sections 5.1 and 5.6.

### Admin

- **Purpose:** Administers the system. The Admin creates and maintains user accounts and keeps the student data accurate.
- **Main functions:** Manages Student and Teacher accounts (create, update, deactivate), assigns and changes roles, and manages student records, attendance and grades.
- **Access level:** Highest privilege. The Admin can access all relevant student and teacher records.
- **Information accessed:** Account details of all users, and the records, attendance and grades of all students.
- **Technical proficiency (assumed):** Moderate. The Admin is expected to be comfortable with administrative web applications and data entry, but needs no programming knowledge.
- **Frequency of use (assumed):** Periodic. Use is concentrated around account setup and record maintenance, with ad hoc use whenever accounts or records need correction.
- **Important characteristics and limitations:** Only the Admin can manage accounts and roles. One pre-seeded Admin account exists from initial system setup. The Admin never sets or knows a user's password, because each user sets their own.

### Teacher

- **Purpose:** Records and maintains the academic information of the students assigned to them.
- **Main functions:** Views their assigned students, marks and edits attendance, enters and edits grades, and views the relevant academic records of those students.
- **Access level:** Restricted to the students assigned to that Teacher.
- **Information accessed:** Attendance, grades and academic records of assigned students only.
- **Technical proficiency (assumed):** Basic to moderate. The Teacher is expected to use standard web forms and tables for data entry and lookup.
- **Frequency of use (assumed):** Regular during the academic term, mainly for attendance and grade entry.
- **Important characteristics and limitations:** A Teacher cannot access students outside their assignments and cannot manage accounts or roles.

### Student

- **Purpose:** Views their own academic information held by the institution.
- **Main functions:** Views their own profile, attendance, grades and academic records.
- **Access level:** Lowest privilege. Access is limited to the Student's own records and is read-only for academic information.
- **Information accessed:** Their own profile, attendance, grades and academic records only.
- **Technical proficiency (assumed):** Basic. The Student is expected to be able to log in and read information presented on screen.
- **Frequency of use (assumed):** Occasional, typically to check attendance or grades. Use may increase when results are published.
- **Important characteristics and limitations:** A Student cannot access any other student's records and cannot modify their own grades or attendance. Students are by far the most numerous user class, and their access to the system depends on an Admin creating their account.

## Operating Environment
<!-- Browser support, OS for the server, any hosting assumptions. -->

TODO

<!-- Cite the deployment decision, e.g.: "Per stakeholder discussion,
     DD-Mon-YYYY (Appendix D), the system will be self-hosted via Docker." -->

## Design and Implementation Constraints
<!-- Chosen stack, self-hosted vs cloud decision, language/framework mandates, security considerations. -->

TODO

<!-- Cite the stack decision the same way, referencing the relevant
     Appendix D entry rather than just stating the conclusion. -->

## Assumptions and Dependencies
<!-- E.g. assumes single institution scale, single term of data, etc. -->

TODO

<!-- Include explicitly: "No real customer was available for this academic
     project; a hypothetical stakeholder (Appendix D) was used to ground
     scope and design decisions." This is the assumption itself, not a
     footnote — call it out as one. -->
