# Appendix D: Stakeholder Discussion Log
 
This project had no real customer, so a hypothetical stakeholder was used to ground scope and design decisions in the same back-and-forth a real software engineering team would have. The discussions below were conducted over roughly four weeks, and the decisions recorded here are referenced from Sections 1.3, 2.4, 2.5 and 2.6 of this SRS.
 
## Persona
 
**Name / Role:** Dr. Raghavendra Kulkarni, Vice Chancellor
 
**Context:** Dr. Kulkarni oversees a university with approximately 10,000 students and staff combined. Student records, attendance and grades are currently maintained across spreadsheets and departmental registers, which makes consolidated reporting slow and access control inconsistent. He has commissioned a single Student Record System for the whole institution.
 
## Discussion 1: Discovery Call (Monday, 14 September 2026)
 
**Topics covered:** current pain points, user roles, must-have features.
 
**Q:** What problems with the current record-keeping process are driving this request?
 
**A:** Records are scattered across departments. Producing a consolidated report for a single student means collecting data from several offices, and there is no reliable way to tell who changed a record or when. Attendance is often entered days late.
 
**Q:** Who will use the system, and what should each group be able to do?
 
**A:** Three groups: administrative staff who register students and maintain records, faculty who mark attendance and grades for their own courses, and students who should be able to view only their own records. Faculty must not be able to see or edit other faculty's courses.
 
**Q:** Are there rules on attendance entry that the system should enforce?
 
**A:** Yes. Attendance should only be markable for a class session that has actually been scheduled, a student cannot be marked present in two overlapping sessions, and faculty should be able to correct an entry only within a limited window after the session. After that, only an administrator can amend it, with the change logged.
 
**Q:** How are grades assigned today?
 
**A:** Each course is evaluated against a rubric of weighted components such as assignments, internal tests and a final exam. Rubrics differ between courses, so the system cannot assume a single fixed scheme.
 
**Decisions made:**
 
- Three user roles: Administrator, Faculty and Student, with role-based access enforced by the system.
- Core features confirmed: onboarding, editing records, attendance with constraints, rubric-based grading, retrieval, and role-based access.
- Attendance edit window and overlap rules will be specified as concrete requirements (see Section 5.3).
- The grading rubric will be configurable per course by faculty rather than hardcoded (see Section 5.4).
- Every change to a record, attendance entry or grade must be traceable to a user and a timestamp.

## Discussion 2 — Deployment & Constraints (DATE)

**Topics covered:** self-hosted vs. cloud, budget, expected concurrent users,
data sensitivity / retention.

**Q:** Should this be cloud-hosted or self-hosted?
**A:** TODO — record the reasoning, not just the conclusion.

**Q:** What's the expected scale (students, concurrent users)?
**A:** TODO

**Q:** Any data privacy or retention constraints?
**A:** TODO

**Decisions made:**
- Deployment model: TODO
- Tech stack: TODO

## Discussion 3 — Sign-off (DATE)

**Topics covered:** final scope confirmation, any descoped features.

**Q:** TODO
**A:** TODO

**Decisions made:**
- TODO
