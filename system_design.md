# GharHold — App Design System

> Preserve the supplied forest-and-lime visual identity. GharHold is a calm, confident Mumbai rental coordination app: near-white canvas, deep forest typography, precise lime actions, restrained surfaces, and clear listing/request states.

**Product:** GharHold  
**Platform:** Flutter mobile application (Android-first; responsive on iOS, tablets and foldables where supported)  
**Theme:** Light by default; dark theme may be derived from the same semantic tokens  
**Design source:** Adapt the supplied Doc Slot design reference. Keep its palette, typography, spacing, shapes and visual character. Replace only product-specific content and components with GharHold rental workflows.

---

## 1. Design Intent

GharHold helps renters discover Mumbai rental listings, understand move-in costs, request a viewing, and track the owner's decision. Owners use the same app to review requests and update listing availability.

**Product idea:** “A viewing or token request should feel as clear as holding a cinema seat.”

The interface must make three things obvious:
1. Is this listing available to request?
2. What happens when I submit a request?
3. Is the request saved locally, submitted, approved, declined, or blocked by a conflict?

It must feel like a polished proptech product, not a generic finance dashboard, real-estate portal template, or unrelated admin panel.

### Visual direction to preserve

- **Forest Ink `#163300`** remains the dominant brand colour for headings, important text, navigation emphasis, icons and dark surfaces.
- **Lime Voltage `#9fe870`** remains the single high-energy accent for primary actions, active selections and carefully limited highlights.
- **Paper `#ffffff`** remains the main canvas.
- **Fog `#e8ebe6`** and **Linen Mist `#e2f6d5`** provide quiet card and highlight surfaces.
- Flat, confident, spacious and high contrast.
- Pill-shaped buttons, tags and selected navigation remain part of the visual identity.
- Cards and inputs use restrained rounded corners, not excessive glass effects or decoration.
- Inter is the primary UI typeface. Heavy display typography is used selectively, never at the expense of mobile usability.

### Product identity rules

- Use **GharHold** everywhere. Do not display Doc Slot, Wise, SlotLock, healthcare content, doctor/clinic terminology, payment-transfer language, country flags or finance-themed content.
- Keep the supplied palette and visual character. Do not create a new colour theme.
- Use Mumbai rental content: neighbourhood, BHK, monthly rent, deposit, brokerage, maintenance/society charges where supplied, preferred viewing window, request state, listing version and audit history.
- Use fictional renter/owner identities and illustrative seeded listings.
- Show approximate neighbourhood/area only. Never show exact home addresses or precise GPS coordinates.
- A token is a workflow hold marker only. Do not show payment collection, UPI, card, escrow or money-transfer flows.
- Do not add maps, chat, photo upload, authentication, push notifications, waitlists or an admin web portal.

---

## 2. Design Principles

1. **Trust first.** Calm surfaces, clear language, consistent spacing and deliberate hierarchy.
2. **One visual system.** Renter, Owner and Diagnostics use the same tokens and reusable components.
3. **Availability at a glance.** Listing/request states always use icon + visible text. Colour is supporting information, never the only signal.
4. **One primary action per context.** Lime Voltage marks the primary action; avoid competing bright elements.
5. **Cost transparency.** Rent, deposit and other known move-in costs are grouped and labelled. Never invent missing charges.
6. **Honest state.** A saved request is not necessarily submitted; a viewing approval is not a confirmed token. Show local sync and business status separately.
7. **Local clarity.** Show neighbourhood, BHK, rent, deposit, listing state and request state near the action they affect.
8. **Accessible by default.** Screen readers, large text, adequate touch targets and reduced motion are mandatory.
9. **Responsive, not stretched.** Wide layouts reorganise into useful panes rather than enlarging phone cards.
10. **Simulation is explicit.** Any simulated network/backend behaviour is labelled “Simulation” in the inspection bar and evidence UI.

---

## 3. Tokens — Colours

Keep these exact colour values from the supplied reference. Do not substitute a new green, lime, neutral or accent palette.

