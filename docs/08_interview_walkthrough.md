# Interview Walkthrough — Patient No-Show Project
### Rehearsal script for Nityam Sharma · Business Analyst

This doc has four things:
1. **The 30-second opener** — how to start
2. **The full story** — step by step, for when they say "walk me through it"
3. **The 2-minute version** — the tight middle ground
4. **The numbers cheat sheet** — memorize these cold
5. **Signature moments + likely follow-up Q&A**

---

## 1. The 30-second opener

> "I built an end-to-end business analysis project on a real healthcare problem: patient no-shows. Using a dataset of 110,000 real appointments, I found that 1 in 5 were missed, dug into *why*, and designed a solution — a risk-scoring feature that flags each appointment low, medium, or high risk the moment it's booked, so staff can intervene on the right patients. I produced the full BA package: BRD, functional requirements, user stories, a traceability matrix, a UAT plan, and a dashboard. The most interesting part was catching a misleading signal in the data that would have led leadership to the wrong conclusion."

*The last line is bait — it makes them ask "what signal?" and now you control the conversation.*

---

## 2. The full story (step by step)

### Act 1 — Why I picked this problem
I wanted a project close to the healthcare work I do, so I chose **patient no-shows** — when someone books an appointment and doesn't turn up. Every no-show is a wasted clinical slot, a doctor sitting idle, and another patient who could've had that time. The business question was simple: **which appointments are likely to be missed, why, and what can we do before it happens?**

### Act 2 — Where I got the data
I used a **public dataset of ~110,000 real medical appointments**, 14 columns — patient age and gender, the date they *booked*, the date of the *appointment*, clinic location, whether they got an SMS reminder, some health flags (diabetes, hypertension), and whether they showed up.

### Act 3 — Cleaning it (real skill on display)
I profiled the data in Python first and found several problems — and documented every one, because that trail matters:
1. **The target column was backwards** — "No-show = No" actually meant the patient *showed up*. I renamed it to a clear flag where **1 = missed**.
2. **A patient with age −1** — impossible, so I removed invalid ages.
3. **Appointments dated *before* they were booked** — a negative time gap, 5 clear errors, dropped.
4. **Misspelled columns** ("Hipertension", "Handcap") — standardized.
5. **A column I assumed was yes/no actually had values 0–4** — couldn't treat it as a flag.
6. **Engineered new features** that were the whole key: **lead time** (gap between booking and appointment), **age bands**, and each patient's **prior no-show history**.

After cleaning I had ~110,500 solid rows.

### Act 4 — What the data told me
- **20% of appointments were no-shows** — the size of the problem.
- **Lead time was the biggest driver** — same-day missed ~5%, but 30+ days out missed **33%**.
- **Younger patients missed more**, and patients with a history of missing kept missing.

### Act 5 — The "aha" moment ⭐
When I looked at SMS reminders, the raw numbers said something crazy: **patients who got a reminder missed *more* — 28% vs 17%.** At face value you'd say "stop sending reminders."

But that didn't make sense, so I dug deeper and found the reminders were mostly sent for **far-out appointments**, which are *already* high-risk due to the long lead time. So the SMS wasn't causing no-shows — the **long wait drove both**. A classic **correlation-not-causation trap**. I flagged it clearly so no one made a bad call off it, and designed the solution around lead time instead of trusting a single reminder.

### Act 6 — Turning analysis into a solution (the BA work)
- **A risk score at booking** — every appointment flagged **Low / Medium / High** from lead time, past history, age, and welfare status.
- **A matching intervention plan** — Low gets a normal reminder, Medium gets a couple of nudges, High gets a confirmation call and can be controlled-overbooked if unconfirmed. Spend expensive effort (calls) only on the riskiest ~20%.
- **Full documentation**: BRD, FRD, user stories with acceptance criteria, a traceability matrix (every requirement links to a test), and a UAT plan.

### Act 7 — Did it actually work?
I validated the risk score against real data and it separated behavior cleanly: **Low 5.6%, Medium 20%, High 38%** — nearly a **7× difference**. Fully transparent, rule-based — no black box, anyone can audit *why* a patient was flagged.

