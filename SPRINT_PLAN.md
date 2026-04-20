# Checkmate Mobile Sprint Plan

## 1. Sprint Model

- **Project window**: 2025-06-11 to 2025-10-27
- **Cadence**: 2-week sprints (working days only; weekends are holidays)
- **Tracking source**: `task_sheet_2025-06-11_to_2025-10-27.csv`
- **Definition of Done (DoD)**:
  - Code complete and peer-reviewed
  - API/Integration validation completed
  - Test evidence captured
  - Task status marked `Done`

## 2. Team Allocation

- **Muralidhar**: project planning, monitoring, architecture
- **Pramod**: .NET APIs/backend
- **Sreeker + Murali**: Flutter (split ownership)
- **Srinivas**: Dynamics CRM + Power Apps

## 3. Sprint-by-Sprint Plan

## Sprint 1 (11 Jun - 24 Jun 2025)

- Requirement walkthrough and architecture baseline
- Swagger/API inventory and endpoint mapping
- Initial backlog creation and quality gate setup
- **Primary owners**: Muralidhar

## Sprint 2 (25 Jun - 08 Jul 2025)

- Complete identity flow skeleton: sign in/sign up/role routing
- Start forgot-password and reset-password API wiring
- Validation rules implementation for auth screens
- **Primary owners**: Sreeker, Murali, Pramod

## Sprint 3 (09 Jul - 22 Jul 2025)

- Stabilize auth flow and session/token handling
- Begin role-aware dashboard behavior and navigation visibility
- Role matrix compliance checks
- **Primary owners**: Sreeker, Murali, Pramod

## Sprint 4 (23 Jul - 05 Aug 2025)

- Complete role dashboards (Pharma Rep, HCP, HCO)
- Implement top navigation access rules and refresh behavior
- Dashboard usability and empty-state handling
- **Primary owners**: Sreeker, Murali

## Sprint 5 (06 Aug - 19 Aug 2025)

- Create event form completion with validation rules
- Integrate event and contact APIs for participant mapping
- Event history search/filter/sort workflows
- **Primary owners**: Sreeker, Murali, Pramod, Srinivas

## Sprint 6 (20 Aug - 02 Sep 2025)

- Event details and check-in workflow
- Attachment upload/retrieval integration
- Approvals module and notification pipeline start
- Power Apps approval monitoring baseline
- **Primary owners**: Sreeker, Murali, Pramod, Srinivas

## Sprint 7 (03 Sep - 16 Sep 2025)

- Participant approval/rejection flow completion
- Rejection remarks validation and state transitions
- Notification reliability and workflow checks
- **Primary owners**: Sreeker, Murali, Pramod, Srinivas

## Sprint 8 (17 Sep - 30 Sep 2025)

- CMS/Open Payments list and detail integration
- Dispute history/details baseline wiring
- CRM mapping for dispute/event-related entities
- **Primary owners**: Sreeker, Murali, Pramod, Srinivas

## Sprint 9 (01 Oct - 14 Oct 2025)

- Profile management completion
- Regression round-1 across all roles and flows
- API hardening and error-handling improvements
- **Primary owners**: Sreeker, Murali, Pramod

## Sprint 10 (15 Oct - 27 Oct 2025)

- Final regression and performance tuning
- UAT closure and release checklist completion
- Deployment readiness and project handover
- **Primary owners**: Muralidhar, Pramod, Sreeker, Murali, Srinivas

## 4. Sprint Ceremonies and Governance

- Sprint planning at sprint start
- Mid-sprint dependency and risk review
- Sprint demo and closure review
- Weekly architecture/monitoring checkpoint led by Muralidhar

## 5. Risk Watch by Sprint

- **Sprints 1-3**: requirements drift, auth/API mismatch
- **Sprints 4-7**: workflow regression across user roles
- **Sprints 8-10**: integration stabilization and release readiness

## 6. Acceptance Criteria for Project Closure

- All sprint commitments marked done in task sheet
- No critical/high unresolved defects for go-live scope
- API and CRM/Power Apps integrations validated
- Stakeholder sign-off for release handover

