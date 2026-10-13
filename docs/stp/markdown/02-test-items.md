# 2. Test Items

* **User Authentication & Account Module (`AuthModule`):** User provisioning, temporary credential validation, mandatory password resets, and profile management.
* **Course Registration & Schedule Module (`CourseModule`):** Section creation, faculty mapping, rubric component weight auto-normalization, and timetable scheduling.
* **Student Enrollment Module (`EnrollmentModule`):** Self-enrollment workflow enforcing the hard 6-course limit per student per term.
* **Attendance Engine (`AttendanceModule`):** Digitized roll-call entry, percentage aggregation, 48-hour automated edit freeze, and administrative overrides.
* **Grade Lifecycle & Dispute Engine (`GradingModule`):** Rubric score evaluation, state transitions (`Draft` $\rightarrow$ `Submitted` $\rightarrow$ `Under Review` $\rightarrow$ `Published`), and regrade dispute tracking.
* **Analytics & Summary Reporting Engine (`AnalyticsModule`):** Student GPA aggregation, class score distribution rendering, and administrative CSV metric export.
* **Security & Authorization Middleware (`SecurityMiddleware`):** TLS 1.3 transit encryption, bcrypt password hashing, 48-hour JWT expiration, and endpoint RBAC.