### Act 8 — The recommendation
A **phased rollout** targeting a **15% reduction** in no-shows within two quarters, with one guardrail: watch the gap for lower-income patients so the fix doesn't make access *less* fair. Plus a **dashboard** to track no-show rate by clinic, risk tier, and trend.

### Act 9 — What I learned / would do next
If I extended it, I'd A/B test the interventions to prove impact, then test a predictive model against my rule-based baseline. Biggest lesson: **the cleaning and the critical thinking mattered more than the fancy analysis** — the SMS finding would've been a costly mistake if I'd taken the data at face value.

---

## 3. The 2-minute version

> "I built an end-to-end BA project on patient no-shows — a real healthcare problem where booked appointments go unattended, wasting clinical capacity.
>
> I started with a public dataset of about 110,000 real appointments. Before analyzing anything, I cleaned it — and it had real issues: the show-up column was actually inverted, there was a patient with a negative age, and some appointments were dated before they were even booked. I fixed all of that and, importantly, engineered the features that turned out to matter most — the lead time between booking and appointment, and each patient's prior no-show history.
>
> The analysis showed a 20% no-show rate, and lead time was the biggest driver — same-day appointments were missed 5% of the time, but appointments a month out were missed 33%.
>
> The moment I'm proudest of: SMS reminders *looked* like they made no-shows worse — 28% versus 17%. But when I dug in, the reminders were just going to far-out, already-risky appointments. It was correlation, not causation. Catching that stopped a bad decision.
>
> From there I did the BA work — I scoped a risk-scoring feature that flags each appointment low, medium, or high at booking, with a matching intervention plan, and wrote the BRD, FRD, user stories, traceability matrix, and UAT plan. I validated the score: low-risk missed 5.6%, high-risk missed 38%, so it genuinely predicts. I recommended a phased rollout targeting a 15% reduction, with an equity guardrail, and built a dashboard to track it.
>
> My big takeaway was that the cleaning and the critical thinking drove the value more than any fancy modeling."

*(~280 words ≈ 2 minutes at a natural pace.)*

---

## 4. Numbers cheat sheet (memorize these)

| Metric | Number | Why it matters |
|---|---|---|
| Total appointments | **~110,000** (110,521 after cleaning) | Scale of the analysis |
| Rows removed in cleaning | **6** (1 bad age + 5 negative lead) | You cleaned carefully |
| Overall no-show rate | **20%** (20.2%) | The problem, quantified |
| Same-day no-show | **~5%** (4.6%) | Low end of the driver |
| 30+ day-lead no-show | **33%** | High end — lead time is #1 driver |
| SMS reminder (raw) | **28% vs 17%** | The misleading signal |
| Avg lead: SMS vs no-SMS | **19 days vs 6 days** | The explanation for the confound |
| Younger (18–34) vs older (55–74) | **24% vs 16%** | Age is a factor |
| Risk tiers (the payoff) | **Low 5.6% / Med 20% / High 38%** | Proof the model works (~7×) |
| Equity gap (welfare) | **24% vs 20%** | The guardrail you watch |
| Target impact | **15% relative reduction** | Your recommendation |

**If you remember only three:** 20% overall · lead time 5%→33% · risk tiers 5.6%→38%.

---

## 5. Signature moments + follow-up Q&A

**The three moments to emphasize**
1. **The inverted label** — shows you got your hands in the data, not just ran a template.
2. **The SMS confound** — senior-level critical thinking. *Your differentiator.*
3. **The risk tiers working (5.6% → 38%)** — a concrete, quantified result.

**Likely follow-ups**
- *"Was this real company data?"* → "No — a public dataset, so I could share it. But I chose the problem because it mirrors the no-show and risk-stratification work I do at UnitedHealth."
- *"Why rules instead of machine learning?"* → "For v1, transparency and auditability matter in healthcare — leadership and compliance need to understand *why* a patient was flagged. ML is a fair Phase 3 once we've measured the rule baseline."
- *"What was the hardest part?"* → The SMS confound — realizing the obvious read was wrong and proving why.
- *"How would you measure success after launch?"* → No-show rate rolling 90-day vs target, % of interventions hitting high-risk appointments, and the welfare equity gap not widening.
