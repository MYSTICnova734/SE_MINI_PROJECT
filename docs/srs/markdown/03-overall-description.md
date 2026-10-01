# 2. Overall Description

## 2.1 Product Perspective
<!-- New, self-contained product? Describe the overall context. A simple component diagram helps. -->

TODO

## 2.2 Product Functions
<!-- High-level bullet list of major functions - one line each, detail comes later in Section 5. -->

- Onboarding (student/staff registration)
- Edit records
- Mark attendance (with constraints)
- Mark grades (with rubric)
- Retrieval / search
- Role-based access control

## 2.3 User Classes and Characteristics
<!-- e.g. Admin, Teacher, Student - what can each do, how tech-savvy are they assumed to be? -->
## 2.3 User Classes and Characteristics

The Student Record System has three user classes: Admin, Teacher and Student. Every account holds exactly one of these roles, and access to functions and records depends on that role (Section 5.6). Accounts are created only by an Admin (Section 5.1), so a person cannot register themselves into any user class. The detailed permissions of each class are specified in Section 5.6 and are not repeated here.

The descriptions of technical proficiency and frequency of use below are assumptions made for this project, not established requirements. The user classes, their access levels and their access limitations follow from Sections 5.1 and 5.6.

### 2.3.1 Admin

- **Purpose:** Administers the system. The Admin creates and maintains user accounts and keeps the student data accurate.
- **Main functions:** Manages Student and Teacher accounts (create, update, deactivate), assigns and changes roles, and manages student records, attendance and grades.
- **Access level:** Highest privilege. The Admin can access all relevant student and teacher records.
- **Information accessed:** Account details of all users, and the records, attendance and grades of all students.
- **Technical proficiency (assumed):** Moderate. The Admin is expected to be comfortable with administrative web applications and data entry, but needs no programming knowledge.
- **Frequency of use (assumed):** Periodic. Use is concentrated around account setup and record maintenance, with ad hoc use whenever accounts or records need correction.
- **Important characteristics and limitations:** Only the Admin can manage accounts and roles. One pre-seeded Admin account exists from initial system setup. The Admin never sets or knows a user's password, because each user sets their own.

### 2.3.2 Teacher

- **Purpose:** Records and maintains the academic information of the students assigned to them.
- **Main functions:** Views their assigned students, marks and edits attendance, enters and edits grades, and views the relevant academic records of those students.
- **Access level:** Restricted to the students assigned to that Teacher.
- **Information accessed:** Attendance, grades and academic records of assigned students only.
- **Technical proficiency (assumed):** Basic to moderate. The Teacher is expected to use standard web forms and tables for data entry and lookup.
- **Frequency of use (assumed):** Regular during the academic term, mainly for attendance and grade entry.
- **Important characteristics and limitations:** A Teacher cannot access students outside their assignments and cannot manage accounts or roles.

### 2.3.3 Student

- **Purpose:** Views their own academic information held by the institution.
- **Main functions:** Views their own profile, attendance, grades and academic records.
- **Access level:** Lowest privilege. Access is limited to the Student's own records and is read-only for academic information.
- **Information accessed:** Their own profile, attendance, grades and academic records only.
- **Technical proficiency (assumed):** Basic. The Student is expected to be able to log in and read information presented on screen.
- **Frequency of use (assumed):** Occasional, typically to check attendance or grades. Use may increase when results are published.
- **Important characteristics and limitations:** A Student cannot access any other student's records and cannot modify their own grades or attendance. Students are by far the most numerous user class, and their access to the system depends on an Admin creating their account.

## 2.4 Operating Environment
<!-- Browser support, OS for the server, any hosting assumptions. -->

TODO

<!-- Cite the deployment decision, e.g.: "Per stakeholder discussion,
     DD-Mon-YYYY (Appendix D), the system will be self-hosted via Docker." -->

## 2.5 Design and Implementation Constraints
<!-- Chosen stack, self-hosted vs cloud decision, language/framework mandates, security considerations. -->

TODO

<!-- Cite the stack decision the same way, referencing the relevant
     Appendix D entry rather than just stating the conclusion. -->

## 2.6 Assumptions and Dependencies
<!-- E.g. assumes single institution scale, single term of data, etc. -->

TODO

<!-- Include explicitly: "No real customer was available for this academic
     project; a hypothetical stakeholder (Appendix D) was used to ground
     scope and design decisions." This is the assumption itself, not a
     footnote — call it out as one. -->
