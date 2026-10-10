# Other Requirements

This section covers requirements that do not belong to a single function or to the other nonfunctional categories: the database, legal obligations, localisation, reuse, and what must be delivered with the system.

## Database Requirements

- **REQ-OTH-001:** The system shall store all persistent data in a single MySQL relational database (see Sections 2.5 and 3.2).
- **REQ-OTH-002:** The database schema shall be normalised to at least third normal form, except where a departure is documented in the design document with its reason.
- **REQ-OTH-003:** The database shall use a UTF-8 character set that supports the full Unicode range (`utf8mb4` in MySQL), so that names in any script are stored and displayed correctly.
- **REQ-OTH-004:** The database shall compare emails and identifiers without regard to letter case, consistent with REQ-ONB-009.
- **REQ-OTH-005:** Every change to the database schema shall be made through a versioned migration script kept in the project repository. The schema shall not be changed by hand.
- **REQ-OTH-006:** The system shall store all timestamps in UTC and display them in Indian Standard Time (IST).

## Legal and Regulatory Requirements

Student records are personal data. The institution is responsible for its obligations under the Digital Personal Data Protection Act, 2023, and the exact obligations are to be confirmed by the institution's legal advisers. The system shall support the institution in meeting them as follows.

- **REQ-OTH-007:** The system shall collect only the personal data fields defined in Appendix B.
- **REQ-OTH-008:** The system shall let the institution retrieve all the data it holds about a student (Section 5.5) and correct it (Section 5.2).
- **REQ-OTH-009:** The system shall keep student data only for the retention period set by the university's records policy (TBD). The disposal of records after that period is carried out by the institution outside the application, and the procedure is TBD.

## Internationalisation and Localisation

- **REQ-OTH-010:** The user interface shall be in English. User-visible text shall be kept separate from program logic, so that another language can be added later without changing the logic.
- **REQ-OTH-011:** The system shall display dates in the format DD-MM-YYYY and times on a 24-hour clock.

## Reuse

- **REQ-OTH-012:** The system shall use established open-source libraries for security-critical functions, namely password hashing, session handling and input escaping, and shall not implement its own.
- **REQ-OTH-013:** No components are reused from other projects. The modules shall be designed so that they can be reused by the deferred features listed in Section 1.3.

## Initial Setup and Data

- **REQ-OTH-014:** The system shall come with a documented setup procedure that creates the pre-seeded Administrator account (the handling of its initial credential is defined in Section 6.3).
- **REQ-OTH-015:** The initial release shall assume that accounts and student records are entered through the application. Bulk import of existing spreadsheet data is not part of this release (TBD whether it will be added later).

## Documentation and Delivery

- **REQ-OTH-016:** The system shall be delivered with a deployment guide that includes the backup and restore procedure (REQ-SAF-003), a short user guide for each of the three roles, the API documentation (REQ-QUA-013), and a maintenance plan.
- **REQ-OTH-017:** All source code, scripts, configuration and documentation shall be kept in the project's Git repository.