# GharHold — Product Requirements Document

*MAL 4 Hackathon · Proptech Track · Mumbai rentals*

> **Working title:** GharHold (rename freely). **Tagline:** A viewing slot or token on a flat works like a held cinema seat: one holder at a time, visible to everyone, safe to retry.
>
> **Judging philosophy we design for:** *Build something small enough to finish and thoughtful enough to defend.* Framework names, layer counts and feature counts earn nothing by themselves. Diagram, ADRs, code, tests and demo must all agree.

---

## 1. One-Page Brief

|  |  |
| --- | --- |
| **User problem** | In Mumbai rentals, a flat listed on WhatsApp groups or by brokers is often already gone, or shown to several renters at once. Renters travel across the city for viewings nobody confirmed, and can pay a token for a flat someone else also holds. Owners and society admins have no single place to see who holds what. Result: wasted trips, double commitments, and disputes over tokens. |
| **Core journey** | **Discover** a listing in a neighbourhood feed → **Act** by requesting a viewing or token hold → **Respond** (Owner / Society Admin approves, declines or reopens) → **Track** the outcome and status as the renter. Must survive app kill and restart. |
| **Scope (in)** | One neighbourhood-scoped listing feed, one request flow (viewing request, then token hold), a role switcher (Renter / Owner-Society Admin), a local database as source of truth, a simulated remote service with fault injection, a diagnostic evidence drawer, automated tests for the rule and for recovery. |
| **Scope (out)** | Real auth, real payments, live maps, chat, photos upload, brokerage marketplace, push notifications, multi-device sync, society NOC document workflow. Each exclusion is deliberate (see section 7). |
| **Constraints** | Small enough to finish in the hackathon window. Any mobile stack allowed; we use Flutter. Exactly 4 architectural modules, exactly 2 ADRs, 1 diagram. No secrets in the repo. Approximate location only (area names, never exact addresses). Simulated backend must be labelled in the UI. |
| **Assumptions** | (1) Double-booking and ghost availability are real pain points for Mumbai renters (to validate informally with 3 to 5 people before the demo). (2) One owner or society admin controls a listing's response. (3) A token is a *hold marker*, no money moves. (4) One device simulates both roles. (5) Network failure and stale data are the failures that matter most for this flow. |

---

## 2. Problem Deep-Dive

### 2.1 What actually goes wrong

1. **Ghost availability.** A listing is forwarded across groups; no one updates it when it is taken.
2. **Parallel promises.** Two renters are told "yes, come at 6 pm" or "pay the token to hold it" for the same flat.
3. **Invisible state.** The renter cannot tell whether a request is pending, approved, declined or just lost.
4. **Flaky connectivity at the worst moment.** A submission fails in a lift or a stairwell, the renter retries blindly, and now there are duplicate requests.
5. **Owner overload.** Owners and society admins answer the same question repeatedly, with no history of who asked for what.

### 2.2 What the product promises

- A listing can be **held by one request at a time**, and everyone sees its true state.
- Every request has a **visible lifecycle** the renter can track.
- A failed submission is **never lost and never duplicated**: it is saved locally, shown honestly, and can be retried safely.
- If the listing changed while the renter was acting (stale data), the app **says why** and refreshes the truth.

---

## 3. Users

| Role | Who | Goal | Key worry |
| --- | --- | --- | --- |
| **Renter** | A young professional or family relocating within Mumbai | Find a flat that is genuinely available, secure a viewing, hold it with a token | Wasting a trip, losing a token to a double-booking |
| **Owner / Society Admin** | A landlord, or a co-operative housing society office-bearer who approves tenants | See who is asking, approve one, decline others, reopen a mistake | Conflicting commitments, repeated queries |

Both roles are exercised in the demo through an in-app **Role Switcher** on the Architecture Inspection Bar.

---

## 4. The Stated Business Rule

> **Headline rule (shown at the top of the README and on screen):** **"A listing accepts a new viewing or token request only while it is AVAILABLE. A listing has at most one active request at a time."**

Supporting invariants enforced in the same pure domain layer:

| ID | Invariant | Rejection code |
| --- | --- | --- |
| **BR-1** | A listing that is `UNAVAILABLE` or `TOKEN_LOCKED` rejects any new request. | `ERR_LISTING_NOT_AVAILABLE` |
| **BR-1b** | A listing in `VIEWING_REQUESTED` already has its one active request; a second request is rejected. | `ERR_ACTIVE_REQUEST_EXISTS` |
| **BR-2** | A `DECLINED` request cannot become `APPROVED` directly. It must go through `REOPENED` with a non-empty reason. | `ERR_REOPEN_REASON_REQUIRED` |
| **BR-3** | Every request carries an `idempotencyKey` (UUID) created at creation; a retry upserts by that key, so duplicates cannot exist. | `ERR_DUPLICATE_SUPPRESSED` (logged, not shown as an error) |

Why this rule is good for judging: it is visible in the UI (a rejected tap with a clear message), cheap to unit test, tied to the actual problem (double-booking), and it forces real state design rather than boolean flags.

