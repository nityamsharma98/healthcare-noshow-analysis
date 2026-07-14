# Business Requirements Document (BRD)
## Patient No-Show Risk Flagging & Intervention

### Document Control

| Field | Value |
|---|---|
| Document Title | BRD — Patient No-Show Risk Flagging & Intervention |
| Author | Nityam Sharma, Business Analyst |
| Version | 1.0 |
| Status | Draft for review |
| Date | 2026-07-13 |
| Approvers | Director of Patient Access · Clinic Operations Lead · IT Delivery Manager |
| Related | [Problem Brief](01_problem_brief.md) · [FRD](03_FRD.md) · [RTM](requirements_traceability_matrix.xlsx) |

### Revision History

| Version | Date | Author | Change |
|---|---|---|---|
| 1.0 | 2026-07-13 | N. Sharma | Initial draft |

---

## 1. Executive Summary

The provider experiences a **20.2% appointment no-show rate**, wasting roughly one in five clinical slots. This BRD defines the business requirements for a **Patient No-Show Risk Flagging & Intervention** capability that scores every appointment at booking time, routes at-risk appointments into a tiered intervention workflow, and gives operations leaders a dashboard to monitor no-show performance. The goal is a **≥15% relative reduction** in no-shows within two quarters of go-live.

## 2. Business Objectives

See Problem Brief §6. In summary: score 100% of bookings for risk; reduce the no-show rate ≥15% relative; direct ≥80% of interventions at Medium/High-risk appointments; deliver a monitoring dashboard; and avoid widening the equity gap for welfare patients.

## 3. Project Scope

**In scope**
- Risk scoring rules applied at appointment booking.
- A three-tier (Low / Medium / High) intervention workflow.
- Data cleaning and preparation of booking history to support scoring.
- A no-show monitoring dashboard for operations.
- Requirements, process redesign, and UAT for the above.

**Out of scope**
- Production ML/model-ops platform (v1 uses transparent rules; ML is a future phase).
- EHR vendor replacement, billing changes, and clinical treatment decisions.

## 4. Stakeholder Analysis (RACI)

| Activity | Patient Access Dir. | Clinic Ops | Front Desk | IT/Data | Care Mgmt | BA |
|---|---|---|---|---|---|---|
| Define risk tiers | A | C | I | C | C | R |
| Approve interventions | A | R | C | I | C | R |
| Expose booking data | I | I | I | R/A | I | C |
| Dashboard requirements | C | A | I | C | I | R |
| UAT sign-off | A | R | C | C | C | R |

*R = Responsible, A = Accountable, C = Consulted, I = Informed.*

## 5. Current State (As-Is)

1. Patient books an appointment (phone / front desk / portal).
2. Appointment is stored; **no risk assessment** is made.
3. A single reminder SMS may be sent to some patients, uniformly.
4. On the day, staff discover no-shows reactively; the slot is lost.
5. No structured reporting exists on no-show drivers or trends.

**Gap:** no prediction, no targeting, no measurement, no feedback loop.

## 6. Future State (To-Be)

1. Patient books an appointment.
2. **A risk score (Low / Medium / High) is computed at booking** from lead time, prior no-show history, age band, welfare status, and chronic-condition flags.
3. The appointment is routed into the matching **intervention tier**:
   - **Low** — standard single reminder.
   - **Medium** — multi-touch reminder cadence (SMS + timed follow-up).
   - **High** — confirmation call / two-way confirm; eligible slots flagged for controlled overbooking.
4. Outcomes feed a **monitoring dashboard** (no-show rate by tier, clinic, lead time, cohort).
5. The dashboard closes the loop: interventions are measured and tuned.

## 7. Analytical Basis for Requirements (evidence)

Requirements below are grounded in analysis of 110,527 appointments:

| Driver | Observed no-show rate | Requirement implication |
|---|---|---|
| Lead time: same-day | 4.6% | Same-day → Low risk baseline |
| Lead time: 8–14 days | 30.5% | Medium/High weighting |
| Lead time: 30+ days | 33.0% | Strongest single driver → highest weight |
| Age 18–34 | 24.0% | Younger band adds risk |
| Age 55–74 | 15.7% | Older band reduces risk |
| Scholarship (welfare) | 23.7% vs 19.8% | Include as feature; monitor for equity |
| SMS_received = 1 | 27.6% vs 16.7% | ⚠️ **Do not** treat SMS as protective in raw form — it correlates with long lead times (confound). Risk logic must control for lead time. |

