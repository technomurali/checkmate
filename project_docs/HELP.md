# Checkmate Mobile Help Guide

## 1) What this application is for

Checkmate is a healthcare compliance platform used to document and validate financial interactions between:

- **Pharma Representatives**
- **Healthcare Providers (HCPs)**
- **Healthcare Organizations (HCOs / Office Users)**

The app helps teams capture event details in real time, submit supporting proof (like receipts and sign-in sheets), and complete approval/rejection actions with an auditable trail.

---

## 2) How Checkmate works (quick overview)

1. A user signs in with their account.
2. The app routes them to a role-based dashboard.
3. Event workflows happen in this order:
   - **Create event** (Pharma Rep or HCO)
   - **Track event** in Event History
   - **Check in and upload proof** when event date arrives
   - **Approve/Reject** participant entries (role-dependent)
4. Additional compliance visibility:
   - **CMS/Open Payments history**
   - **Dispute area** (partially implemented in current build)
   - **Profile maintenance**

The top navigation bar is the primary way users move between modules.

---

## 3) Users, roles, and access

The app uses role codes internally:

- **HCP**: `546170000`
- **Pharma Rep**: `546170001`
- **HCO / Office User**: `546170004`

### Role-based home dashboard

- **Pharma Rep** -> Pharma Rep Dashboard
- **HCO** -> Office User Dashboard
- **HCP** -> HCP Dashboard

### Top navigation visibility by role

- **All roles**: Home, Event History, Dispute History, Profile, Sign out
- **Pharma Rep + HCO**: Create Event
- **HCP + HCO**: File Dispute, CMS History (Open Payments)
- **Pharma Rep**: does **not** see File Dispute and CMS History in top nav

---

## 4) Authentication and onboarding screens

## Sign In

**Purpose**: Authenticate and route the user by role.

**Actions**
- Enter email and password
- Open Forgot Password
- Go to Sign Up

**Validation**
- Email is required and must match email format.
- Password field must be non-empty (button enables when both fields are filled).

**What happens on success**
- User profile/token is loaded.
- User is redirected to role-specific dashboard.

---

## Sign Up

**Purpose**: Create a new user account (current implementation is aligned to Pharma Rep signup).

**Fields shown**
- Email
- New Password
- Confirm Password
- First Name
- Last Name
- Company search/select
- Terms and Conditions acceptance

**Validation / rules**
- Email must be valid.
- Password minimum length is enforced in form logic.
- Confirm Password must match.
- First/Last name required.
- Company selection is required.
- Terms must be accepted before signup button is enabled.

**Important implementation note**
- Signup payload currently sets role to Pharma Rep role code.

---

## Terms and Conditions

**Purpose**: Display EULA and capture explicit consent.

**Actions**
- **Accept** -> returns true to Signup screen
- **Cancel** -> returns false

---

## Forgot Password

**Purpose**: Send verification code and verify it before reset.

**Flow**
1. Enter valid email and send verification code.
2. Enter received code.
3. Verify code.
4. On success, user is sent to Reset Password screen.

**Validation**
- Email must be valid before code can be sent.
- Verification code field must be non-empty before Verify action.

---

## Reset Password

**Purpose**: Set a new password after code verification.

**Validation**
- New password required, minimum 6 characters.
- Confirm password must match new password.

**Result**
- Success message shown and user is redirected back to Sign In.

---

## 5) Global in-app navigation shell

## Top Navigation

**Purpose**: Persistent role-aware navigation after login.

**Behavior**
- Uses in-app screen state (not separate route pushes for most modules).
- Sign out clears user state and returns to Sign In.
- Back behavior uses internal screen history.

---

## 6) Dashboard screens

## Pharma Rep Dashboard

**Shows**
- Greeting and role tag
- Upcoming Events (preview)
- Pending Approval items (preview)

**Actions**
- Tap card -> Event Details or Pending Receipt
- See All -> Event History with contextual filter
- Pull-to-refresh

---

## HCP Dashboard

**Shows**
- Greeting and HCP label
- Upcoming events
- Awaiting approval items

**Actions**
- Open Event Details
- Open Pending Receipt entry
- See All and refresh

---

## Office User (HCO) Dashboard

**Shows**
- Greeting and Office User label
- Organization name
- Upcoming events
- Receipts awaiting approval

**Actions**
- Open event detail/review flows
- See All and refresh

---

## 7) Event workflow screens

## Create Event (`New Event`)

**Purpose**: Create a compliant event with participant mapping.

**Main fields**
- HCO selection
- Event type
- Event name
- Event description
- Event date (and end date if multi-day)
- HCP selection (in-HCO or practitioner)
- Number of staff

**Validation / constraints**
- Event type required.
- Event name required.
- Start date required.
- End date required when multi-day.
- At least one HCP required.
- Number of staff must be numeric and > 0.
- Selected HCP entries must have NPI (missing NPI blocks submission).