---

## 5. Core User Journey

### Step 1: Discover (Renter)

- Neighbourhood feed (for example Powai, Andheri East, Bandra West, Malad West, Thane West) showing seeded listings with state badges: *Available*, *Viewing requested*, *Token locked*, *Unavailable*.
- Filter by neighbourhood. Listing detail shows approximate area only.
- UI states: **Loading**, **Empty** (no listings in this area), **Error**, **Content**.

### Step 2: Act (Renter)

- Tap **Request viewing** (or **Hold with token** on an approved viewing). Pick a preferred time window and add a note (validated and length limited).
- The domain rules run first. If the listing is not `AVAILABLE`, the UI shows the rejection reason inline (icon plus text, not colour alone).
- On success the request is saved locally as `PENDING_SYNC`, then synced to the simulated remote service.

### Step 3: Respond (Owner / Society Admin)

- Switch role. The owner inbox shows requests for their listings.
- Actions: **Approve**, **Decline**, **Reopen** (reason required), **Mark off-market**.
- Approving a viewing moves the listing toward `TOKEN_LOCKED` when a token is confirmed; marking off-market moves it to `UNAVAILABLE`.

### Step 4: Track (Renter)

- A "My requests" timeline: status, last update, sync state (*Saved on device*, *Submitted*, *Retry needed*, *Conflict*).
- After a force-close and relaunch, everything is still there, including any unfinished submission.

### Recoverable failure shown live (required)

Toggle **Drop Network** → submit a request → it is saved as `SYNC_FAILED_RETRYABLE` with a banner → turn the network back on → tap **Retry Safely ↻** → exactly one request exists, status `SUBMITTED`. Evidence is visible in the diagnostic drawer.

---

## 6. Functional Requirements

Priority: **P0** must ship, **P1** should ship, **P2** only if time remains.

### Listings and feed

| ID | Requirement | Priority |
| --- | --- | --- |
| F-01 | Seeded listings (about 10) across at least 4 Mumbai neighbourhoods, with rent, deposit months, area, BHK, state. | P0 |
| F-02 | Feed filtered by neighbourhood; shows state badge from the local database. | P0 |
| F-03 | Listing detail with approximate area (no exact address) and request history count. | P0 |

### Requests

| ID | Requirement | Priority |
| --- | --- | --- |
| F-04 | Create viewing request (time window plus note), validated by domain rules before any write. | P0 |
| F-05 | Create token hold on an approved viewing. | P0 |
| F-06 | Requests persist across app kill and restart, including unsynced ones. | P0 |
| F-07 | Idempotent retry: retrying never creates a second record. | P0 |
| F-08 | Stale-data conflict handling: server version ahead of client version aborts the action, refreshes the listing, explains why. | P0 |

### Owner / Society Admin

| ID | Requirement | Priority |
| --- | --- | --- |
| F-09 | Inbox of requests per listing owned. | P0 |
| F-10 | Approve, Decline, Reopen (reason required), Mark off-market. | P0 |
| F-11 | Role views stay consistent: a change by the owner appears in the renter's tracker from the same local source of truth. | P0 |

### Inspection and evidence

| ID | Requirement | Priority |
| --- | --- | --- |
| F-12 | **Architecture Inspection Bar**: Role switch, Fault injection (Normal, Offline, Stale Conflict), Open Evidence drawer. Clearly labelled "Simulation". | P0 |
| F-13 | **Diagnostic Evidence Drawer**: structured log of state transitions, rule rejections and sync failures with correlation IDs. | P0 |
| F-14 | Data reset control that wipes local data and re-seeds. | P1 |

### Bonus (only after the core flow is stable)

| ID | Requirement | Priority |
| --- | --- | --- |
| F-15 | **Move-in cost audit**: deterministic breakdown (rent, deposit, brokerage, stamp duty and registration as labelled assumptions), plus a `gemini-4-argon` explanation with validated JSON output and a deterministic fallback. | P2 (Bonus B) |
| F-16 | **Measure SDK**: app launch and `proptech_action_sync` spans, one measured improvement with before and after. | P2 (Bonus A) |

---

## 7. Scope Decisions (Built vs Deliberately Excluded)

| Excluded | Why we excluded it | What it would take later |
| --- | --- | --- |
| Real authentication | Adds setup time, proves nothing about the architecture | Identity provider behind an `AuthService` interface |
| Real payments for token | Compliance and integration risk; token is modelled as a hold marker | Payment gateway adapter in `data/remote` |
| Live maps | Visual complexity earns no points | Approximate area already modelled as a value object |
| Multi-device sync | Needs a real backend | Replace `SimulatedRemoteService` implementation, same interface |
| Chat | Different problem (communication, not state) | Separate module |
| Push notifications | Infrastructure heavy | Notification adapter driven by state-change events |
| Society NOC document upload | Document handling out of scope | New state `NOC_PENDING` added to the request machine |

Intentionally small: **one rule, two state machines, one repository, one simulated service.**

---