> **Analyst note (critical-thinking flag):** The raw SMS finding is counterintuitive because SMS reminders are predominantly sent for longer-lead appointments, which are inherently higher-risk. This is a confounding relationship, not evidence that reminders cause no-shows. The intervention design therefore layers reminder *cadence* on top of a lead-time-aware risk score, rather than relying on a single SMS.

## 8. Business Requirements

| ID | Requirement | Priority | Source Objective |
|---|---|---|---|
| BR-001 | The system shall calculate a no-show risk score for every appointment at the time of booking. | Must | O1 |
| BR-002 | The risk score shall classify each appointment as Low, Medium, or High risk. | Must | O1 |
| BR-003 | Risk scoring shall use, at minimum: booking-to-appointment lead time, patient prior no-show history, age band, welfare (Scholarship) status, and chronic-condition flags. | Must | O1 |
| BR-004 | The system shall route each appointment to an intervention tier corresponding to its risk level. | Must | O2 |
| BR-005 | High-risk appointments shall trigger a confirmation-call/two-way-confirm workflow. | Must | O2 |
| BR-006 | Medium-risk appointments shall trigger a multi-touch reminder cadence. | Should | O2 |
| BR-007 | The solution shall provide a dashboard reporting no-show rate by risk tier, clinic, lead-time bucket, age band, and welfare status. | Must | O4 |
| BR-008 | The dashboard shall support a rolling 90-day trend of the overall no-show rate against target. | Must | O2, O4 |
| BR-009 | Underlying booking data shall be cleaned per defined quality rules before scoring (see §10). | Must | O1 |
| BR-010 | The solution shall report the no-show gap for welfare patients so it can be monitored for equity. | Should | O5 |
| BR-011 | Risk logic shall be transparent and auditable (rule-based in v1, no black-box scoring). | Should | O1, O5 |

## 9. Functional Requirements (summary — detailed in FRD)

- FR references map 1:1 to BR-001…BR-011 in the [FRD](03_FRD.md) and are tracked in the [RTM](requirements_traceability_matrix.xlsx).

## 10. Data Requirements & Quality Rules

The following data-cleaning rules are **mandatory** before scoring (implemented in [`scripts/01_clean_profile.py`](../scripts/01_clean_profile.py)):

| Rule | Issue found | Action |
|---|---|---|
| DQ-1 | Age = -1 (1 record) | Remove invalid ages (< 0) |
| DQ-2 | AppointmentDay before ScheduledDay (5 records) | Remove negative lead-time records |
| DQ-3 | `Hipertension`, `Handcap` misspelled | Rename to `hypertension`, `handicap` |
| DQ-4 | `Handcap` is 0–4, not binary | Keep as ordinal count; document |
| DQ-5 | `No-show` label is inverted (Yes = missed) | Create `no_show` (1 = missed, 0 = attended) |
| DQ-6 | Repeat patients (48,228) | Derive `prior_no_shows` per patient for BR-003 |
| DQ-7 | Dates stored as text | Cast to datetime; derive `lead_days`, `weekday` |

## 11. Assumptions, Constraints, Dependencies

- **Assumptions:** booking data is accessible; scheduling system can display a flag and trigger reminders.
- **Constraints:** interventions must fit current front-desk staffing; equity review required before deployment.
- **Dependencies:** IT/Data to expose booking history; Ops to staff confirmation-call workflow.

## 12. Risks

| Risk | Impact | Likelihood | Mitigation |
|---|---|---|---|
| Confounded features mislead scoring | High | Medium | Lead-time-aware logic; transparent rules (BR-011) |
| Overbooking harms patient experience | High | Medium | Controlled, capped overbooking for High tier only |
| Equity gap widens | High | Low | Monitor welfare gap (BR-010); equity review |
| Staff capacity for calls | Medium | Medium | Reserve calls for High tier (~small % of volume) |

## 13. Success Metrics (KPIs)

- Overall no-show rate (rolling 90-day) — **target ↓ ≥15% relative**.
- % appointments scored — **target 100%**.
- % interventions on Medium/High tiers — **target ≥80%**.
- Welfare no-show gap — **target: not widening**.
- Dashboard weekly active use by clinic managers.

## 14. Glossary

- **No-show** — a booked appointment the patient did not attend.
- **Lead time** — days between booking (ScheduledDay) and appointment (AppointmentDay).
- **Risk tier** — Low / Medium / High classification driving the intervention workflow.
- **RTM** — Requirements Traceability Matrix.
