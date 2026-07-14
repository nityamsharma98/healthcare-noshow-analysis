# Dashboard Specification — Patient No-Show Monitoring

| Field | Value |
|---|---|
| Author | Nityam Sharma, Business Analyst |
| Purpose | Define the monitoring dashboard for Tableau / Power BI, satisfying BR-007, BR-008, BR-010. |
| Reference build | [`noshow_dashboard.html`](noshow_dashboard.html) — a working HTML mock built from the real cleaned data |
| Data source | `data/processed/appointments_clean.csv` |

---

## 1. Audience & Purpose

Clinic managers and the Patient Access Director use this daily/weekly to see **where** no-shows concentrate and **whether** interventions are moving the rate toward target.

## 2. Layout (top → bottom)

**Row 1 — KPI tiles**
| Tile | Measure | Notes |
|---|---|---|
| Appointments | `COUNT(appointments)` | filtered by date/clinic |
| No-show rate | `SUM(no_show)/COUNT(*)` | headline KPI, 1 decimal % |
| Missed appointments | `SUM(no_show)` | absolute volume |
| Recoverable at 15% reduction | `SUM(no_show) * 0.15` | impact framing |

**Row 2 — Risk & driver**
- **No-show rate by risk tier** (bar; color Low=green, Medium=amber, High=red) — validates the model.
- **No-show rate by lead-time bucket** (bar; sequential) — the strongest driver.

**Row 3 — Analyst insight**
- **SMS confound callout** — SMS vs no-SMS no-show rate *with average lead days shown* to explain the confound. Prevents leadership from misreading SMS as harmful.
- **No-show rate by prior-history cohort** (never / sometimes / frequently missed).

**Row 4 — Segments**
- **By age band** (bar).
- **Equity indicator** — welfare vs non-welfare no-show rate, shown as a gap (BR-010).

**Row 5 — Operations**
- **Top clinics by no-show rate** (bar, min 1,000 appts) — where to send outreach capacity.
- **Rolling no-show trend** (line) with a **configurable target line** (BR-008).

## 3. Fields / Measures (Power BI DAX-style)

```
No-Show Rate = DIVIDE(SUM(appointments[no_show]), COUNTROWS(appointments))
Missed = SUM(appointments[no_show])
Recoverable @15% = [Missed] * 0.15
Welfare Gap = CALCULATE([No-Show Rate], appointments[Scholarship]=1)
             - CALCULATE([No-Show Rate], appointments[Scholarship]=0)
```

## 4. Filters / Slicers
- Date range (AppointmentDay)
- Clinic (Neighbourhood)
- Risk tier

## 5. Interactions
- KPI tiles respond to all slicers.
- Clicking a clinic bar cross-filters the driver charts.
- Target line value is a parameter the manager can set.

## 6. Build notes for Tableau / Power BI
1. Connect to `appointments_clean.csv`.
2. Confirm `no_show` is numeric (1/0) so rate aggregates work.
3. Create the calculated measures above.
4. Recreate the five rows; match the semantic tier colors (green/amber/red).
5. Publish; schedule at least a daily refresh (NFR-04).

*The included `noshow_dashboard.html` is a faithful, data-accurate reference so a reviewer can see the intended result without opening a BI tool.*