| Name | Value | Token | GharHold role |
|---|---|---|---|
| Forest Ink | `#163300` | `--color-forest-ink` | Primary brand dark; headings, important text, navigation, icon strokes, dark surfaces, button text on lime |
| Lime Voltage | `#9fe870` | `--color-lime-voltage` | Primary CTA fill, active selections, selected navigation accents, limited highlights |
| Spruce | `#054d28` | `--color-spruce` | Secondary dark green for supporting emphasis and owner/inspection emphasis |
| Linen Mist | `#e2f6d5` | `--color-linen-mist` | Soft green cards, selected low-emphasis surfaces, available-listing backgrounds |
| Signal Blue | `#0b4c72` | `--color-signal-blue` | Informational accent, pending/syncing/held indicators |
| Alarm Red | `#cb272f` | `--color-alarm-red` | Error, declined, unavailable-warning and destructive-action support; never the only status cue |
| Charcoal | `#454745` | `--color-charcoal` | Default body text and dense UI copy |
| Obsidian | `#0e0f0c` | `--color-obsidian` | Highest-emphasis headings and display text |
| Pebble | `#868685` | `--color-pebble` | Placeholder text, secondary icons, subtle borders and disabled details where contrast remains sufficient |
| Slate | `#6a6c6a` | `--color-slate` | Supporting body copy and helper labels |
| Fog | `#e8ebe6` | `--color-fog` | Card surfaces, dividers, muted panels and secondary backgrounds |
| Paper | `#ffffff` | `--color-paper` | Main page canvas, input surfaces, inverted cards and text on dark fills |

### Semantic usage

| UI purpose | Treatment |
|---|---|
| Primary action | Lime Voltage fill, Forest Ink text, pill shape |
| Secondary action | Paper fill, Forest Ink outline, pill shape |
| Tertiary action | Forest Ink text link or icon-plus-label action |
| Default page | Paper |
| Secondary panel | Fog |
| Selected/highlighted panel | Linen Mist |
| Primary headings | Obsidian or Forest Ink |
| Body copy | Charcoal |
| Supporting copy | Slate; Pebble only for non-critical hints/placeholders |
| Focus/selection outline | Forest Ink; visible focus without decorative glow |
| Error/destructive emphasis | Alarm Red with clear icon and text explanation |

### Listing and request status system

Always show **icon + label + colour treatment**. Never communicate status through colour alone.

| State | Icon | Suggested treatment | Meaning |
|---|---|---|---|
| `AVAILABLE` | Check-circle | Linen Mist, Forest Ink | A renter may attempt a new viewing request |
| `VIEWING_REQUESTED` | Clock | Signal Blue outline/label | One active viewing request exists; no second request is allowed |
| `TOKEN_LOCKED` | Lock | Forest Ink/Fog with strong contrast | Listing is token-locked and cannot accept another request |
| `UNAVAILABLE` | Ban or eye-off | Fog with Alarm Red supporting accent | Owner marked the listing off-market |
| `REQUESTED` | Clock | Signal Blue | Request is awaiting owner decision |
| `APPROVED` | Check-circle | Linen Mist | Viewing request approved; token step may be initiated |
| `DECLINED` | X-circle | Alarm Red supporting accent | Owner declined the request |
| `REOPENED` | Rotate-ccw | Linen Mist/Forest Ink | Declined request explicitly reopened with reason |
| `TOKEN_REQUESTED` | Key-round or clock | Signal Blue | Token hold requested; awaiting owner confirmation |
| `TOKEN_CONFIRMED` | Lock | Forest Ink | Token workflow confirmed; listing becomes `TOKEN_LOCKED` |
| `ABORTED` | Alert-circle | Fog/Alarm Red | Request aborted, usually after stale conflict |
| `PENDING_SYNC` | Cloud-upload or upload | Signal Blue | Saved locally and waiting for sync |
| `SUBMITTED` | Check | Linen Mist | Simulated remote accepted the command |
| `SYNC_FAILED_RETRYABLE` | Refresh-ccw | Fog/Signal Blue | Saved locally; safe retry is available |
| `CONFLICT_STALE_DATA` | Alert-triangle | Fog/Alarm Red | Listing changed; request was aborted and local truth refreshed |
| `RESOLVED_ABORTED` | Check-circle | Fog/Forest Ink | Conflict was acknowledged/resolved; request remains aborted |

