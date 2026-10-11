# External Interface Requirements

## User Interfaces
* **General UI Layout:** Responsive web interface built using modern CSS layout standards. Core workflows (e.g., taking roll-call, checking GPA) must be accessible within 3 UI clicks from login.
* **Student Dashboard:** Single-screen view rendering enrolled course cards, GPA summary, aggregate attendance percentages, and grade state indicators.
* **Faculty Marking Interface:** Tabular class roster with toggle inputs for binary attendance (Present/Absent) and numerical grade input fields per rubric component.
* **Admin Control Console:** Form interfaces for provisioning user accounts, uploading class schedules, setting course rubric weights, and executing grade state updates.

## Hardware Interfaces
* The system requires no direct hardware access or custom peripheral drivers. Standard client display devices, keyboards, and pointing devices (touchscreen or mouse) are supported over standard web protocols.

## Software Interfaces
* **Database Management System:** Relational SQL database connected via Object-Relational Mapping (ORM) client drivers over encrypted connections.
* **Authentication Engine:** HTTP-only JSON Web Token (JWT) handling session state and role claims.

## Communication Interfaces
* **Protocol:** HTTP/2 over TLS 1.3 (HTTPS) enforced across all endpoints. Plain HTTP requests automatically redirect to HTTPS with HSTS headers enabled.
* **Data Format:** Restful JSON payloads for all API requests and responses.
