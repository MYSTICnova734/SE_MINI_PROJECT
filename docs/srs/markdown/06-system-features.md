# 5. System Features

<!--
One subsection per feature from reqs.txt. Each REQ-ID should be unique - use the feature
prefix shown so IDs never collide when everyone edits this file.
Prefixes: ONB (onboarding), REC (edit records), ATT (attendance), GRD (grades), RET (retrieval), RBAC (roles)
-->

## 5.1 Onboarding

### 5.1.1 Description and Priority

**Description.** Onboarding is how user accounts are created in the Student Record System. An authenticated Admin creates Student and Teacher accounts and assigns each account a role. Self-registration is out of scope. The Admin never sets or knows the user's password. After the account is created, the user sets their own password through a secure initial-password setup process, then logs in separately using their registered email address and password.

**Priority:** High. Every other feature (edit records, attendance, grades, retrieval, role-based access) needs an existing, authenticated account, so none of them can be used without onboarding.

**Actors.**
- Admin (primary): creates accounts.
- Student and Teacher (secondary): complete initial-password setup.

**Preconditions.**
- A pre-seeded Admin account exists (created during initial system setup).
- The Admin performing onboarding is authenticated and holds the Admin role.

**Inputs.**

| Account type | Identifier (unique) | Other required fields | Optional fields |
|---|---|---|---|
| Student | SRN | Name, email, academic/program details (TBD – Appendix B) | TBD – Appendix B |
| Teacher | Staff ID | Name, email, department details (TBD – Appendix B) | TBD – Appendix B |
| Admin (pre-seeded only) | Admin ID | Name, email, password | TBD – Appendix B |

The Admin also selects the role of the account being created (Student or Teacher). The user's password is entered by the user during initial-password setup, never by the Admin. Field lengths, data types and the final field list are defined in Appendix B.

**Data created on successful onboarding.** The account record holds:
- the unique identifier (SRN, Staff ID or Admin ID);
- name, email, role and role-specific details;
- account status (Active);
- the password state (not yet set, then set);
- the password hash once the password is set, and never the plaintext;
- the creation timestamp and the identity of the Admin who created the account.

**Assumptions and dependencies.**
- Role permissions after onboarding are defined and enforced in Section 5.6. Onboarding only records the assigned role.
- Password hashing algorithm, session handling, setup-credential validity period and transport protection are defined in Section 6.3.
- The setup-credential delivery mechanism is TBD (see Section 3.3 and Section 6.3).
- Email verification is out of scope.
- Because login uses email, email addresses must be unique across all accounts.
- Identifier and email comparisons ignore letter case and leading/trailing whitespace (conservative assumption).
- Whether additional Admin accounts can be created through onboarding is TBD. In this version, the only Admin account is the pre-seeded one.

### 5.1.2 Stimulus/Response Sequences

| # | Stimulus (trigger) | System validation | System response |
|---|---|---|---|
| SR-1 | Admin selects "create account", chooses a role and submits valid, unique data. | Admin authenticated and has Admin role; required fields present and valid; identifier and email not already in use. | Account is created with status Active; password setup is initiated for the user; Admin sees a confirmation. No session is created for the new user. |
| SR-2 | Admin submits with a required field missing, blank, or in an invalid format or length. | Field-level validation fails. | No account created; each failing field is identified in an error message; previously entered non-password values are retained. |
| SR-3 | Admin submits an SRN, Staff ID, Admin ID or email that already belongs to an existing account. | Uniqueness check finds a match. | Request rejected; no account created or changed; error message names the duplicated field without disclosing other data of the existing account. |
| SR-4 | A non-Admin or unauthenticated user attempts to open or submit the onboarding function. | Authentication and role check fails. | Access denied; no account created. |
| SR-5 | New user opens the initial-password setup and submits a password and confirmation that satisfy the password rules. | Setup credential valid, unused and unexpired; passwords match; password rules satisfied. | Password is hashed and stored; setup credential is invalidated; user is informed and directed to log in separately. No session is created. |
| SR-6 | New user submits a password that violates the rules or does not match the confirmation. | Password rules or match check fails. | Password not stored; error message states which rule was not met; setup remains available while the credential is valid. |
| SR-7 | User opens a used, expired or invalid setup credential. | Credential check fails. | Setup rejected; no password set; user is informed that the setup link/credential is not valid. |
| SR-8 | User attempts to log in with email and password before completing initial-password setup. | No password has been set for the account. | Login rejected with a generic authentication-failure message. |