Do not collapse business status and sync status into one badge. A request can be `REQUESTED` and `SYNC_FAILED_RETRYABLE` at the same time; show both when relevant.

---

## 4. Tokens — Typography

### Primary family: Inter

Inter is used for body copy, navigation, labels, forms, data, buttons, cards and most headings.

- Use Inter from Google Fonts or the platform's available Inter family.
- Weights: 400, 500, 600, 700.
- Body copy reference sizes: 16–18px, adapted to Flutter logical pixels and platform text scaling.
- Labels: 12–14px.
- Section headings: 20–25px on most phone layouts; 36px for major headings where space allows.

### Display family: Inter Black

Use Inter Black 900 for rare brand moments, onboarding title or an empty-state headline. Do not use oversized display type for listing cards, forms, rent figures, navigation or dense owner information.

### Type scale

| Role | Family | Weight | Size | Line height |
|---|---|---:|---:|---:|
| micro | Inter | 400–500 | 12px | 1.63 |
| caption | Inter | 400–500 | 14px | 1.55 |
| body-sm | Inter | 400 | 16px | 1.50 |
| body | Inter | 400 | 18px | 1.50 |
| body-lg | Inter | 500–600 | 25px | 1.30 |
| subheading | Inter | 700 | 36px | 1.25 |
| heading-sm | Inter | 700 | 45px | 1.10 |
| heading | Inter Black | 900 | 61px | 1.10 |
| heading-lg | Inter Black | 900 | 89px | 0.85 |
| display | Inter Black | 900 | 105px | 0.85 |

### Mobile typography rules

- Most phone screen titles should be 25px or smaller; use 36px only where the layout has room.
- 45px may be used for a short onboarding or empty-state headline on larger phones.
- 61px and above are exceptional brand/display sizes and should not appear in regular rental workflows.
- Keep rent, deposit and listing state readable. Never shrink key figures to fit a card.
- Allow text to wrap naturally. Never clip text at 200% scaling.
- Use compact negative tracking only for large display headlines.

---

## 5. Tokens — Spacing, Shapes and Elevation

### Spacing

Base unit: **4px**. Density: comfortable. Prefer breathing room over dense dashboards.

| Name | Value |
|---|---:|
| 4 | 4px |
| 8 | 8px |
| 12 | 12px |
| 16 | 16px |
| 20 | 20px |
| 24 | 24px |
| 28 | 28px |
| 32 | 32px |
| 40 | 40px |
| 44 | 44px |
| 48 | 48px |
| 56 | 56px |
| 64 | 64px |
| 100 | 100px |
| 124 | 124px |

Use 16–24px for common card padding, 8–12px between related elements and 24–32px between content groups.

### Border radius

| Element | Value | Use |
|---|---:|---|
| Tags/status badges | 9999px | Pill-shaped |
| Buttons | 9999px | Signature GharHold action |
| Navigation selections | 9999px | Active tab/segment |
| Cards | 10px | Standard listing and information cards |
| Inputs | 10px | Text fields and selectors |
| Large cards | 28px | Featured listing, cost summary or prominent status panel |
| Image masks | 1000px | Optional circular avatar only |

Do not make every container a giant pill. Use pills for controls and tags; use 10px cards for routine information and 28px for large feature surfaces.

### Shadows and borders

The theme is flat and restrained. Prefer hairline borders and surface contrast over floating shadows.

- Standard cards: subtle border or Fog surface, not a heavy shadow.
- Elevated panels: restrained shadow for bottom sheets/dialogs only.
- No decorative blur, glow or gradients.
- Avoid applying a shadow to every listing row.

---

## 6. Application Layout and Navigation

### Phone layout

