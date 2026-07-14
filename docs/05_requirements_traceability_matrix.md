# Requirements Traceability Matrix (RTM)
## Patient No-Show Risk Flagging & Intervention

| Field | Value |
|---|---|
| Author | Nityam Sharma, Business Analyst |
| Version | 1.0 |
| Purpose | Trace every business requirement → functional requirement → user story → UAT test case, so nothing is built untested and nothing is tested without a business reason. |
| Related | [BRD](02_BRD.md) · [FRD](03_FRD.md) · [User Stories](04_user_stories.md) · [UAT](06_uat_plan.md) |

---

| Business Req | Description (short) | Functional Req | User Story | UAT Test Case | Priority | Status |
|---|---|---|---|---|---|---|
| BR-001 | Score every appointment at booking | FR-101, FR-106 | US-01 | UAT-01 | Must | Ready for build |
| BR-002 | Classify Low/Medium/High | FR-102, FR-104 | US-02 | UAT-02 | Must | Ready for build |
| BR-003 | Use agreed risk features | FR-103, FR-402 | US-03 | UAT-03 | Must | Ready for build |
| BR-004 | Route to intervention tier | FR-201, FR-202 | US-05 | UAT-05 | Must | Ready for build |
| BR-005 | High-risk confirmation + overbooking | FR-204, FR-205 | US-06 | UAT-06 | Must | Ready for build |
| BR-006 | Medium-risk multi-touch cadence | FR-203, FR-206 | US-07 | UAT-07 | Should | Ready for build |
| BR-007 | Dashboard breakdowns | FR-301, FR-302, FR-305 | US-08 | UAT-08 | Must | Ready for build |
| BR-008 | 90-day trend vs target | FR-303 | US-09 | UAT-09 | Must | Ready for build |
| BR-009 | Data-quality rules before scoring | FR-401, FR-403 | US-11 | UAT-11 | Must | Ready for build |
| BR-010 | Equity (welfare) gap indicator | FR-304 | US-10 | UAT-10 | Should | Ready for build |
| BR-011 | Transparent, auditable scoring | FR-104, FR-105 | US-04 | UAT-04 | Should | Ready for build |

## Coverage Check

- **11 / 11** business requirements map to at least one functional requirement ✅
- **11 / 11** business requirements map to at least one user story ✅
- **11 / 11** business requirements map to at least one UAT test case ✅
- **No orphan requirements** (every BR has downstream coverage) ✅
- **No orphan tests** (every UAT case traces back to a BR) ✅
