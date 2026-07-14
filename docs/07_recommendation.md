# Final Recommendation — Patient No-Show Risk Flagging & Intervention

| Field | Value |
|---|---|
| Author | Nityam Sharma, Business Analyst |
| Audience | Patient Access Director, Clinic Operations, IT Delivery |
| Version | 1.0 |
| Basis | Analysis of 110,521 cleaned appointments + BRD/FRD requirements |

---

## 1. The one-line ask

Approve a phased build of a **transparent, lead-time-aware no-show risk score** feeding a **three-tier intervention workflow**, monitored by a dashboard — targeting a **≥15% relative reduction** in the 20.2% no-show rate.

## 2. What the data told us

1. **The problem is large and concentrated.** 20.2% of appointments are missed; risk is highly predictable from a few features.
2. **Lead time dominates.** Same-day no-show is 4.6%; 30+ day-lead is 33% — a **7×** spread. Any solution must be lead-time-aware.
3. **Prior behavior compounds it.** Patients who frequently missed before miss 32.6% of the time vs 15.3% for those who never missed.
4. **A simple, transparent model already works.** A rule-based score separates no-show rates **5.6% (Low) → 20.4% (Medium) → 37.7% (High)** — no black box required for v1.
5. **Beware the SMS trap.** SMS-reminded appointments show a *higher* raw no-show rate (27.6% vs 16.7%) only because SMS is sent for longer-lead appointments. Reading this naively would wrongly discredit reminders.

## 3. Recommended solution

| Tier | Who lands here | Intervention |
|---|---|---|
| **Low** (5.6% risk) | Same-day / short-lead, no history | Standard single reminder — minimal effort |
| **Medium** (20.4%) | Moderate lead / some history | Multi-touch reminder cadence (T-3 & T-1) |
| **High** (37.7%) | Long lead + prior no-shows + risk factors | Confirmation call + two-way confirm; controlled overbooking if unconfirmed |

This concentrates scarce staff effort (confirmation calls) on the ~20% of appointments that are High risk, where it pays off most.

## 4. Expected impact

- At ~20% baseline, a **15% relative reduction → ~17.2%**, recovering **~3,300 slots** across a dataset of this size (scale to your true volume).
- Better chronic-care follow-through and shorter effective wait times.
- Leadership gets a measurable, auditable feedback loop via the dashboard.

## 5. Guardrails

- **Equity:** monitor the welfare no-show gap (23.7% vs 19.8%) so interventions narrow, not widen, it.
- **Patient experience:** overbooking is capped and only for unconfirmed High-risk slots.
- **Transparency:** v1 stays rule-based and auditable; revisit ML only after the rule baseline is measured.

## 6. Phasing

1. **Phase 1 (now):** data pipeline + rule-based scoring + dashboard (this project's scope).
2. **Phase 2:** operationalize interventions; A/B test cadence vs control.
3. **Phase 3:** evaluate a calibrated ML model against the rule baseline once labeled outcome data accrues.

## 7. Decision requested

Approve Phase 1 build and assign IT/Data to expose booking history. Success is reviewed at 90 days against the no-show KPI target.