- Use a compact top app bar with GharHold wordmark or current screen title, plus relevant actions only.
- Renter navigation: **Explore, My Requests, Owner, Settings** for this single-device hackathon prototype. The persistent Architecture Inspection Bar provides the actual Renter/Owner role switch; do not confuse navigation with authorization.
- If the UI uses a bottom navigation bar, every destination must have icon + visible text label.
- Keep the inspection bar visibly labelled **Simulation** and visually distinct but within the same palette.
- Respect safe areas and provide enough bottom padding so content is not hidden.
- Request forms and focused tasks may use a bottom sheet or focused page with a back action.

### Owner layout

- Owner screens share the same app bar, typography, surfaces, cards, forms and buttons as renter screens.
- Owner workflow: Inbox → Request Review → listing actions.
- Do not introduce a separate web-admin visual language.
- Do not invent multi-clinic, multi-society or enterprise administration.

### Wide layouts: tablets and foldables

Use purposeful two-pane layouts rather than stretching phone cards:
- **Listing Feed:** neighbourhood/listing list on the leading pane; selected listing detail on the trailing pane.
- **Listing Detail:** property summary and cost breakdown in one pane; request action/status in the other.
- **My Requests:** request list and selected request timeline in separate panes.
- **Owner Inbox:** request list and selected request details/actions in separate panes.

Keep state in Riverpod/application state above size-specific widgets so resizing does not erase the selected listing, draft note or scroll position.

---

## 7. Shared Components

All components must use shared tokens and be reused. Do not independently restyle them on each screen.

### 7.1 Primary CTA pill button

- Lime Voltage `#9fe870` fill.
- Forest Ink `#163300` label/icon.
- Fully rounded 9999px radius.
- Inter 500–600, 16px reference size.
- Minimum interactive target: 48 × 48 dp.
- Include pressed, disabled, loading and focus states.
- One visually dominant lime action per major viewport section.

Examples: **Request viewing**, **Retry Safely ↻**, **Approve request**, **Confirm token**, **Reset data** (destructive reset should use a confirmation flow and not be the dominant lime action).

### 7.2 Outlined pill button

Paper fill, 1px Forest Ink border, Forest Ink label, 9999px radius. Same sizing and typography as the primary button.

Examples: Cancel, Decline, Reopen, View details, Back.

### 7.3 Text-link action

Forest Ink text, Inter 500, 16px reference size. No background or border. Clear focus/pressed state.

### 7.4 Top app bar

Paper background, GharHold wordmark or screen title on the left, relevant back/settings/action icons on the right. Forest Ink title and icons. No website-style navigation, login/signup actions or unrelated brand controls.

### 7.5 Architecture Inspection Bar

A persistent compact bar, visible in the hackathon build and labelled **SIMULATION**. It contains:
- Role switch: `Renter` ↔ `Owner`.
- Fault mode: `Normal` | `Drop Network` | `Stale Conflict`.
- Evidence action: `View Evidence`.
- A clear indicator of the active simulation mode.

Do not imply the role switch is authentication or that the simulated remote service is a production backend. On narrow screens, allow the controls to wrap or open a compact sheet; never make them tiny.

### 7.6 ListingCard

Show:
- Listing title and BHK.
- Approximate neighbourhood only.
- Monthly rent in INR.
- Deposit amount or deposit months if known.
- Listing state with icon + text.
- Optional concise cost hint, only when source data exists.
- Clear tap affordance.

Use Paper or Fog surface, 10px radius, consistent padding, Forest Ink headings and Charcoal body text. No exact address, map pin coordinates or invented amenities.

### 7.7 ListingStatusPill

Show exact `ListingState` label with icon + text + colour treatment. Do not infer availability from a missing request. `VIEWING_REQUESTED`, `TOKEN_LOCKED` and `UNAVAILABLE` are not selectable as available.

### 7.8 CostBreakdownCard

Display only known values:
- Monthly rent.
- Security deposit.
- Brokerage (if supplied).
- Society/move-in charges (if supplied).
- Maintenance (if supplied).
- Total move-in estimate only when all included values and assumptions are explicit.

