# Functional Requirements Document (FRD)
## Patient No-Show Risk Flagging & Intervention

### Document Control

| Field | Value |
|---|---|
| Author | Nityam Sharma, Business Analyst |
| Version | 1.0 |
| Status | Draft for review |
| Date | 2026-07-13 |
| Parent doc | [BRD](02_BRD.md) |
| Related | [User Stories](04_user_stories.md) · [RTM](05_requirements_traceability_matrix.md) · [UAT Plan](06_uat_plan.md) |

---

## 1. Purpose

This FRD decomposes the business requirements (BR-001…BR-011) from the [BRD](02_BRD.md) into detailed functional requirements the delivery team can build and test against. Each functional requirement traces to a business requirement and is verified by a UAT test case (see [RTM](05_requirements_traceability_matrix.md)).

## 2. Feature Areas

- **F1 — Risk Scoring Engine**
- **F2 — Intervention Workflow**
- **F3 — Monitoring Dashboard**
- **F4 — Data Pipeline & Quality**

## 3. Functional Requirements

### F1 — Risk Scoring Engine

| FR ID | Requirement | Traces to | Priority |
|---|---|---|---|
| FR-101 | On creation of a new appointment, the system shall calculate a no-show risk score before the booking is confirmed. | BR-001 | Must |
| FR-102 | The system shall classify each appointment into exactly one risk tier: Low, Medium, or High. | BR-002 | Must |
| FR-103 | The scoring engine shall consume these inputs: lead time (days), patient prior no-show rate, age band, welfare (Scholarship) status, and chronic-condition flags (hypertension, diabetes, alcoholism, handicap). | BR-003 | Must |
| FR-104 | The scoring engine shall apply the documented business rules in §5 (Business Rules) to produce a risk-point total and derived tier. | BR-002, BR-011 | Must |
| FR-105 | The system shall persist the risk score, tier, and the feature values used, against the appointment record for audit. | BR-011 | Should |
| FR-106 | If a required input is missing, the system shall default that feature's contribution to zero and log the gap, rather than fail scoring. | BR-001, BR-009 | Should |

### F2 — Intervention Workflow

| FR ID | Requirement | Traces to | Priority |
|---|---|---|---|
| FR-201 | The system shall route each scored appointment to the intervention workflow matching its risk tier. | BR-004 | Must |
| FR-202 | Low-risk appointments shall receive one standard reminder (single SMS) at T-1 day. | BR-004 | Must |
| FR-203 | Medium-risk appointments shall receive a multi-touch reminder cadence (SMS at T-3 days and T-1 day). | BR-006 | Should |
| FR-204 | High-risk appointments shall generate a confirmation-call task for front-desk staff and a two-way "reply to confirm" SMS. | BR-005 | Must |
| FR-205 | High-risk appointments that remain unconfirmed within a configurable window shall be flagged as eligible for controlled overbooking. | BR-005 | Could |
| FR-206 | Reminder cadence timings shall be configurable by an operations administrator without code changes. | BR-006 | Should |

### F3 — Monitoring Dashboard

| FR ID | Requirement | Traces to | Priority |
|---|---|---|---|
| FR-301 | The dashboard shall display the overall no-show rate KPI and appointment volume for a selected period. | BR-007 | Must |
| FR-302 | The dashboard shall break down no-show rate by: risk tier, lead-time bucket, age band, welfare status, and clinic (Neighbourhood). | BR-007 | Must |
| FR-303 | The dashboard shall show a rolling 90-day trend of the overall no-show rate against a configurable target line. | BR-008 | Must |
| FR-304 | The dashboard shall display the welfare (Scholarship) no-show gap as a dedicated equity indicator. | BR-010 | Should |
| FR-305 | The dashboard shall allow filtering by clinic and date range. | BR-007 | Should |

### F4 — Data Pipeline & Quality

| FR ID | Requirement | Traces to | Priority |
|---|---|---|---|
| FR-401 | The pipeline shall apply data-quality rules DQ-1…DQ-7 (BRD §10) before any record is scored. | BR-009 | Must |
| FR-402 | The pipeline shall derive lead time, age band, and prior no-show history features per appointment. | BR-003, BR-009 | Must |
| FR-403 | The pipeline shall reject and log records failing validation (invalid age, negative lead time) rather than scoring them. | BR-009 | Must |

## 4. Non-Functional Requirements

| NFR ID | Requirement |
|---|---|
| NFR-01 | Risk scoring shall complete within 2 seconds of appointment creation (no perceptible delay to booking staff). |
| NFR-02 | All patient data handling shall comply with applicable health-data privacy regulations (e.g., HIPAA); PHI shall be access-controlled and encrypted in transit and at rest. |
| NFR-03 | Scoring logic shall be transparent and human-auditable (rule-based, versioned); no opaque scoring in v1. |
| NFR-04 | The dashboard shall refresh at least daily. |
| NFR-05 | Risk rules and cadence timings shall be configurable without a code release. |

## 5. Business Rules — Risk Scoring (v1, transparent)

Risk points are summed, then mapped to a tier. This mirrors the logic implemented in [`scripts/01_clean_profile.py`](../scripts/01_clean_profile.py) and validated against real data.

**Lead-time points**

| Lead bucket | Points |
|---|---|
| Same-day | 0 |
| 1–3 days | 1 |
| 4–7 days | 2 |
| 8–14 days | 3 |
| 15–30 days | 3 |
| 30+ days | 4 |

**Age-band points**

| Age band | Points |
|---|---|
| 0–17 | 1 |
| 18–34 | 2 |
| 35–54 | 1 |
| 55–74 | 0 |
| 75+ | 0 |

**Other points**

| Condition | Points |
|---|---|
| Scholarship (welfare) = yes | +1 |
| Prior no-show rate ≥ 50% | +2 |
| Prior no-show rate > 0% and < 50% | +1 |

**Tier mapping**

| Total points | Tier |
|---|---|
| 0–1 | Low |
| 2–4 | Medium |
| 5+ | High |

**Validation (on 110,521 cleaned appointments):** Low 5.6% · Medium 20.4% · High 37.7% no-show rate — confirming the rules separate risk effectively.
