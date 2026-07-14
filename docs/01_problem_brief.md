# Problem Brief — Patient No-Show Risk Flagging & Intervention

| | |
|---|---|
| **Document** | Problem Brief |
| **Author** | Nityam Sharma, Business Analyst |
| **Version** | 1.0 |
| **Status** | Draft for stakeholder review |
| **Related docs** | [BRD](02_BRD.md) · [FRD](03_FRD.md) |

---

## 1. Background

The provider's outpatient network schedules high volumes of appointments across 80+ neighbourhood clinics. Analysis of a representative sample of **110,527 appointments** shows that **20.2% ended in a no-show** — roughly one in five booked slots went unused. No-shows reduce clinical utilization, delay care, distort provider schedules, and erode revenue. Today the scheduling team has **no systematic way to predict or pre-empt** a no-show; reminders are applied uniformly rather than by risk.

## 2. Problem Statement

> The organization cannot identify, at the point of booking, which appointments are likely to become no-shows, and therefore cannot target interventions. The result is a persistent ~20% no-show rate, wasted clinical capacity, and reactive rather than proactive scheduling.

## 3. Affected Stakeholders

| Stakeholder | How they are affected | Interest |
|---|---|---|
| **Patients** | Delayed access when slots are wasted; late reminders | High |
| **Front-desk / Scheduling team** | No guidance on where to focus outreach effort | High |
| **Clinicians & clinic managers** | Idle time, unpredictable schedules, lower throughput | High |
| **Revenue Cycle / Finance** | Lost billable capacity | High |
| **Care Management** | Missed appointments for chronic-condition patients raise clinical risk | Medium |
| **IT / Data Engineering** | Must expose booking data and host the risk feature | Medium |

## 4. Current Pain Points

- **No risk visibility** — every appointment is treated the same regardless of no-show likelihood.
- **Uniform reminders** — a single SMS is sent broadly; the data shows this alone does not solve the problem (SMS-reminded appointments actually show a *higher* raw no-show rate, driven by longer lead times — see BRD §7).
- **Long lead times go unmanaged** — no-show risk climbs from **4.6% (same-day)** to **33% (30+ days out)**, yet nothing changes in how long-lead appointments are handled.
- **No feedback loop** — no dashboard tracks no-show rate by driver, clinic, or cohort, so interventions can't be measured.

## 5. Business Impact (why this matters)

If the network runs ~1,000 appointments/day at a 20% no-show rate, that is **~200 wasted slots per day**. Even a **conservative 15% relative reduction** (from 20.2% → ~17.2%) recovers **~30 slots/day**, translating into recovered revenue, shorter wait times, and better chronic-care follow-through.

## 6. Objectives & Success Criteria (SMART)

| # | Objective | Success Metric | Target |
|---|---|---|---|
| O1 | Predict no-show risk at booking | Risk score generated for every new appointment | 100% of bookings scored |
| O2 | Reduce overall no-show rate | No-show rate (rolling 90-day) | ↓ ≥ 15% relative within 2 quarters of go-live |
| O3 | Target interventions efficiently | % of interventions directed at High/Medium-risk appts | ≥ 80% |
| O4 | Give leadership visibility | Dashboard adoption | Weekly use by clinic managers |
| O5 | Protect equity | No-show gap for welfare (Scholarship) patients | Gap does not widen post-intervention |

## 7. Scope (high level)

**In scope:** booking-time risk scoring; a tiered intervention workflow; a monitoring dashboard; requirements, process redesign, and UAT for the above.

**Out of scope:** building a production ML platform; changing the core EHR vendor; clinical treatment decisions; billing-system changes.

## 8. Assumptions & Constraints

- **Assumption:** historical booking data (lead time, age, prior no-show history, chronic-condition flags) is available and reasonably accurate after cleaning.
- **Assumption:** the scheduling system can display a risk flag and trigger reminder workflows.
- **Constraint:** interventions must be operationally realistic for existing front-desk staffing.
- **Constraint:** any patient segmentation must be reviewed for fairness/equity before use.

## 9. Recommendation (direction)

Proceed to a **Business Requirements Document** defining a **risk-tiered flagging feature** (driven primarily by lead time, prior no-show history, age band, and welfare status) with a **three-tier intervention workflow** and a **no-show monitoring dashboard**. See [BRD](02_BRD.md).