Use ₹ and Indian number grouping. Clearly label estimates and assumptions. Do not silently treat missing charges as zero. Stamp duty and registration are optional bonus assumptions and must be labelled illustrative/configurable, not official advice.

### 7.9 RequestForm

Fields:
- Preferred viewing window.
- Optional note, maximum 200 characters after trimming.
- Clear submit action.
- Inline validation with icon + text.

Do not collect phone numbers, exact addresses, identity documents or payment details unless a later approved PRD explicitly adds them.

### 7.10 RequestCard

Show listing title, approximate neighbourhood, renter identifier/display name (fictional in demo), preferred window, created/updated time, request business status and sync status separately. Provide a clear tap affordance to Request Review or Request Detail.

### 7.11 RequestTimeline

Chronological append-only audit history:
- Event label.
- Timestamp.
- Actor/role where allowed.
- Previous and next state.
- Human-readable reason/summary.
Use a simple line and dots; do not overdecorate. Keep screen-reader order logical.

### 7.12 SyncBadge

Support `PENDING_SYNC`, `SUBMITTED`, `SYNC_FAILED_RETRYABLE`, `CONFLICT_STALE_DATA` and `RESOLVED_ABORTED`. Always show icon + text. Do not merge sync status with business status.

### 7.13 RecoveryBanner

For `SYNC_FAILED_RETRYABLE`:
- Explain that the request is saved on this device.
- State that the network submission failed.
- Provide **Retry Safely ↻**.
- Do not imply the owner has received the request.

For `CONFLICT_STALE_DATA`:
- Explain that the listing changed while the renter was submitting.
- Show the refreshed listing state/version where useful.
- Explain that the request was aborted, not silently retried.

### 7.14 EvidenceEventRow

Show timestamp, correlation ID (truncated with copy affordance), component, event type, previous/next state, rule/error code and concise summary. Provide structured detail expansion. Never show private note text or exact address.

### 7.15 FormField

Paper surface, 1px Pebble border, Forest Ink focus border, 10px radius, Inter 400 at 16px reference size. Clear label, helper text and validation error. Minimum 48dp height. Support long text, semantic labels and 200% text scaling.

### 7.16 Empty, loading, error and confirmation patterns

Create reusable patterns for:
- No listings in selected neighbourhood.
- No requests yet.
- No owner requests pending.
- Loading feed/detail/inbox.
- Database or repository error.
- Rule rejection.
- Offline/retryable sync failure.
- Stale conflict.
- Confirm owner decline/reopen/off-market actions.
- Confirm reset/reseed.

Keep these as component states or dialogs/sheets, not invented top-level screens.

### 7.17 Bottom sheet

Paper surface, rounded top corners consistent with large-card styling, drag handle, clear close action, appropriate dimming, no decorative blur. Respect safe areas and keyboard appearance. Use for Request Viewing and contextual confirmations where suitable.

---

## 8. Screen-Level Design Map

The Tier 2 scope is intentionally small. Do not generate Doc Slot's 16-screen set or invent extra workflows.

| ID | Screen / surface | Primary visual focus | Components |
|---|---|---|---|
| GH01 | Listing Feed | Neighbourhood filter and 10 seeded listings | ListingCard, ListingStatusPill, Inspection Bar |
| GH02 | Listing Detail | Rent, deposit, approximate area, listing state and cost breakdown | CostBreakdownCard, ListingStatusPill, CTA |
| GH03 | Request Viewing sheet | Preferred time window and optional note | RequestForm, validation, CTA |
| GH04 | My Requests | Renter's request status and sync state | RequestCard, SyncBadge, RequestTimeline |
| GH05 | Owner Inbox / Review | Pending requests and owner decisions | RequestCard, RequestTimeline, action buttons |
| GH06 | Evidence Drawer | Live audit events and local state inspector | EvidenceEventRow, state rows |
| GH07 | Settings / Reset | Demo information and reset/reseed control | SettingsRow, confirmation dialog |