## 8. Non-Functional Requirements

| Area | Requirement |
| --- | --- |
| **Persistence** | All core records live in a local SQLite database via Drift; app kill and restart loses nothing. |
| **Reliability** | Every sync failure ends in a named state (`SYNC_FAILED_RETRYABLE` or `CONFLICT_STALE_DATA`), never an unexplained spinner. |
| **Observability** | Every transition, rejection and failure writes one structured event (`timestamp`, `correlationId`, `component`, `eventType`, `previousState`, `newState`, `ruleOrErrorCode`, `summary`). |
| **Accessibility** | Semantic labels on all tappable controls, minimum 48 dp tap targets (44 pt on iOS), text scaling support, errors shown with icon and text, not colour alone. |
| **Security and privacy** | No secrets in the repo (API key via build-time define or local env file ignored by git). Input validated and length limited. Approximate area only. A working data reset. Telemetry never contains notes or personal text. |
| **Maintainability** | Domain package has zero Flutter, database or network imports; enforced by a simple import check in CI or a test. |

---

## 9. Success Metrics

### Demo and judging metrics (what we measure ourselves against)

| Metric | Target |
| --- | --- |
| Core journey completed end to end in the pitch | Under 90 seconds |
| Persistence proof | Force-close and relaunch shows identical state |
| Rule rejection shown | Invalid request rejected with code and clear UI message |
| Recovery shown | Retry yields exactly 1 record, log trace visible |
| Tests | Business rule test and recovery test both pass in a single command |
| Diagram, ADRs, folders, demo agreement | Names match 1-to-1 (checked with the traceability table in the architecture doc) |

### Product metrics (what this would track in real life)

- Share of viewing requests that reach a decision within 24 hours.
- Share of confirmed viewings that actually happen.
- Double-booking incidents prevented (rejections by BR-1 and BR-1b).
- Duplicate submissions suppressed by idempotency.

---

## 10. Bonus Plan (Only After the Core Flow Works)

### Bonus B: `gemini-4-argon` Move-in Cost Audit

- **Feature:** Renter taps *Audit move-in cost* on a listing or an approved request.
- **Division of labour:** the **domain computes** the numbers deterministically; the **model only explains and flags** (for example "deposit is high relative to rent"). The model never produces the figures we show as truth.
- **Data flow:** `CostBreakdown (domain)` → `GeminiArgonService` (timeout, JSON schema validation) → UI. On timeout, bad JSON or offline: deterministic summary with a visible **Fallback mode** badge.
- **Honest caveat:** statutory amounts (stamp duty, registration) are *configurable illustrative constants*, labelled as such.

### Bonus A: Measure SDK

- Track app launch, `proptech_action_sync` span and handled sync exceptions.
- Pick one measurable bottleneck (for example feed query time with a missing index), fix it, and show before and after.

---

## 11. Risks and Mitigations

| Risk | Likelihood | Mitigation |
| --- | --- | --- |
| Scope creep (more screens, more features) | High | Freeze scope after the core loop works; every addition must serve the rule or the recovery story |
| Diagram and code drift | High | Single traceability table; rename in all five artefacts at once |
| Fault injection looks fake | Medium | Label it "Simulation" and explain it as a deliberate test seam in ADR-002 |
| Bonus work eats core time | High | Bonuses start only after tests pass and the demo is rehearsed |
| Time lost on UI polish | Medium | Design screens in Stitch once, build plain Material widgets |
| Judges' what-if questions | Certain | Prepared Q&A in the flow document |

---

## 12. Rubric Traceability: Where Each Point Is Earned

| Judging criterion | Weight | Where we earn it |
| --- | --- | --- |
| 1A Problem framing and scope | 10 | Sections 1, 2, 7 |
| 1B Structure and boundaries | 15 | 4 modules, dependency direction `ui → domain ← data`, no rules in widgets |
| 1C Data and state | 15 | Drift as single source of truth; two finite state machines; restart persistence; BR-1 to BR-3; role consistency |
| 1D Failure and recovery | 10 | Outbox plus idempotency key plus optimistic version; live Retry Safely demo |
| 1E Trade-offs and adaptability | 10 | 2 ADRs; limitations section; adaptation notes |
| 2 Testing and observability | 15 | Rule test, recovery test, structured diagnostic events |
| 3 Working user journey | 15 | Discover → Act → Respond → Track with loading, empty, error, content states |
| 4 Architecture defence | 10 | Prepared answers grounded in code; traceability table |
| Bonus A, B | extra | Section 10, only after core is solid |

---

## 13. Open Questions (Decide Early, Write the Answer into the README)

1. Do we allow *multiple* pending viewing requests per listing (queue) or strictly one? **Current decision: strictly one**, simpler and defensible; a queue is a documented future change.
2. Does a token hold require a prior approved viewing? **Current decision: yes.**
3. Who can mark a listing off-market? **Current decision: owner / society admin only.**
4. Seed data count and neighbourhoods? **Current decision: about 10 listings, 4 to 5 neighbourhoods.**