### 5.1.3 Functional Requirements

**Access and preconditions**
- **REQ-ONB-001:** The system shall allow only an authenticated user with the Admin role to use the account-creation (onboarding) function.
- **REQ-ONB-002:** The system shall reject any account-creation attempt by an unauthenticated user or by a user whose role is not Admin, shall create no account, and shall display an access-denied message.
- **REQ-ONB-003:** The system shall not provide any self-registration function; no account shall be creatable without an authenticated Admin.
- **REQ-ONB-004:** The system shall provide a pre-seeded Admin account, created during initial system setup, that holds an Admin ID, name, email and password, so that an Admin can log in before any other account exists. The handling of the seeded Admin's initial credential is specified in Section 6.3.

**Inputs and validation**
- **REQ-ONB-005:** The system shall require the Admin to select exactly one role (Student or Teacher) before submitting an account-creation request.
- **REQ-ONB-006:** For a Student account, the system shall require SRN, name, email and academic/program details (fields as defined in Appendix B).
- **REQ-ONB-007:** For a Teacher account, the system shall require Staff ID, name, email and department details (fields as defined in Appendix B).
- **REQ-ONB-008:** The system shall not require or accept a password from the Admin when creating a Student or Teacher account.
- **REQ-ONB-009:** The system shall remove leading and trailing whitespace from text inputs before validation and storage.
- **REQ-ONB-010:** The system shall treat a required field that is missing, empty, or contains only whitespace as invalid.
- **REQ-ONB-011:** The system shall accept an email address only if it contains exactly one "@" separating a non-empty local part from a non-empty domain part that contains at least one ".".
- **REQ-ONB-012:** The system shall reject any field value whose length or data type violates the limits defined in Appendix B.
- **REQ-ONB-013:** When validation fails, the system shall create no account and shall display an error message identifying every invalid or missing field.
- **REQ-ONB-014:** When validation fails, the system shall retain the previously entered non-password values in the form so that the Admin does not need to re-enter them.

**Uniqueness and duplicate handling**
- **REQ-ONB-015:** The system shall ensure that no two accounts share the same identifier value (SRN, Staff ID or Admin ID).
- **REQ-ONB-016:** The system shall ensure that no two accounts share the same email address.
- **REQ-ONB-017:** The system shall perform uniqueness comparisons of identifiers and email addresses without regard to letter case and after whitespace trimming.
- **REQ-ONB-018:** If a submitted identifier or email duplicates an existing account, the system shall reject the request, create no account, leave the existing account unchanged, and display an error message naming the duplicated field.
- **REQ-ONB-019:** The duplicate-error message shall not disclose any data of the existing account other than the fact that the submitted value is already in use.
- **REQ-ONB-020:** The system shall ensure that two simultaneous account-creation requests with the same identifier or email cannot both succeed.

**Role assignment and account status**
- **REQ-ONB-021:** The system shall assign to the new account exactly the role selected by the Admin and shall store that role with the account.
- **REQ-ONB-022:** The system shall set the status of a successfully created account to Active, with no additional approval step.
- **REQ-ONB-023:** The system shall record the creation timestamp and the identity of the creating Admin with each new account.