Cross-screen surfaces:
- Persistent Architecture Inspection Bar (Simulation label, role switch, fault controls, evidence button).
- Recovery banner for retryable sync failure.
- Conflict resolution card for stale data.
- Optional cost audit panel (bonus only, after core flow works).

### Screen-specific notes

- **GH01:** Listing feed is the home screen. Filter by neighbourhood: Powai, Andheri East, Bandra West, Malad West. Use the supplied 10 seeded fixtures. Never imply fixture prices are live market rates.
- **GH02:** Show approximate area only. Do not add exact address, map or photo upload. Display the listing version only in diagnostics or where it helps explain a conflict.
- **GH03:** Validate the note at the domain boundary. Do not create a request or write to the DB when rejected. On valid action, local persistence happens before remote simulation.
- **GH04:** Show business status and sync status as separate concepts. A request saved locally during network failure remains visible.
- **GH05:** Owner actions: Approve, Decline, Reopen with reason, Confirm token, Mark off-market, Relist where allowed. Enforce owner role in domain rules even though the role switch is only a demo seam.
- **GH06:** Hidden from ordinary navigation but accessible through the persistent Inspection Bar. Use the same palette and typography; density may be higher. Show database rows and structured events without private notes.
- **GH07:** Clearly state that reset wipes local demo state and reseeds fixtures. Require confirmation.

---

## 9. Imagery and Iconography

### Imagery

- Prefer no large hero imagery. This is an operational rental workflow, not a property advertising marketplace.
- Use a simple property-type glyph or initials-style visual for seeded cards.
- If static listing images are later added, use fictional/demo-safe images and keep them secondary to rent, area and state.
- Do not add photo upload, map tiles or external image dependencies.
- Never use real tenant personal photos or exact property imagery that reveals an address.

### Icons

Use one consistent outline icon family. Keep stroke weight and sizing consistent. Recommended semantic concepts: home, building, bed, rupee, map-pin (neighbourhood only), check-circle, clock, lock, ban, user, search, filter, calendar, alert-triangle, refresh, clipboard-list, settings, database and activity.

- Every meaningful status uses icon + label.
- Interactive icons need semantic labels.
- No country flags, medical icons, payment gateway symbols or finance-transfer motifs.

---

## 10. Interaction and Motion

- Immediate, restrained feedback: pressed, selected, disabled, loading, success and error.
- Avoid elaborate transitions, bouncing, parallax or decorative motion.
- Respect reduce-motion preference.
- Short transitions for sheets, selection and navigation only when useful.
- Loading indicators must not cause layout jumps.
- Failed actions explain what happened and what the user can do next.
- Confirm destructive actions such as reset.
- Do not show a fake success state before the repository/service outcome is known.
- A local `PENDING_SYNC` request may be shown immediately, but must be labelled as saved locally and not as submitted/approved.

---

## 11. Accessibility and Responsive Requirements

These are product constraints, not optional polish.

- Every tappable control has a clear semantic label.
- Every interactive target is at least **48 × 48 dp**.
- Text supports **200% scaling** without clipping or overlap.
- Normal text contrast meets **WCAG AA 4.5:1**.
- Errors and statuses use icon + text, never colour alone.
- Listing cards, request cards and timelines have logical screen-reader grouping/order.
- Example listing announcement: “Two-bedroom flat, Powai, sixty-two thousand rupees per month, available, button.”
- Navigation items always show icon + text label.
- Respect reduced motion.
- Layouts remain usable across phone sizes and large text.
- Listing Feed, Listing Detail, My Requests and Owner Inbox have purposeful two-pane layouts on tablets/foldables.
- Keep selected listing, form draft and scroll position outside size-specific widgets.

---

## 12. Do's and Don'ts

### Do

