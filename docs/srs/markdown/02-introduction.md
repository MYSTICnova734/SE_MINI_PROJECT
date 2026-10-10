# Introduction

## Purpose

This document is the Software Requirements Specification (SRS) for the **Student Record System**, release 1.0. It states what the system must do and the qualities it must have, so that the team can design, build and test it, and so that the institution it is written for can confirm it describes the system they need.

This SRS covers the whole product. All six functions are specified in Section 5: onboarding, editing records, marking attendance, marking grades with a rubric, retrieval, and role-based access. It also covers the interfaces (Section 3), the nonfunctional requirements (Section 6), and the supporting appendices. No part of the system is specified in a separate document.

## Intended Audience and Reading Suggestions

This document is written for the following readers.

- **Developers** use it as the basis for design and implementation. They should read Sections 2, 3 and 5, and refer to Appendix B for field definitions.
- **Testers** derive test cases from it. They should read the functional requirements and stimulus/response sequences in Section 5, the nonfunctional requirements in Section 6, and the traceability matrix in Appendix C.
- **The course instructor and evaluators** assess the document as the Phase-1 deliverable of the Software Engineering project. They may read it in order, beginning with Section 1.3 and Appendix D.
- **The institution's stakeholder and IT team** confirm that it matches their needs and can be hosted and maintained by them. They should read Sections 1.3 and 2, the security and performance requirements in Section 6, and Appendix D.

The rest of the document is organised as follows.

| Section | Contents |
|--------|----------------------------------------------|
| 1. Introduction | Purpose, audience, product scope and references. |
| 2. Overall Description | The product in context: perspective, functions, user classes, operating environment, constraints, and assumptions. |
| 3. External Interface Requirements | User interfaces, software interfaces and communications interfaces. |
| 4. Analysis Models | Use case diagram and entity-relationship diagram. |
| 5. System Features | The detailed functional requirements, one subsection per function (5.1 to 5.6). |
| 6. Other Nonfunctional Requirements | Performance, safety, security, software quality attributes and business rules. |
| 7. Other Requirements | Requirements not covered elsewhere. |
| Appendices | A: Glossary. B: Field Layouts. C: Requirement Traceability Matrix. D: Stakeholder Discussion Log. |

**Conventions used in this document.**

- Each functional requirement has a unique identifier of the form `REQ-XXX-nnn` (for example `REQ-GRD-004`). The prefixes are ONB, REC, ATT, GRD, RET and RBAC, one for each function, and SEC, SAF, QUA and OTH for the security, safety, quality and other requirements in Sections 6 and 7. Business rules in Section 6.5 are numbered `BR-nnn`.
- The word "shall" marks a mandatory requirement.
- "TBD" marks information not yet available. Each TBD names the section where it will be resolved.
- Terms such as Administrator, Faculty, Anchor Faculty and Inactive have the specific meanings given in Appendix A, and are capitalised or used in those exact forms throughout.

## Product Scope

The Student Record System is a web application that gives an institution one controlled place to keep its student records, attendance and grades. At present these are held in spreadsheets and departmental registers. Producing a complete picture of one student means collecting data from several offices, there is no reliable way to tell who changed a record or when, and attendance is often entered days late (Appendix D). The system replaces this with a single system in which every user sees and does only what their role permits, and every change can be traced.

**Objectives.** The system is intended to:

- keep one authoritative record for each student, which attendance and grades attach to;
- control access by role, so that Administrators, Faculty and Students each use only the functions and records that belong to them;
- let faculty record attendance promptly, under rules that the system enforces;
- grade each course against its own rubric, with the rubric controlled by a designated anchor faculty member and grades released to students only when they are final;
- record every change in an audit trail, so that who changed what, and when, can always be established; and
- retrieve records quickly at the scale of a whole institution, which is about 10,000 students and staff.

**In scope for this release.** The six functions specified in Section 5: onboarding, editing records, attendance with constraints, grading with a rubric, retrieval, and role-based access.

**Out of scope for this release.** Fee management, timetable generation, a parent portal and integration with the university's single sign-on service. Self-registration and email verification are also excluded. The design is intended to make later addition of these features possible without rework.

**Deployment and technology.** The system will be self-hosted on the institution's own servers, packaged with Docker. It is built with a React frontend, a Flask backend and a MySQL database. These choices, and the reasons for them, are recorded in Section 2.5 and Appendix D.

**Relation to institutional goals.** The system supports the institution's goal of replacing fragmented, department-by-department record keeping with one governed system that gives consistent reports, consistent access control and a reliable history of changes.

**How the scope was set.** No real customer was available for this academic project. The scope was therefore defined through three discussions with a hypothetical stakeholder, the Vice Chancellor of an institution of about 10,000 students and staff. The discussions are recorded in Appendix D, and decisions taken in them are cited where they apply. There is no separate vision and scope document.

## References

1. PES University, Department of Computer Science and Engineering. *Jackfruit Mini-Project: Software Engineering Project Guidelines*, subject code UE24CS341A, 2026. This includes the SRS format (Jackfruit Phase-1) that this document follows.
2. This document, Appendix D: *Stakeholder Discussion Log* (discussions held 14 September, 24 September and 6 October 2026).
3. Government of India. *The Digital Personal Data Protection Act, 2023* (Act No. 22 of 2023), which applies to the personal data held by the system.
4. React documentation. <https://react.dev>
5. Flask documentation. <https://flask.palletsprojects.com>
6. MySQL Reference Manual. <https://dev.mysql.com/doc/>
7. Docker documentation. <https://docs.docker.com>

The exact versions of the software in references 4 to 7 will be fixed at the start of implementation and recorded in the design document (see Section 3.2).