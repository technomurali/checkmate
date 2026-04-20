# Checkmate Mobile Project Plan

## 1. Project Overview

Checkmate Mobile is a healthcare compliance platform delivery across Flutter (mobile app), .NET APIs, Dynamics CRM integration, and Power Apps workflow/reporting.  
This plan is aligned to the approved execution window: **2025-06-11 to 2025-10-10** (weekends treated as holidays).

## 2. Goals and Outcomes

- Deliver role-based mobile workflows for Pharma Rep, HCP, and HCO users.
- Complete end-to-end event lifecycle: create, track, check-in, approvals, and closure.
- Integrate .NET APIs with Dynamics CRM entities and Power Apps operational workflows.
- Release a production-ready build with validation, auditability, and compliance reporting.

## 3. Scope

### In Scope

- Authentication: sign in, sign up, forgot/reset password, role routing.
- Role dashboards and top navigation controls by user type.
- Event lifecycle: create event, event history, event details, check-in, termination.
- Pending receipt and participant-level approvals with rejection remarks.
- Notifications for approval actions.
- CMS/Open Payments listing and detail screens.
- Dispute module integration baseline (history/details wiring based on current readiness).
- Profile management and final hardening/release.

### Out of Scope (Current Window)

- New features not represented in HELP and current Swagger contract.
- Major redesign of data model outside approved API/CRM entities.

## 4. Reference Inputs

- Product workflow and validation reference: `HELP.md`
- API contract baseline: [Swagger UI](https://checkmate-dev-dtc7grftaugjhhbn.canadacentral-01.azurewebsites.net/swagger/index.html)
- OpenAPI source: [swagger.json](https://checkmate-dev-dtc7grftaugjhhbn.canadacentral-01.azurewebsites.net/swagger/v1/swagger.json)

## 5. Team and Ownership

- **Project planning, monitoring, architecture**: Muralidhar
- **.NET backend/API work**: Pramod
- **Flutter mobile work**: Sreeker and Murali (split across Flutter tasks)
- **Dynamics CRM + Power Apps work**: Srinivas

## 6. Delivery Phases

1. **Discovery and architecture**
   - Requirement deep dive, architecture baseline, API inventory, backlog and quality gates.
2. **Authentication and identity**
   - Login, signup, password reset flows, role-based redirection.
3. **Dashboards and navigation**
   - Role-based top nav, dashboard cards, refresh, and empty states.
4. **Core event lifecycle**
   - Create event, history filters, details, check-in, attachments, status transitions.
5. **Approvals and notifications**
   - Participant approvals/rejections, remarks validation, push notification hooks.
6. **CMS and disputes**
   - Open Payments integration and dispute flow baseline integration.
7. **Stabilization and release**
   - Profile updates, regression, API hardening, performance checks, UAT closure.

## 7. Milestones

- **M1 (End June 2025)**: Architecture and backlog approved.
- **M2 (Mid July 2025)**: Authentication features functionally complete.
- **M3 (End July 2025)**: Dashboards and role navigation complete.
- **M4 (Late August 2025)**: Event lifecycle complete with attachment/check-in workflows.
- **M5 (Mid September 2025)**: Approval workflow and notifications complete.
- **M6 (Early October 2025)**: CMS/Dispute integration complete.
- **M7 (10 Oct 2025)**: UAT sign-off and release readiness complete.

## 8. Quality Plan

- Functional validation per role (Pharma Rep, HCP, HCO).
- API contract verification against Swagger endpoints.
- Cross-module regression for event and approval states.
- Data validation checks for mandatory fields and remarks rules.
- Final release checklist and handover documentation.

## 9. Risks and Mitigation

- **API contract drift**  
  Mitigation: weekly contract validation and early defect triage.
- **CRM/Power Apps dependency delays**  
  Mitigation: parallel mock validation and staged integration checkpoints.
- **Cross-role workflow regressions**  
  Mitigation: role-based regression suite for every sprint closure.
- **Timeline compression near release**  
  Mitigation: strict change control and prioritized defect burn-down.

## 10. Governance and Tracking

- Execution tracked through day-wise task sheet (`task_sheet_2025-06-11_to_2025-10-27.csv`).
- Sprint reviews, demo checkpoints, and weekly status monitoring.
- Defect triage and dependency tracking handled in weekly review cadence.

