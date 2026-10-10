# Appendix D: Stakeholder Discussion Log {.unnumbered}
 
This project had no real customer, so a hypothetical stakeholder was used to ground scope and design decisions in the same back-and-forth a real software engineering team would have. The discussions below were conducted over roughly four weeks, and the decisions recorded here are referenced from Sections 1.3, 2.4, 2.5 and 2.6 of this SRS.
 
## Persona {.unnumbered}
 
**Name / Role:** Dr. Kobe Bryant, Vice Chancellor
 
**Context:** Dr. Bryant oversees a university with approximately 10,000 students and staff combined. Student records, attendance and grades are currently maintained across spreadsheets and departmental registers, which makes consolidated reporting slow and access control inconsistent. He has commissioned a single Student Record System for the whole institution.
 
## Discussion 1: Discovery Call (Monday, 14 September 2026) {.unnumbered}
 
**Topics covered:** current pain points, user roles, must-have features.
 
**Q:** What problems with the current record-keeping process are driving this request?
 
**A:** Records are scattered across departments. Producing a consolidated report for a single student means collecting data from several offices, and there is no reliable way to tell who changed a record or when. Attendance is often entered days late.
 
**Q:** Who will use the system, and what should each group be able to do?
 
**A:** Three groups: administrative staff who register students and maintain records, faculty who mark attendance and grades for their own courses, and students who should be able to view only their own records. Faculty must not be able to see or edit other faculty's courses.
 
**Q:** Are there rules on attendance entry that the system should enforce?
 
**A:** Yes. Attendance should only be markable for a class session that has actually been scheduled, a student cannot be marked present in two overlapping sessions, and faculty should be able to correct an entry only within a limited window after the session. After that, only an administrator can amend it, with the change logged.
 
**Q:** How are grades assigned today?
 
**A:** Each course is evaluated against a rubric of weighted components such as assignments, internal tests and a final exam. Rubrics differ between courses, so the system cannot assume a single fixed scheme.
 
**Q:** Who should be allowed to define or change a course's rubric?
 
**A:** Most courses are taught by more than one faculty member, and the rubric has to be the same for every student in the course. For each course, one of the faculty teaching it will be designated as the anchor faculty, assigned by an administrator. Only the anchor faculty may create or alter that course's rubric. Other faculty teaching the course can view the rubric and enter grades against it, but cannot change it. Administrators can reassign the anchor faculty, for example if the person leaves or stops teaching the course, but they do not edit rubrics themselves.
 
**Decisions made:**
 
- Three user roles: Administrator, Faculty and Student, with role-based access enforced by the system.
- Core features confirmed: onboarding, editing records, attendance with constraints, rubric-based grading, retrieval, and role-based access.
- Attendance edit window and overlap rules will be specified as concrete requirements (see Section 5.3).
- The grading rubric will not be a fixed scheme. It is defined per course, and only the course's anchor faculty (designated by an Administrator from the faculty teaching the course) can create or alter it (see Section 5.4).
- Every change to a record, attendance entry or grade must be traceable to a user and a timestamp.

## Discussion 2: Deployment and Constraints (Thursday, 24 September 2026) {.unnumbered}
 
**Topics covered:** cloud versus self-hosted deployment, cost, expected load, data sensitivity, technology stack.
 
**Q:** Should the system be hosted on a cloud provider such as AWS, GCP, Azure or Firebase, or run on the institution's own infrastructure?
 
**A:** We initially leaned towards the cloud because it avoids buying hardware and gives a public URL immediately. The team walked through the trade-offs, and several points changed our view.
 
First, cost. A cloud deployment carries a recurring bill for compute, managed database, storage and backups that grows with usage and never ends. The institution already owns server capacity and a data centre room with spare capacity, so self-hosting is a one-time setup effort with no ongoing subscription.
 
Second, maintenance. The institution's existing IT team already runs servers and databases for other systems, so operating one more containerised application is well within their abilities and does not require hiring or training.
 