**Initial-password setup**
- **REQ-ONB-024:** Upon successful account creation, the system shall initiate a secure initial-password setup for the new user, through which the user sets their own password.
- **REQ-ONB-025:** The system shall not reveal the user's password to the Admin or to any other user at any point, including during creation and setup.
- **REQ-ONB-026:** The system shall issue the initial-password setup credential as single-use, bound to the specific account, and valid only for a limited period (period TBD – Section 6.3). The delivery mechanism of this credential is TBD (Section 3.3 and Section 6.3).
- **REQ-ONB-027:** The system shall require the user to enter the new password twice during setup and shall reject the submission if the two entries do not match.
- **REQ-ONB-028:** The system shall accept a password only if it has at least 8 characters and contains at least one uppercase letter, one lowercase letter, one digit, and one special character (a character that is neither a letter nor a digit).
- **REQ-ONB-029:** If a submitted password violates REQ-ONB-027 or REQ-ONB-028, the system shall not store it and shall display a message stating which rule was not met.
- **REQ-ONB-030:** The system shall store the password only as a salted, adaptive, one-way hash, using a unique salt per password. The specific algorithm is defined in Section 6.3.
- **REQ-ONB-031:** The system shall not store, log, display, or transmit a user's password in plaintext after it has been submitted.
- **REQ-ONB-032:** The system shall reject a setup credential that is used, expired, or invalid, shall set no password, and shall inform the user that the credential is not valid. The mechanism for re-issuing a credential is TBD.
- **REQ-ONB-033:** Upon successful password setup, the system shall immediately invalidate the setup credential.

**Completion, login implications and errors**
- **REQ-ONB-034:** Upon successful account creation, the system shall display to the Admin a confirmation showing the new account's identifier, name and role, and shall not display any password, password hash, or setup credential.
- **REQ-ONB-035:** The system shall not create an authenticated session for the new user as a result of account creation or password setup, and shall instead direct the user to log in separately.
- **REQ-ONB-036:** The system shall store the user's registered email address as their login identifier, so that the user can log in with email and password once the password has been set.
- **REQ-ONB-037:** The system shall reject any login attempt for an account whose password has not yet been set, using the same generic authentication-failure message used for incorrect credentials.
- **REQ-ONB-038:** The system shall not require email verification before an account can be used.
- **REQ-ONB-039:** The system shall create the account record atomically: if any step of account creation fails, no partial account shall remain and the Admin shall be shown an error message.
- **REQ-ONB-040:** When an unexpected error occurs during onboarding, the system shall display a generic error message that does not expose internal details (such as stack traces or storage errors).

## 5.2 Edit Records

### 5.2.1 Description and Priority
TODO

### 5.2.2 Stimulus/Response Sequences
TODO

### 5.2.3 Functional Requirements
- REQ-REC-1:
- REQ-REC-2:

## 5.3 Mark Attendance (with constraints)

### 5.3.1 Description and Priority
TODO

### 5.3.2 Stimulus/Response Sequences
TODO

### 5.3.3 Functional Requirements
<!-- Nail down the actual constraint rules here, e.g. edit window, overlapping sessions, etc. -->
- REQ-ATT-1:
- REQ-ATT-2:

## 5.4 Mark Grades (with rubric)

### 5.4.1 Description and Priority
TODO

### 5.4.2 Stimulus/Response Sequences
TODO

### 5.4.3 Functional Requirements
<!-- Decide: fixed-schema rubric vs teacher-configurable rubric - document the decision. -->
- REQ-GRD-1:
- REQ-GRD-2:

## 5.5 Retrieval

### 5.5.1 Description and Priority
TODO

### 5.5.2 Stimulus/Response Sequences
TODO

### 5.5.3 Functional Requirements
- REQ-RET-1:
- REQ-RET-2:

## 5.6 Role-Based Access

### 5.6.1 Description and Priority
TODO

### 5.6.2 Stimulus/Response Sequences
TODO

### 5.6.3 Functional Requirements
- REQ-RBAC-1:
- REQ-RBAC-2:
