-- ============================================================
-- Patient No-Show Analysis — SQL
-- Demonstrates: joins-free single-table analytics, aggregations,
-- CASE bucketing, window functions, CTEs.
-- Table assumed: appointments_clean (from data/processed/appointments_clean.csv)
-- Columns: PatientId, AppointmentID, Gender, ScheduledDay, AppointmentDay,
--          Age, Neighbourhood, Scholarship, hypertension, Diabetes, Alcoholism,
--          handicap, sms_received, no_show (1=missed), lead_days, risk_tier, ...
-- ============================================================

-- 1) Headline KPI: overall no-show rate
SELECT
    COUNT(*)                                   AS total_appointments,
    SUM(no_show)                               AS total_no_shows,
    ROUND(100.0 * SUM(no_show) / COUNT(*), 1)  AS no_show_rate_pct
FROM appointments_clean;

-- 2) Strongest driver: no-show rate by lead-time bucket
SELECT
    CASE
        WHEN lead_days = 0             THEN '0 same-day'
        WHEN lead_days BETWEEN 1 AND 3 THEN '1 1-3d'
        WHEN lead_days BETWEEN 4 AND 7 THEN '2 4-7d'
        WHEN lead_days BETWEEN 8 AND 14 THEN '3 8-14d'
        WHEN lead_days BETWEEN 15 AND 30 THEN '4 15-30d'
        ELSE '5 30d+'
    END                                        AS lead_bucket,
    COUNT(*)                                   AS appts,
    ROUND(100.0 * SUM(no_show) / COUNT(*), 1)  AS no_show_rate_pct
FROM appointments_clean
GROUP BY lead_bucket
ORDER BY lead_bucket;

-- 3) The confound to flag: SMS vs no-show, then controlled for lead time
SELECT
    sms_received,
    ROUND(100.0 * SUM(no_show) / COUNT(*), 1)  AS no_show_rate_pct,
    ROUND(AVG(lead_days), 1)                    AS avg_lead_days   -- explains the confound
FROM appointments_clean
GROUP BY sms_received;

-- 4) No-show rate by age band
SELECT
    CASE
        WHEN Age <= 17 THEN '0-17'
        WHEN Age <= 34 THEN '18-34'
        WHEN Age <= 54 THEN '35-54'
        WHEN Age <= 74 THEN '55-74'
        ELSE '75+'
    END                                        AS age_band,
    COUNT(*)                                   AS appts,
    ROUND(100.0 * SUM(no_show) / COUNT(*), 1)  AS no_show_rate_pct
FROM appointments_clean
GROUP BY age_band
ORDER BY age_band;

-- 5) Equity check: welfare (Scholarship) gap
SELECT
    Scholarship,
    ROUND(100.0 * SUM(no_show) / COUNT(*), 1)  AS no_show_rate_pct
FROM appointments_clean
GROUP BY Scholarship;

-- 6) Top clinics by no-show rate (min volume 500 to avoid noise)
SELECT
    Neighbourhood,
    COUNT(*)                                   AS appts,
    ROUND(100.0 * SUM(no_show) / COUNT(*), 1)  AS no_show_rate_pct
FROM appointments_clean
GROUP BY Neighbourhood
HAVING COUNT(*) >= 500
ORDER BY no_show_rate_pct DESC
LIMIT 10;

-- 7) Validation of the risk tiers (does risk_tier separate no-show rate?)
SELECT
    risk_tier,
    COUNT(*)                                   AS appts,
    ROUND(100.0 * SUM(no_show) / COUNT(*), 1)  AS no_show_rate_pct
FROM appointments_clean
GROUP BY risk_tier
ORDER BY no_show_rate_pct;

-- 8) Repeat-patient behaviour: prior no-show history predicts future no-shows
--    (window-function feature built in cleaning; shown here as a cohort cut)
WITH cohort AS (
    SELECT
        CASE WHEN prior_no_show_rate = 0 THEN 'never missed before'
             WHEN prior_no_show_rate < 0.5 THEN 'sometimes missed'
             ELSE 'frequently missed' END      AS history_cohort,
        no_show
    FROM appointments_clean
    WHERE prior_appts > 0
)
SELECT
    history_cohort,
    COUNT(*)                                   AS appts,
    ROUND(100.0 * SUM(no_show) / COUNT(*), 1)  AS no_show_rate_pct
FROM cohort
GROUP BY history_cohort
ORDER BY no_show_rate_pct;
