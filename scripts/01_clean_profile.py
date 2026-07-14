"""
01_clean_profile.py
Data cleaning & preparation for the Patient No-Show project.

Implements the mandatory data-quality rules (DQ-1..DQ-7) defined in
docs/02_BRD.md §10, produces a cleaned dataset, engineered risk features,
and a human-readable data-quality log.

Run:  python3 scripts/01_clean_profile.py
"""
from pathlib import Path
import pandas as pd

BASE = Path(__file__).resolve().parents[1]
RAW = BASE / "data" / "raw" / "noshow_appointments.csv"
OUT_DIR = BASE / "data" / "processed"
OUT_DIR.mkdir(parents=True, exist_ok=True)

log_lines = []
def log(msg):
    print(msg)
    log_lines.append(msg)

log("=== Data Quality & Cleaning Log — Patient No-Show ===\n")
df = pd.read_csv(RAW)
start_rows = len(df)
log(f"Loaded raw dataset: {start_rows:,} rows, {df.shape[1]} columns")

# DQ-3: fix misspelled / inconsistent column names
df = df.rename(columns={
    "Hipertension": "hypertension",
    "Handcap": "handicap",
    "No-show": "no_show_raw",
    "SMS_received": "sms_received",
})
log("DQ-3: renamed misspelled columns (Hipertension->hypertension, Handcap->handicap)")

# DQ-7: cast dates and derive lead time / weekday
df["ScheduledDay"] = pd.to_datetime(df["ScheduledDay"])
df["AppointmentDay"] = pd.to_datetime(df["AppointmentDay"])
df["lead_days"] = (df["AppointmentDay"].dt.normalize()
                   - df["ScheduledDay"].dt.normalize()).dt.days
df["appt_weekday"] = df["AppointmentDay"].dt.day_name()
log("DQ-7: parsed dates; derived lead_days and appt_weekday")

# DQ-5: fix inverted target ("Yes" = missed) -> clear 1/0 flag
df["no_show"] = (df["no_show_raw"] == "Yes").astype(int)
log("DQ-5: created no_show (1 = missed, 0 = attended) from inverted source label")

# DQ-1: remove invalid ages
bad_age = (df["Age"] < 0).sum()
df = df[df["Age"] >= 0].copy()
log(f"DQ-1: removed {bad_age} record(s) with negative age")

# DQ-2: remove negative lead time (appointment before booking)
bad_lead = (df["lead_days"] < 0).sum()
df = df[df["lead_days"] >= 0].copy()
log(f"DQ-2: removed {bad_lead} record(s) with appointment dated before booking")

# DQ-6: derive prior no-show history per patient (chronological)
df = df.sort_values(["PatientId", "ScheduledDay"])
df["prior_appts"] = df.groupby("PatientId").cumcount()
df["prior_no_shows"] = (df.groupby("PatientId")["no_show"]
                        .apply(lambda s: s.shift().fillna(0).cumsum())
                        .reset_index(level=0, drop=True))
_denom = df["prior_appts"].where(df["prior_appts"] > 0)  # NaN when no prior appts
df["prior_no_show_rate"] = (df["prior_no_shows"] / _denom).fillna(0.0)
log("DQ-6: engineered prior_appts, prior_no_shows, prior_no_show_rate per patient")

# Feature buckets used by scoring rules (BRD §7)
df["lead_bucket"] = pd.cut(df["lead_days"], [-1, 0, 3, 7, 14, 30, 400],
                           labels=["same-day", "1-3d", "4-7d", "8-14d", "15-30d", "30d+"])
df["age_bucket"] = pd.cut(df["Age"], [-1, 17, 34, 54, 74, 200],
                          labels=["0-17", "18-34", "35-54", "55-74", "75+"])

# Transparent rule-based risk score (v1, per BR-011 "auditable")
def risk_points(r):
    p = 0
    p += {"same-day": 0, "1-3d": 1, "4-7d": 2, "8-14d": 3, "15-30d": 3, "30d+": 4}[str(r["lead_bucket"])]
    p += {"0-17": 1, "18-34": 2, "35-54": 1, "55-74": 0, "75+": 0}[str(r["age_bucket"])]
    p += 1 if r["Scholarship"] == 1 else 0
    p += 2 if r["prior_no_show_rate"] >= 0.5 else (1 if r["prior_no_show_rate"] > 0 else 0)
    return p
df["risk_points"] = df.apply(risk_points, axis=1)
df["risk_tier"] = pd.cut(df["risk_points"], [-1, 1, 4, 99],
                         labels=["Low", "Medium", "High"])
log("Applied transparent rule-based risk score -> risk_tier (Low/Medium/High)")

# Save
out_csv = OUT_DIR / "appointments_clean.csv"
df.to_csv(out_csv, index=False)
log(f"\nSaved cleaned dataset: {out_csv.name} ({len(df):,} rows, {df.shape[1]} cols)")
log(f"Rows removed in cleaning: {start_rows - len(df)}")

# Validation summary
log("\n=== Validation: no-show rate by risk tier ===")
tier = df.groupby("risk_tier", observed=True)["no_show"].agg(["mean", "count"])
for t, row in tier.iterrows():
    log(f"  {t:<7} n={int(row['count']):>6,}  no-show rate={row['mean']:.1%}")

(OUT_DIR / "data_quality_log.txt").write_text("\n".join(log_lines))
print(f"\nWrote data_quality_log.txt")
