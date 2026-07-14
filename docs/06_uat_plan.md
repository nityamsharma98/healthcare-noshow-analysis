# User Acceptance Testing (UAT) Plan
## Patient No-Show Risk Flagging & Intervention

| Field | Value |
|---|---|
| Author | Nityam Sharma, Business Analyst |
| Version | 1.0 |
| Related | [FRD](03_FRD.md) · [User Stories](04_user_stories.md) · [RTM](05_requirements_traceability_matrix.md) |

---

## 1. Objective

Validate that the delivered solution meets the agreed business and functional requirements from the business user's perspective, before production deployment.

## 2. Scope

**In scope:** risk scoring at booking, tier classification, intervention routing (Low/Medium/High), dashboard breakdowns and trend, equity indicator, and data-quality enforcement.
**Out of scope:** production ML models, EHR vendor changes, billing.

## 3. Entry / Exit Criteria

- **Entry:** build complete in UAT environment; test data loaded; all P1 defects from SIT closed.
- **Exit:** 100% of Must test cases Passed; no open Critical/High defects; business sign-off obtained.

## 4. Roles

| Role | Responsibility |
|---|---|
| Business Analyst (Nityam Sharma) | Author test scenarios, coordinate UAT, log/triage defects |
| Front-desk / Ops testers | Execute workflow test cases |
| Clinic manager | Validate dashboard, provide sign-off |
| IT/QA | Fix defects, manage environment |

## 5. Test Cases

Format: **Given / When / Then**. Status starts as *Not Run*.

| Test ID | Traces to | Scenario | Preconditions | Steps (When) | Expected Result (Then) | Priority | Status |
|---|---|---|---|---|---|---|---|
| UAT-01 | US-01 / BR-001 | Score is generated at booking | User can create appointments | Create a new appointment and save | A risk score and tier are stored on the record before confirmation; scoring < 2s | Must | Not Run |
| UAT-02 | US-02 / BR-002 | Correct tier boundaries | Scoring engine live | Book appts engineered to total 1, 3, and 6 risk points | Tiers returned are Low, Medium, High respectively | Must | Not Run |
| UAT-03 | US-03 / BR-003 | All features contribute | Scoring engine live | Book a 30+ day-lead, age-25, welfare patient with prior no-shows | Score reflects lead(4)+age(2)+welfare(1)+history(≥1) → High | Must | Not Run |
| UAT-04 | US-04 / BR-011 | Score is auditable | Appointment scored | Open the appointment audit view | Feature values, points, tier, and rule version are visible | Should | Not Run |
| UAT-05 | US-05 / BR-004 | Routing matches tier | Scoring + workflow live | Book one Low, one Medium, one High appointment | Low→single reminder; Medium→T-3 & T-1 cadence; High→call task + confirm SMS | Must | Not Run |
| UAT-06 | US-06 / BR-005 | High-risk confirmation & overbooking | High appt exists, unconfirmed | Let confirmation window lapse without confirmation | Appt flagged eligible for controlled overbooking; call task present in queue | Must | Not Run |
| UAT-07 | US-07 / BR-006 | Configurable cadence | Admin access | Change Medium cadence from T-3 to T-4 and save | New Medium appts use T-4; no code deployment required | Should | Not Run |
| UAT-08 | US-08 / BR-007 | Dashboard breakdowns | Dashboard live, data loaded | Open dashboard for a period | No-show KPI + breakdowns by tier, lead time, age, welfare, clinic all render | Must | Not Run |
| UAT-09 | US-09 / BR-008 | 90-day trend vs target | Dashboard live | Open trend view | Rolling 90-day no-show trend with configurable target line displays | Must | Not Run |
| UAT-10 | US-10 / BR-010 | Equity indicator | Dashboard live | View equity panel | Welfare vs non-welfare no-show rates shown side by side as a gap | Should | Not Run |
| UAT-11 | US-11 / BR-009 | Data-quality enforcement | Pipeline live | Feed a record with age = -1 and one with negative lead time | Both rejected and logged; not scored; valid records processed | Must | Not Run |

## 6. Defect Management

Defects logged in Jira with severity (Critical / High / Medium / Low), linked to the failing Test ID and User Story. Critical/High must be resolved and retested before exit.

## 7. Sign-off

| Name | Role | Decision | Date |
|---|---|---|---|
| _____ | Patient Access Director | ☐ Approve ☐ Reject | ____ |
| _____ | Clinic Operations Lead | ☐ Approve ☐ Reject | ____ |
