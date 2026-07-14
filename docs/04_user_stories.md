# User Stories & Acceptance Criteria
## Patient No-Show Risk Flagging & Intervention

| Field | Value |
|---|---|
| Author | Nityam Sharma, Business Analyst |
| Version | 1.0 |
| Related | [BRD](02_BRD.md) · [FRD](03_FRD.md) · [RTM](05_requirements_traceability_matrix.md) · [UAT](06_uat_plan.md) |

Acceptance criteria use the **Given / When / Then** format. Story points use a Fibonacci scale.

---

## Epic 1 — Risk Scoring Engine

### US-01 — Score appointment at booking
**As a** scheduling system, **I want** to calculate a no-show risk score the moment an appointment is booked, **so that** staff can act on risk before the appointment date.
- **Priority:** Must · **Points:** 5 · **Traces to:** BR-001, FR-101
- **AC1 — Given** a new appointment is created, **when** the booking is saved, **then** a risk score is calculated and stored before confirmation completes.
- **AC2 — Given** scoring runs, **then** it completes within 2 seconds (NFR-01).

### US-02 — Classify into a risk tier
**As an** operations lead, **I want** each appointment labelled Low / Medium / High, **so that** the right intervention can be applied.
- **Priority:** Must · **Points:** 3 · **Traces to:** BR-002, FR-102, FR-104
- **AC1 — Given** a calculated risk-point total, **when** the tier is derived, **then** 0–1 pts = Low, 2–4 = Medium, 5+ = High.
- **AC2 — Given** any appointment, **then** it is assigned exactly one tier.

### US-03 — Use the agreed risk features
**As a** business analyst, **I want** scoring to use lead time, prior no-show history, age band, welfare status, and chronic-condition flags, **so that** the score reflects the evidence-based drivers.
- **Priority:** Must · **Points:** 5 · **Traces to:** BR-003, FR-103, FR-402
- **AC1 — Given** an appointment, **then** all five feature groups contribute to the score per the FRD §5 rules.
- **AC2 — Given** a missing feature, **then** its contribution defaults to zero and the gap is logged (FR-106).

### US-04 — Transparent, auditable scoring
**As a** compliance reviewer, **I want** the scoring logic to be transparent and stored per appointment, **so that** decisions can be audited and explained.
- **Priority:** Should · **Points:** 3 · **Traces to:** BR-011, FR-105
- **AC1 — Given** a scored appointment, **then** the feature values, points, and tier are persisted against the record.
- **AC2 — Given** an auditor reviews a score, **then** the rule version applied is identifiable.

## Epic 2 — Intervention Workflow

### US-05 — Route to the matching intervention tier
**As a** scheduling system, **I want** each appointment routed to the workflow for its tier, **so that** interventions are proportionate to risk.
- **Priority:** Must · **Points:** 5 · **Traces to:** BR-004, FR-201
- **AC1 — Given** a Low appointment, **then** a single T-1 day reminder is scheduled.
- **AC2 — Given** a Medium appointment, **then** a T-3 and T-1 day reminder cadence is scheduled.
- **AC3 — Given** a High appointment, **then** a confirmation-call task and two-way confirm SMS are created.

### US-06 — High-risk confirmation workflow
**As a** front-desk agent, **I want** high-risk appointments to raise a confirmation-call task, **so that** I can proactively confirm the most at-risk patients.
- **Priority:** Must · **Points:** 5 · **Traces to:** BR-005, FR-204, FR-205
- **AC1 — Given** a High appointment, **then** a call task appears in my work queue.
- **AC2 — Given** a High appointment is unconfirmed within the configured window, **then** it is flagged eligible for controlled overbooking.

### US-07 — Configurable reminder cadence
**As an** operations administrator, **I want** to configure reminder timings without a code release, **so that** we can tune the cadence as we learn.
- **Priority:** Should · **Points:** 3 · **Traces to:** BR-006, FR-206, NFR-05
- **AC1 — Given** I change a cadence timing, **when** I save, **then** new appointments use the updated timing without deployment.

## Epic 3 — Monitoring Dashboard

### US-08 — Headline no-show KPI and breakdowns
**As a** clinic manager, **I want** to see the no-show rate broken down by tier, lead time, age band, welfare status, and clinic, **so that** I know where to focus.
- **Priority:** Must · **Points:** 5 · **Traces to:** BR-007, FR-301, FR-302
- **AC1 — Given** a selected period, **then** the overall no-show KPI and volume are displayed.
- **AC2 — Given** the dashboard loads, **then** breakdowns by all five dimensions are available.

### US-09 — 90-day trend vs target
**As a** patient-access director, **I want** a rolling 90-day no-show trend against a target line, **so that** I can track whether interventions are working.
- **Priority:** Must · **Points:** 3 · **Traces to:** BR-008, FR-303
- **AC1 — Given** the trend view, **then** it shows daily/weekly no-show rate over the last 90 days with a configurable target line.

### US-10 — Equity indicator
**As a** patient-access director, **I want** the welfare (Scholarship) no-show gap surfaced, **so that** interventions don't widen inequity.
- **Priority:** Should · **Points:** 2 · **Traces to:** BR-010, FR-304
- **AC1 — Given** the dashboard, **then** the no-show rate for welfare vs non-welfare patients is shown side by side as a gap indicator.

## Epic 4 — Data Pipeline & Quality

### US-11 — Enforce data-quality rules before scoring
**As a** data engineer, **I want** the pipeline to apply cleaning rules DQ-1…DQ-7 before scoring, **so that** scores are based on valid data.
- **Priority:** Must · **Points:** 5 · **Traces to:** BR-009, FR-401, FR-403
- **AC1 — Given** a record with invalid age or negative lead time, **then** it is rejected and logged, not scored.
- **AC2 — Given** the raw feed, **then** columns are standardized and the inverted no-show label is corrected before scoring.