- Use Forest Ink `#163300` for brand weight and important text.
- Use Lime Voltage `#9fe870` deliberately for primary actions and active states.
- Use Paper, Fog and Linen Mist for the calm canvas.
- Keep exact palette values and Inter typography.
- Use pill shapes for buttons/tags/navigation; 10px cards/inputs; 28px large feature surfaces.
- Show monthly rent, deposit, neighbourhood and current listing state clearly.
- Separate request business status from sync status.
- Label every simulated backend/fault control as Simulation.
- Use the Tier 2 frozen names exactly.
- Use consistent fictional seed data across screens.
- Show honest local persistence and recovery behaviour.

### Don't

- Do not change the forest/lime theme or invent another palette.
- Do not use Doc Slot, Wise, healthcare, finance-transfer, flags, globe/coin or QR components.
- Do not use gradients, decorative blur or excessive shadows.
- Do not use Lime Voltage as small text on Paper; use it as a fill or against Forest Ink.
- Do not use pure black `#000000` as default body text.
- Do not use oversized 89–105px headlines in normal mobile screens.
- Do not make every component a pill.
- Do not use colour alone for listing, request or sync state.
- Do not show exact home addresses or precise GPS.
- Do not imply a token is a payment.
- Do not imply `REQUESTED` or `SUBMITTED` means `APPROVED`.
- Do not add payments, live maps, chat, photo upload, authentication, waitlist, push notifications, admin web or multi-device sync.
- Do not add AWS, GCP, Firebase or another cloud dependency to the hackathon prototype.
- Do not expose Evidence Drawer in ordinary navigation.
- Do not create a separate Owner visual theme.

---

## 13. Surfaces and Elevation

| Level | Name | Value | Purpose |
|---:|---|---|---|
| 0 | Paper | `#ffffff` | Default screen canvas and main content |
| 1 | Fog | `#e8ebe6` | Cards, secondary panels and dividers |
| 2 | Linen Mist | `#e2f6d5` | Soft emphasis and available/positive states |
| 3 | Lime Voltage | `#9fe870` | Primary action and active selection |
| 4 | Forest Ink | `#163300` | Dark emphasis panels and high-contrast blocks |

Cards prefer Fog or a subtle 1px border. Use elevated shadows only for dialogs, sheets or overlays. Never shadow every card.

---

## 14. Dark Theme Guidance

Light is the default. If a dark theme is implemented, derive it from the same semantic tokens:
- Forest Ink/Obsidian family for main dark canvas.
- Spruce for supporting panels.
- Paper for primary readable text.
- Linen Mist for restrained supporting highlights.
- Lime Voltage for primary action fills and selected states, with Forest Ink text.
- Preserve icon + text statuses and AA contrast.
- Do not simply invert every colour or introduce gradients/new accents.

---

## 15. Antigravity Agent Prompt Guide

Use this block whenever generating or refining GharHold screens.

