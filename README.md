# Patient No-Show Risk Flagging & Intervention — Business Analysis Portfolio Project

**Author:** Nityam Sharma · Business Analyst
**Domain:** Healthcare / Patient Access & Scheduling
**Role demonstrated:** Requirements Elicitation · Gap Analysis · As-Is/To-Be Process Mapping · BRD/FRD · User Stories · SQL Analysis · Dashboarding · UAT

---

## 1. Business Context

A regional healthcare provider loses significant revenue and clinical capacity to **missed appointments (no-shows)**. Each no-show is an unused clinical slot, delayed care for the patient, and lost throughput for the system. Leadership wants a data-driven way to **predict which appointments are at risk of a no-show at the time of booking** and trigger a proportionate intervention (reminder cadence, confirmation call, or controlled overbooking).

This project scopes that capability end-to-end as a Business Analyst would: from problem definition and stakeholder requirements through process redesign, data analysis, a monitoring dashboard, and a UAT plan.

## 2. The Business Question

> *Which appointments are most likely to result in a no-show, what drives that risk, and what intervention workflow will measurably reduce the no-show rate?*

## 3. Key Findings (from the real dataset)

| Finding | Evidence | Business Implication |
|---|---|---|
| Overall no-show rate is high | **20.2%** of 110,527 appointments | ~1 in 5 slots wasted — the core problem to solve |
| Lead time is the strongest driver | Same-day **4.6%** → 30+ days **33.0%** | Risk score must weight booking-to-appointment gap heavily |
| SMS reminder shows *higher* no-shows | SMS **27.6%** vs no-SMS **16.7%** | ⚠️ Confounded by lead time — SMS is sent mostly for long-lead appts. Naive reading would mislead leadership |
| Younger patients miss more | 18–34: **24%** vs 55–74: **16%** | Age band is a useful risk feature |
| Welfare (Scholarship) patients miss more | **23.7%** vs 19.8% | Equity-aware intervention design needed |

*See [`docs/01_problem_brief.md`](docs/01_problem_brief.md) and [`docs/02_BRD.md`](docs/02_BRD.md) for the full write-up.*

## 4. Repository Structure

```
healthcare-noshow-analysis/
├── README.md                      ← you are here
├── index.html                     ← landing page → opens the live dashboard
├── Makefile                       ← `make build` runs the whole pipeline
├── requirements.txt               ← Python dependencies
├── .github/workflows/deploy.yml   ← auto-rebuilds data + deploys to GitHub Pages
├── data/
│   ├── raw/                       ← original dataset (110,527 appointments)
│   └── processed/                 ← cleaned dataset + data-quality log
├── docs/                          ← Business Analysis artifacts
│   ├── 01_problem_brief.md        ✅ business context, pain points, success criteria
│   ├── 02_BRD.md                  ✅ Business Requirements Document
│   ├── 03_FRD.md                  ✅ Functional Requirements Document
│   ├── 04_user_stories.md         ✅ user stories + acceptance criteria
│   ├── 05_requirements_traceability_matrix.md  ✅ RTM
│   ├── 06_uat_plan.md             ✅ UAT test scenarios
│   ├── 07_recommendation.md       ✅ final recommendation to leadership
│   ├── 08_interview_walkthrough.md ✅ rehearsal script: story + 2-min + numbers cheat sheet
│   └── requirements_pack.xlsx     ✅ Excel: User Stories + RTM + UAT (real BA deliverable)
├── sql/
│   └── noshow_analysis.sql        ✅ analysis queries (drivers, cohorts, KPIs)
├── scripts/
│   ├── 01_clean_profile.py        ✅ data cleaning + quality log
│   └── 02_build_dashboard_data.py ✅ builds the data the dashboard reads
└── dashboard/
    ├── noshow_dashboard.html      ✅ interactive dashboard (data-driven)
    ├── dashboard_data.js          ✅ generated data the dashboard loads
    ├── dashboard_data.json        ✅ portable copy of the aggregates
    └── dashboard_spec.md          ✅ Tableau/Power BI build spec
```

## 5. Data Source & Dictionary

**Source:** Medical Appointment No-Shows (public, ~110k appointments, Vitória, Brazil, 2016).

| Column | Description | Notes / Quality Issue |
|---|---|---|
| PatientId | Patient identifier | 48,228 appointments are repeat patients |
| AppointmentID | Appointment identifier | Unique, no duplicates |
| Gender | M / F | — |
| ScheduledDay | When the appointment was booked | Timestamp |
| AppointmentDay | Date of the appointment | Date only |
| Age | Patient age | ⚠️ 1 negative value (-1); max 115 |
| Neighbourhood | Location of clinic | 81 neighbourhoods |
| Scholarship | Enrolled in welfare program (Bolsa Família) | Binary 0/1 |
| Hipertension | Has hypertension | ⚠️ misspelled in source → renamed `hypertension` |
| Diabetes | Has diabetes | Binary 0/1 |
| Alcoholism | Has alcoholism | Binary 0/1 |
| Handcap | Disability count | ⚠️ not binary — values 0–4 |
| SMS_received | Reminder SMS sent | Binary 0/1 |
| No-show | Target | ⚠️ INVERTED: "Yes" = patient MISSED; "No" = patient attended. Renamed to `no_show` (1 = missed) |

## 6. How to Reproduce

```bash
pip install -r requirements.txt
make build        # clean raw data -> processed -> rebuild the dashboard data
make serve        # preview at http://localhost:8000/dashboard/noshow_dashboard.html
```

## 6a. Live Dashboard & Deployment (GitHub Pages)

The dashboard is **data-driven**: the page loads its numbers from `dashboard/dashboard_data.js`,
which is generated from the source data by the pipeline. **Change the data → rebuild → every graph updates.**

```
data/raw/*.csv  →  01_clean_profile.py  →  data/processed/  →  02_build_dashboard_data.py  →  dashboard_data.js  →  📊 dashboard
```

**To update the dashboard with new data:**
1. Replace the CSV in `data/raw/`.
2. Run `make build` (or let GitHub Actions do it — see below).
3. Commit & push. The live site updates.

**Two ways to host it on GitHub Pages:**
- **Automatic (recommended):** the included workflow `.github/workflows/deploy.yml` rebuilds the
  data from source and redeploys on every push. In the repo: **Settings → Pages → Source = GitHub Actions**.
  Now even pushing a new raw CSV refreshes the live charts automatically.
- **Simple:** **Settings → Pages → Source = Deploy from a branch → `main` / root**. GitHub serves the
  committed files directly; run `make build` locally before pushing so `dashboard_data.js` is up to date.

Live URL will be: `https://<your-username>.github.io/healthcare-noshow-analysis/`

## 7. Deliverable Checklist

- [x] Problem Brief
- [x] Business Requirements Document (BRD)
- [x] Documented data cleaning + quality log
- [x] SQL analysis
- [x] Functional Requirements Document (FRD)
- [x] User Stories + Acceptance Criteria
- [x] Requirements Traceability Matrix (RTM)
- [x] UAT Plan
- [x] Excel requirements pack (`docs/requirements_pack.xlsx`)
- [x] Dashboard (interactive HTML + build spec)
- [x] Final recommendation

**Project 1 is complete.** Optional polish: convert BRD/FRD to `.docx`, rebuild the dashboard in Tableau/Power BI from `data/processed/appointments_clean.csv`, and host the repo on GitHub.