Third, the main advantage of the cloud does not apply here. Cloud platforms are most valuable for load balancing and low latency across large geographic areas, but nearly all users of this system are students and staff who regularly visit the campus and can reach a server on the campus network. There is no geographically distributed user base to serve.
 
**Q:** If cloud had been chosen, would a conventional backend or a serverless framework have been preferred?
 
**A:** Serverless was discussed and set aside even before the cost argument. The system depends on session-based authentication, role checks on every request and validation of attendance rules, all of which are simpler to build, test and reason about in a conventional long-running backend. Cold starts would also work against the response-time target below.
 
**Q:** What scale should the system be designed for?
 
**A:** About 10,000 users in total. Most of the time only a small fraction will be active, but there are predictable peaks: faculty marking attendance at the start and end of class periods, and students checking results when grades are published. The system should handle a few hundred concurrent users comfortably during these peaks.
 
**Q:** What are the expectations on response time?
 
**A:** Routine actions such as marking attendance or looking up a student should feel instant. A target of under two seconds for record retrieval under normal load was agreed.
 
**Q:** Are there data privacy or retention constraints?
 
**A:** Student records are personal data and must be protected accordingly, including compliance with India's Digital Personal Data Protection Act, 2023. Access must be limited by role, passwords must never be stored in plain text, and the database must be backed up regularly. Records are to be retained for the duration of a student's enrolment and for a period afterwards, as set by the university's records policy.
 
**Q:** Which technology stack should be used?
 
**A:** The institution has no preference, provided it is open source and maintainable by the existing IT team. The team proposed React for the frontend, Flask for the backend and a relational database, since student, course, attendance and grade data is inherently relational. MySQL will be used as the database in every environment (development, testing and deployment), so that the system behaves the same everywhere and the IT team only has to maintain one database technology.
 
**Decisions made:**
 
- Deployment model: self-hosted on the institution's own infrastructure, packaged with Docker so the IT team can deploy and update it consistently. Cloud and serverless options were considered and rejected for cost, operational simplicity and lack of a geographically distributed user base.
- Technology stack: React (frontend), Flask (backend), MySQL (database, used in development, testing and deployment).
- Design capacity: approximately 10,000 total users, with a few hundred concurrent users at peak.
- Performance target: record retrieval in under 2 seconds under normal load.
- Security: hashed passwords, role-based access enforced on the server, audit trail of changes, regular database backups.

## Discussion 3: Sign-off (Tuesday, 6 October 2026) {.unnumbered}
 
**Topics covered:** final scope confirmation, items excluded from this release, acceptance.
 
**Q:** Having reviewed the scope, is there anything that must be added before work begins?
 
**A:** No additions. The six features agreed in Discussion 1 cover the immediate need.
 
**Q:** Is there anything about how grades are published or corrected that should be settled before work begins?
 
**A:** Grades should stay hidden from students until they are final, so there must be a single point at which they are released. The anchor faculty will publish a course's grades. After publication, only the anchor faculty may correct a grade, and a written reason must be recorded so that every correction can be explained later. The rubric itself should be locked once grades are published.
 
**Q:** Are there features that can safely be deferred?
 
**A:** Yes. Fee management, timetable generation, a parent portal and integration with the university's single sign-on service are out of scope for this release. They can be considered in a later phase, and the design should not make them hard to add.
 
**Q:** Is the proposed deployment plan acceptable to the institution's IT team?
 
**A:** Yes. The IT team has reviewed the self-hosted, containerised approach and confirmed they can host and maintain it on existing infrastructure.
 
**Decisions made:**
 
- Scope for this release is the six confirmed features: onboarding, editing records, attendance with constraints, rubric-based grading, retrieval, and role-based access.
- Grades are visible to students only after the anchor faculty publishes them. After publication, only the anchor faculty may amend a grade, with a recorded reason, and the rubric is locked.
- Out of scope: fee management, timetable generation, parent portal, single sign-on integration.
- The extensibility of the design to accommodate deferred features later is a stated design goal.
- The stakeholder approved the SRS scope, deployment model and technology stack as recorded in this appendix.