```text
PROJECT: GHARHOLD — FLUTTER MOBILE APP

Read brain.md, design.md, flow.md, the GharHold PRD, Architecture Document and Tier 2 Build Spec before implementation. The Tier 2 Build Spec resolves conflicts in earlier GharHold documents. Do not use Doc Slot product requirements.

DESIGN SOURCE OF TRUTH
1. design.md is the single source of truth for visual tokens and reusable components.
2. Preserve exact Forest Ink #163300, Lime Voltage #9fe870, Spruce #054d28, Linen Mist #e2f6d5, Signal Blue #0b4c72, Alarm Red #cb272f, Charcoal #454745, Obsidian #0e0f0c, Pebble #868685, Slate #6a6c6a, Fog #e8ebe6 and Paper #ffffff.
3. Preserve Inter typography, 4px spacing scale, pill buttons/tags, 10px standard cards/inputs and 28px feature cards.
4. Do not create a new palette, type system, component language, gradients, blur or glass styling.
5. Renter, Owner and Diagnostics must look like one product.

PRODUCT SOURCE OF TRUTH
- GharHold is a Mumbai rental viewing/token coordination prototype.
- Core journey: Discover → Act → Respond → Track.
- Use only the frozen screens GH01–GH07 and documented workflows.
- Show approximate neighbourhood only; never exact home addresses or precise GPS.
- Token is a workflow hold marker; no money moves.
- One active request per listing.
- A request's business status and sync status are separate.
- Local Drift database is the single source of truth for UI.
- SimulatedRemoteService is explicitly labelled Simulation.
- Do not invent backend, cloud, payment, auth, map, chat, image upload or notification behaviour.

ARCHITECTURE
- Exactly four modules: domain, data, observability, ui.
- Domain is pure Dart and has zero Flutter/database/network imports.
- UI observes repository/Drift state and dispatches commands only.
- Repository validates, persists request + audit event in one transaction, then syncs through the simulated service.
- Use exact frozen enum/class/rule/event names from brain.md.
- Never create state changes in widgets.

COMPONENTS
Reuse ListingCard, ListingStatusPill, CostBreakdownCard, RequestForm, RequestCard, RequestTimeline, SyncBadge, RecoveryBanner, EvidenceEventRow, FormField, Inspection Bar and shared state patterns.
- Primary CTA: Lime Voltage pill with Forest Ink text.
- Secondary CTA: Paper pill with Forest Ink outline.
- Every listing/request/sync status uses icon + visible label.
- Never make VIEWING_REQUESTED, TOKEN_LOCKED or UNAVAILABLE appear requestable.
- Never imply REQUESTED or SUBMITTED means approved.
- Never present token as a payment.

ACCESSIBILITY
- Minimum 48 × 48 dp touch targets.
- Support 200% text scaling.
- WCAG AA 4.5:1 normal text contrast.
- Semantic labels and logical screen-reader order.
- Respect reduce motion.
- Provide Loading, Empty, Error/Conflict and Content states.

CONTENT
- Use the exact 10 illustrative listings and neighbourhoods in the Tier 2 Build Spec.
- Clearly label seed prices as demo fixtures, not live market data.
- Do not use lorem ipsum or invent amenities/fees.
- No exact address, phone number, medical detail or personal text in telemetry/evidence.

Before marking a screen complete, compare it with design.md and existing GharHold screens. Fix mismatches instead of creating a new visual style.
```

---

## 16. Flutter Token Mapping

Implement these tokens once in the Flutter theme layer. Widgets must consume theme tokens rather than hardcoding colours, spacing or radii.

```dart
const gharHoldColors = {
  'forestInk': 0xFF163300,
  'limeVoltage': 0xFF9FE870,
  'spruce': 0xFF054D28,
  'linenMist': 0xFFE2F6D5,
  'signalBlue': 0xFF0B4C72,
  'alarmRed': 0xFFCB272F,
  'charcoal': 0xFF454745,
  'obsidian': 0xFF0E0F0C,
  'pebble': 0xFF868685,
  'slate': 0xFF6A6C6A,
  'fog': 0xFFE8EBE6,
  'paper': 0xFFFFFFFF,
};
```

Use Flutter `ColorScheme`, `ThemeData`, text themes, shape themes and component themes. The map above is a token reference, not a requirement to use a runtime map.

### Final design QA checklist

- [ ] Exact forest/lime palette preserved.
- [ ] No Doc Slot, Wise, healthcare or finance-transfer content remains.
- [ ] GharHold branding and Mumbai rental content used.
- [ ] Inter typography and defined hierarchy followed.
- [ ] Spacing follows the 4px scale.
- [ ] Buttons/tags use pills; standard cards/inputs use 10px radius.
- [ ] Listing, request and sync states use icon + text.
- [ ] Business and sync status are not merged.
- [ ] No exact home addresses or precise GPS.
- [ ] Token is not represented as a payment.
- [ ] Simulation is clearly labelled.
- [ ] No feature outside the GharHold PRD/Tier 2 Build Spec is introduced.
- [ ] All interactive targets are at least 48dp.
- [ ] Text works at 200% scaling and contrast meets WCAG AA.
- [ ] Loading, empty, error/conflict and content states exist.
- [ ] Shared components are reused consistently.

**The result must retain the supplied forest-and-lime design identity, while every screen, component, label and interaction belongs unmistakably to GharHold.**