**Submission result**
- Creates event with pending approval state.
- On success: form resets and user returns to dashboard.

---

## Event History

**Purpose**: Search, filter, sort, and open events.

**Capabilities**
- Text search by event name
- Status filter (All, Upcoming, In Review, Completed, Rejected, etc.)
- Date-range filter
- Sort toggle by date
- Pull-to-refresh
- Open Event Details

**Role behavior**
- Data source and event set are role-specific.
- Non-HCP users can jump to Create Event from this screen.

---

## Event Details

**Purpose**: View and manage an individual event lifecycle.

**Common content**
- Event metadata (HCO, rep, names, dates, amount, participants)
- Event status banner/state text
- Attachments preview (if available)

**Edit / update behavior**
- Editable state controlled by role and event condition.
- HCO users may be prompted for a reason before re-enabling incomplete events.

**Check-in flow**
- Available for eligible upcoming events.
- Requires:
  - receipt file
  - sign-in sheet file
  - amount
- Submit check-in uploads attachments and updates event to completed state.

**Additional actions**
- Terminate/delete event (when eligible)
- Approval interactions depending on participant status and role

---

## Pending Receipt

**Purpose**: Participant-level approval/rejection review for a specific event.

**What users can do**
- View event summary and HCP list
- See each participant approval status
- View event attachments
- Send approval request notifications (Pharma Rep)
- Approve or reject pending participant entries (HCO/HCP based on identity and role checks)

**Validation**
- Rejection requires remarks before confirmation.

---

## Receipt History

**Current state**
- Placeholder screen in current build (title-only output).

---

## 8) Dispute screens

## File Dispute

**Current state**
- Under construction in current build.

---

## Dispute History

**Current state**
- Currently displays "Coming Soon" unless dispute data is loaded by implementation updates.

---

## Dispute Details

**Purpose**
- Structured dispute detail/edit form exists and includes:
  - HCP details
  - transaction details
  - dispute reason/category
  - file pick action

**Current behavior note**
- Retrieval wiring and history linkage are not fully active in current flow.

---

## 9) CMS / Open Payments screens

## CMS History (`Open Payments`)

**Purpose**: Show payment transparency records linked to user NPI.

**Behavior**
- Loads list from open payments endpoint using current user NPI.
- Displays payment cards (person/company/category/date/amount).
- Tap a card to open full detail view.
- Pull-to-refresh supported.

---

## Open Payment Details

**Purpose**: Read-only detailed view of one Open Payments item.

**Includes**
- Recipient identity
- Manufacturer/GPO
- Amount and date
- Nature/form of payment
- Program year and publication info
- Dispute publication status

---

## 10) Profile screen

## Profile

**Purpose**: View and edit account details.

**Common fields**
- Email (read-only)
- First Name
- Last Name
- City

**Role-specific**
- Pharma Rep: searchable company selector in edit mode
- HCP: organization shown read-only

**Validation**
- Email format validated.
- Form submit triggers profile update API.

---

## 11) Practical examples for new users

## Example A: Pharma Rep creates and checks in an event

1. Sign in as Pharma Rep.
2. Open **Create Event**.
3. Select HCO, event type, date, HCPs, and staff count.
4. Submit event.
5. On event day, open event from Dashboard/Event History.
6. Tap **Check in**.
7. Add amount, upload receipt + sign-in sheet.
8. Tap **Submit Check-in**.
9. If needed, send participant approval requests from Pending Receipt.

---

## Example B: HCP approves/rejects pending item

1. Sign in as HCP.
2. Open **Pending Receipt** from dashboard card.
3. Review participant line item and status.
4. Tap **Approve** or **Reject**.
5. If rejecting, enter remarks, then confirm.

---

## Example C: HCO resolves incomplete/pending event

1. Sign in as Office User (HCO).
2. Open event from dashboard or Event History.
3. If event is incomplete and edit is needed, provide re-enable reason when prompted.
4. Update details and save.
5. Approve/reject participant entries in Pending Receipt as needed.

---

## 12) Validation summary (quick checklist)

- **Sign In**: valid email required.
- **Sign Up**: email valid, password + confirm match, names required, company required, terms accepted.
- **Forgot Password**: valid email before sending code; code required for verify.
- **Reset Password**: minimum 6 chars; confirm must match.
- **Create Event**: required event fields + HCP selection + positive staff count + HCP NPI presence.
- **Reject flows**: remarks required before submission.
- **Profile**: email format validation on form submission.

---

## 13) Notes for operators and support teams

- Some dispute and receipt-history modules are placeholders/partially wired in the current mobile build.
- Role assignment is critical because it controls both visibility and allowed actions.
- If a user reports missing modules, first verify their role code and profile payload.
