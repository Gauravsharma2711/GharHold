import sys
import os
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN, MSO_ANCHOR
from pptx.enum.shapes import MSO_SHAPE

def create_deck():
    prs = Presentation()
    # 16:9 Widescreen dimensions
    prs.slide_width = Inches(13.333)
    prs.slide_height = Inches(7.5)
    blank_layout = prs.slide_layouts[6] # Blank slide layout

    # Color Palette - Modern Proptech / Obsidian Theme
    BG_DARK = RGBColor(15, 23, 42)        # Slate 900 (Canvas)
    CARD_BG = RGBColor(30, 41, 59)        # Slate 800 (Card background)
    CARD_BORDER = RGBColor(51, 65, 85)    # Slate 700 (Border)
    HEADER_ACCENT = RGBColor(163, 230, 53)# Lime 400 (Brand Accent)
    EMERALD_GREEN = RGBColor(52, 211, 153)# Emerald 400
    SKY_BLUE = RGBColor(56, 189, 248)     # Sky 400
    AMBER_ORANGE = RGBColor(251, 191, 36) # Amber 400
    CRIMSON_RED = RGBColor(248, 113, 113) # Red 400
    TEXT_LIGHT = RGBColor(248, 250, 252)  # Slate 50
    TEXT_MUTED = RGBColor(148, 163, 184)  # Slate 400
    TEXT_DIM = RGBColor(100, 116, 139)    # Slate 500
    CARD_SUB_BG = RGBColor(23, 32, 48)    # Deep container

    def set_slide_background(slide):
        background = slide.background
        fill = background.fill
        fill.solid()
        fill.fore_color.rgb = BG_DARK

    def add_header(slide, slide_num, title, tagline):
        # Top banner / Header
        tb = slide.shapes.add_textbox(Inches(0.8), Inches(0.4), Inches(11.733), Inches(0.9))
        tf = tb.text_frame
        tf.word_wrap = True
        tf.margin_left = tf.margin_top = tf.margin_right = tf.margin_bottom = 0

        p0 = tf.paragraphs[0]
        p0.text = f"SLIDE {slide_num} OF 5  |  GHARHOLD PROPTECH ARCHITECTURE"
        p0.font.size = Pt(10)
        p0.font.bold = True
        p0.font.color.rgb = HEADER_ACCENT

        p1 = tf.add_paragraph()
        p1.text = title
        p1.font.size = Pt(22)
        p1.font.bold = True
        p1.font.color.rgb = TEXT_LIGHT

        p2 = tf.add_paragraph()
        p2.text = tagline
        p2.font.size = Pt(11)
        p2.font.color.rgb = TEXT_MUTED

    def add_card(slide, left, top, width, height, bg_color=CARD_BG, border_color=CARD_BORDER):
        shape = slide.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, left, top, width, height)
        shape.fill.solid()
        shape.fill.fore_color.rgb = bg_color
        if border_color:
            shape.line.color.rgb = border_color
            shape.line.width = Pt(1.5)
        else:
            shape.line.fill.background()
        return shape

    # =========================================================================
    # SLIDE 1: ONE-PAGE SOLUTION BRIEF
    # =========================================================================
    s1 = prs.slides.add_slide(blank_layout)
    set_slide_background(s1)
    add_header(s1, 1, "One-Page Solution Brief: Transparent Rental Coordination", 
               "A local-first, verifiable proptech mobile application eliminating ghost availability & double-booking in Mumbai rentals")

    # Card 1: Problem & Target Roles (Left Column: Left 0.8, Top 1.5, Width 3.6, Height 5.4)
    add_card(s1, Inches(0.8), Inches(1.5), Inches(3.6), Inches(5.5))
    tb_c1 = s1.shapes.add_textbox(Inches(1.0), Inches(1.65), Inches(3.2), Inches(5.2))
    tf1 = tb_c1.text_frame
    tf1.word_wrap = True

    p = tf1.paragraphs[0]
    p.text = "THE PROBLEM & TARGET USERS"
    p.font.size = Pt(12)
    p.font.bold = True
    p.font.color.rgb = HEADER_ACCENT

    p = tf1.add_paragraph()
    p.text = "• The Mumbai Rental Reality:\n  Renters rush across Mumbai only to find advertised flats already promised ('ghost availability'). Informative deposits ('tokens') are taken without receipts, and mobile networks drop in transit causing lost submissions."
    p.font.size = Pt(9.5)
    p.font.color.rgb = TEXT_LIGHT

    p = tf1.add_paragraph()
    p.text = "• Dual User Roles:\n  - Renter: Relocating professionals seeking verified, singular viewing slots without competing blind or risking informal cash advances.\n  - Owner: Landlords wanting verified, serious tenant commitments without managing chaotic parallel WhatsApp threads."
    p.font.size = Pt(9.5)
    p.font.color.rgb = TEXT_LIGHT

    p = tf1.add_paragraph()
    p.text = "• Core Guarantee:\n  At most ONE active viewing request per listing at any time (enforced in pure Dart domain and SQLite storage engine)."
    p.font.size = Pt(9.5)
    p.font.bold = True
    p.font.color.rgb = SKY_BLUE

    # Card 2: Core User Journey (Top Right: Left 4.6, Top 1.5, Width 7.9, Height 2.5)
    add_card(s1, Inches(4.6), Inches(1.5), Inches(7.9), Inches(2.6))
    tb_c2 = s1.shapes.add_textbox(Inches(4.8), Inches(1.65), Inches(7.5), Inches(2.3))
    tf2 = tb_c2.text_frame
    tf2.word_wrap = True

    p = tf2.paragraphs[0]
    p.text = "CORE USER JOURNEY: DISCOVER → ACT → RESPOND → TRACK"
    p.font.size = Pt(12)
    p.font.bold = True
    p.font.color.rgb = HEADER_ACCENT

    # 4 Journey Blocks
    steps = [
        ("1. DISCOVER", "GH01 / GH02", "Browse Powai, Andheri East.\nInspect approximate area and verified move-in cost breakdown.", SKY_BLUE),
        ("2. ACT", "GH03 Sheet", "Choose time window; submit request. Commits locally in SQLite; outbox syncs to remote.", HEADER_ACCENT),
        ("3. RESPOND", "GH05 Inbox", "Owner reviews inbound request. Approves, declines with mandatory reason, or reopens.", AMBER_ORANGE),
        ("4. TRACK", "GH04 Requests", "Live reactive timeline tracks REQUESTED -> APPROVED -> TOKEN_REQUESTED -> CONFIRMED.", EMERALD_GREEN)
    ]
    for i, (title, screen, desc, col) in enumerate(steps):
        bx = Inches(4.8 + i * 1.85)
        add_card(s1, bx, Inches(2.05), Inches(1.8), Inches(1.85), bg_color=CARD_SUB_BG, border_color=col)
        tb_step = s1.shapes.add_textbox(bx + Inches(0.08), Inches(2.1), Inches(1.64), Inches(1.75))
        stf = tb_step.text_frame
        stf.word_wrap = True
        stf.margin_left = stf.margin_top = stf.margin_right = stf.margin_bottom = 0
        p = stf.paragraphs[0]
        p.text = title
        p.font.size = Pt(10)
        p.font.bold = True
        p.font.color.rgb = col
        p = stf.add_paragraph()
        p.text = screen
        p.font.size = Pt(8.5)
        p.font.bold = True
        p.font.color.rgb = TEXT_MUTED
        p = stf.add_paragraph()
        p.text = desc
        p.font.size = Pt(8)
        p.font.color.rgb = TEXT_LIGHT

    # Card 3: Scope, Assumptions, Constraints, Success (Bottom Right: Left 4.6, Top 4.25, Width 7.9, Height 2.75)
    add_card(s1, Inches(4.6), Inches(4.25), Inches(7.9), Inches(2.75))
    tb_c3 = s1.shapes.add_textbox(Inches(4.8), Inches(4.35), Inches(7.5), Inches(2.5))
    tf3 = tb_c3.text_frame
    tf3.word_wrap = True

    p = tf3.paragraphs[0]
    p.text = "SCOPE, CONSTRAINTS & SUCCESS CRITERIA"
    p.font.size = Pt(12)
    p.font.bold = True
    p.font.color.rgb = HEADER_ACCENT

    # 3 sub-columns inside Card 3
    subcols = [
        ("Prototype Scope", 
         "• 7 screens (GH01-GH07) with Forest/Lime theme.\n• Drift SQLite local-first engine.\n• Outbox pattern & simulated remote service.\n• Inspection bar for demo role switching & faults.\n• Diagnostic drawer with live SQLite audit trail.",
         SKY_BLUE),
        ("Assumptions & Constraints",
         "• Assumption 1: Ghost availability is eliminated by single active request rule.\n• Assumption 2: Token is a hold marker, not a payment gateway.\n• Constraint: Runs on 1 device; simulated backend; zero cloud secrets; approximate areas only.",
         AMBER_ORANGE),
        ("Success Conditions",
         "• Zero double-booking incidents (BR-1/1b).\n• Zero lost submissions on network drops.\n• Instant UI responsiveness (< 16ms render loop).\n• 100% automated test pass rate (54 tests covering domain, data, recovery & UI).",
         EMERALD_GREEN)
    ]
    for i, (title, body, col) in enumerate(subcols):
        bx = Inches(4.8 + i * 2.5)
        add_card(s1, bx, Inches(4.7), Inches(2.4), Inches(2.15), bg_color=CARD_SUB_BG, border_color=CARD_BORDER)
        tb_sc = s1.shapes.add_textbox(bx + Inches(0.08), Inches(4.75), Inches(2.24), Inches(2.05))
        sctf = tb_sc.text_frame
        sctf.word_wrap = True
        sctf.margin_left = sctf.margin_top = sctf.margin_right = sctf.margin_bottom = 0
        p = sctf.paragraphs[0]
        p.text = title
        p.font.size = Pt(10)
        p.font.bold = True
        p.font.color.rgb = col
        p = sctf.add_paragraph()
        p.text = body
        p.font.size = Pt(8.5)
        p.font.color.rgb = TEXT_LIGHT

    # Speaker Notes Slide 1
    s1.notes_slide.notes_text_frame.text = (
        "Judges, welcome to GharHold. In Mumbai's rental market, finding a home is an exercise in anxiety. "
        "Renters battle 'ghost availability'—rushing to view flats already promised to someone else—while owners juggle chaotic WhatsApp threads and multiple uncoordinated tokens.\n\n"
        "GharHold solves this through a local-first coordination protocol built on four steps: Discover, Act, Respond, and Track. "
        "What makes GharHold unique is our uncompromising invariant: at most one active viewing request per listing at any time.\n\n"
        "Notice how the solution is scoped: we don't need speculative payment rails or live GPS tracking to solve the core trust failure. "
        "By capturing local commitments instantaneously on-device and backing them with an atomic SQLite outbox, we eliminate double-bookings before they can ever occur. "
        "In the next slide, I'll walk you through how our 4-layer clean architecture guarantees this offline and online."
    )

    # =========================================================================
    # SLIDE 2: HIGH-LEVEL DESIGN (ARCHITECTURE & DATA FLOW)
    # =========================================================================
    s2 = prs.slides.add_slide(blank_layout)
    set_slide_background(s2)
    add_header(s2, 2, "High-Level Design: 4-Layer Clean Architecture", 
               "Strict layer boundaries, pure Dart domain invariants, and reactive Drift SQLite persistence")

    # Architecture Overview Cards (Top: Left 0.8, Top 1.5, 4 Modules across 11.733 inches)
    modules = [
        ("UI LAYER", "lib/ui/", "Flutter, Material 3, Theme Tokens",
         "• Renders GH01–GH07 screens & Inspection Bar.\n• Observes reactive Drift streams (0 local business state).\n• Wraps inputs with MsrMask (zero visual PII).\n• Dispatches user commands to ProptechRepository.",
         SKY_BLUE),
        ("DOMAIN LAYER", "lib/domain/", "Pure Dart (0 Framework Imports)",
         "• Invariant rules: BR-1, BR-1b, BR-2, BR-3 in rules.dart.\n• Entity models: PropertyListing, ViewingRequest, AuditEvent, CostBreakdown.\n• Abstract ports: ProptechRepository, RemoteService, Clock.\n• Verified pure by compiler AST tests.",
         HEADER_ACCENT),
        ("DATA LAYER", "lib/data/", "Drift, SQLite Engine",
         "• AppDatabase: Single durable source of truth.\n• Partial Unique Index: one_active_request_per_listing.\n• Outbox orchestration & atomic transactions in repository.\n• SimulatedRemoteService with normal/drop/conflict faults.",
         AMBER_ORANGE),
        ("OBSERVABILITY", "lib/observability/", "DiagnosticSink + Measure.sh",
         "• Internal Audit Trail: DiagnosticSink writes to SQLite audit_events (inspected via GH06 Evidence Drawer).\n• Mobile Telemetry: ObservabilityService / Measure.sh for ANRs, crash reporting, and spans.\n• Strict deny-list drops all personal attributes.",
         EMERALD_GREEN)
    ]
    for i, (title, path, tech, desc, col) in enumerate(modules):
        bx = Inches(0.8 + i * 2.98)
        add_card(s2, bx, Inches(1.5), Inches(2.85), Inches(2.7), border_color=col)
        tb_m = s2.shapes.add_textbox(bx + Inches(0.12), Inches(1.6), Inches(2.6), Inches(2.5))
        mtf = tb_m.text_frame
        mtf.word_wrap = True
        mtf.margin_left = mtf.margin_top = mtf.margin_right = mtf.margin_bottom = 0
        p = mtf.paragraphs[0]
        p.text = title
        p.font.size = Pt(11)
        p.font.bold = True
        p.font.color.rgb = col
        p = mtf.add_paragraph()
        p.text = f"{path}  |  {tech}"
        p.font.size = Pt(8)
        p.font.bold = True
        p.font.color.rgb = TEXT_MUTED
        p = mtf.add_paragraph()
        p.text = desc
        p.font.size = Pt(8.5)
        p.font.color.rgb = TEXT_LIGHT

    # Lower Half: Data Flow & Architectural Guarantees (Left 0.8, Top 4.35, Width 11.733, Height 2.7)
    add_card(s2, Inches(0.8), Inches(4.35), Inches(11.733), Inches(2.7))
    tb_df = s2.shapes.add_textbox(Inches(1.0), Inches(4.45), Inches(11.333), Inches(2.5))
    dftf = tb_df.text_frame
    dftf.word_wrap = True

    p = dftf.paragraphs[0]
    p.text = "DATA FLOW PIPELINE & DEPENDENCY INVERSION PRINCIPLE"
    p.font.size = Pt(12)
    p.font.bold = True
    p.font.color.rgb = HEADER_ACCENT

    # 4 Data Flow Stages Cards
    stages = [
        ("1. User Action & UI Dispatch", 
         "Renter/Owner triggers action in UI (e.g. submit request, approve).\nUI delegates entirely to ProptechRepository port.\nUI does NOT touch SQLite directly or make HTTP calls.",
         SKY_BLUE),
        ("2. Pure Domain Invariant Check", 
         "ProptechBusinessRules evaluates entity state.\nChecks listing availability (BR-1), single active request (BR-1b), note length <= 200 chars (BR-2), and actor role (BR-3).\nRejections return immediately without mutating state.",
         HEADER_ACCENT),
        ("3. Atomic SQLite Transaction", 
         "AppDatabase commits state change locally BEFORE remote sync:\n  - Listing state -> VIEWING_REQUESTED\n  - Request inserted (status: REQUESTED, sync: PENDING_SYNC)\n  - Audit event appended to audit_events\nReactive Drift streams update UI in < 16ms.",
         AMBER_ORANGE),
        ("4. Outbox Sync & Dual Diagnostics", 
         "Repository dispatches to RemoteService port.\nOn success -> syncState: SUBMITTED.\nOn network drop -> syncState: SYNC_FAILED_RETRYABLE.\nDiagnosticSink logs SQLite event; Measure.sh traces performance span.",
         EMERALD_GREEN)
    ]
    for i, (stitle, sbody, scol) in enumerate(stages):
        bx = Inches(1.0 + i * 2.85)
        add_card(s2, bx, Inches(4.85), Inches(2.7), Inches(2.05), bg_color=CARD_SUB_BG, border_color=CARD_BORDER)
        tb_st = s2.shapes.add_textbox(bx + Inches(0.08), Inches(4.9), Inches(2.54), Inches(1.95))
        sttf = tb_st.text_frame
        sttf.word_wrap = True
        sttf.margin_left = sttf.margin_top = sttf.margin_right = sttf.margin_bottom = 0
        p = sttf.paragraphs[0]
        p.text = stitle
        p.font.size = Pt(9.5)
        p.font.bold = True
        p.font.color.rgb = scol
        p = sttf.add_paragraph()
        p.text = sbody
        p.font.size = Pt(8.2)
        p.font.color.rgb = TEXT_LIGHT

    # Speaker Notes Slide 2
    s2.notes_slide.notes_text_frame.text = (
        "Here is the architectural foundation of GharHold. We follow strict Clean Architecture principles with four distinct modules: UI, Domain, Data, and Observability.\n\n"
        "Notice the critical boundary: our Domain layer is 100% pure Dart. It has zero dependencies on Flutter, Drift, or network libraries. "
        "In fact, we run an automated architectural purity test in our CI suite (test/domain/domain_purity_test.dart) that inspects AST imports to guarantee no framework code ever bleeds into our business logic.\n\n"
        "At the core of the Data layer is SQLite managed via Drift. SQLite is our single, durable source of truth. "
        "The UI never mutates state in isolation; all screens subscribe to live, reactive Drift streams. "
        "When an action occurs, the repository validates against domain rules, commits the state locally in an atomic SQLite transaction, and only then initiates remote synchronization. "
        "Even if the network disappears or the app process is terminated, state integrity is completely preserved."
    )

    # =========================================================================
    # SLIDE 3: LOW-LEVEL DESIGN & CRITICAL FEATURE
    # =========================================================================
    s3 = prs.slides.add_slide(blank_layout)
    set_slide_background(s3)
    add_header(s3, 3, "Low-Level Design: Viewing Request & Local-First Outbox Sync", 
               "Transactional Outbox, SQLite Partial Unique Index, and Optimistic Concurrency Control")

    # Left Column: State Machines & Invariants (Left 0.8, Top 1.5, Width 3.8, Height 5.5)
    add_card(s3, Inches(0.8), Inches(1.5), Inches(3.8), Inches(5.5))
    tb_s3_l = s3.shapes.add_textbox(Inches(1.0), Inches(1.65), Inches(3.4), Inches(5.2))
    tf3_l = tb_s3_l.text_frame
    tf3_l.word_wrap = True

    p = tf3_l.paragraphs[0]
    p.text = "MODELS, STATE ENUMS & CONSTRAINTS"
    p.font.size = Pt(11)
    p.font.bold = True
    p.font.color.rgb = HEADER_ACCENT

    p = tf3_l.add_paragraph()
    p.text = "• Listing State Transitions:\n  AVAILABLE -> VIEWING_REQUESTED -> TOKEN_LOCKED -> UNAVAILABLE\n  (A listing never jumps from UNAVAILABLE to AVAILABLE without explicit relist by owner)."
    p.font.size = Pt(8.5)
    p.font.color.rgb = TEXT_LIGHT

    p = tf3_l.add_paragraph()
    p.text = "• Viewing Request Status Machine:\n  REQUESTED -> APPROVED -> TOKEN_REQUESTED -> TOKEN_CONFIRMED\n  Alternative paths: DECLINED, ABORTED, REOPENED.\n  *Invariant: DECLINED requests cannot be approved without being reopened with a non-empty reason."
    p.font.size = Pt(8.5)
    p.font.color.rgb = TEXT_LIGHT

    p = tf3_l.add_paragraph()
    p.text = "• Outbox Synchronization States:\n  PENDING_SYNC -> SUBMITTED\n  Failures: SYNC_FAILED_RETRYABLE, CONFLICT_STALE_DATA"
    p.font.size = Pt(8.5)
    p.font.color.rgb = SKY_BLUE

    p = tf3_l.add_paragraph()
    p.text = "• SQLite Partial Unique Index:\n  CREATE UNIQUE INDEX one_active_request_per_listing\n  ON requests(listing_id)\n  WHERE status IN ('REQUESTED', 'APPROVED', 'REOPENED', 'TOKEN_REQUESTED', 'TOKEN_CONFIRMED');\n  *Guarantees zero double-booking at DB engine level.*"
    p.font.size = Pt(8.2)
    p.font.bold = True
    p.font.color.rgb = AMBER_ORANGE

    # Right Column: The 10-Step Execution Sequence (Left 4.8, Top 1.5, Width 7.733, Height 5.5)
    add_card(s3, Inches(4.8), Inches(1.5), Inches(7.733), Inches(5.5))
    tb_s3_r = s3.shapes.add_textbox(Inches(5.0), Inches(1.65), Inches(7.333), Inches(5.2))
    tf3_r = tb_s3_r.text_frame
    tf3_r.word_wrap = True

    p = tf3_r.paragraphs[0]
    p.text = "THE 10-STEP VIEWING REQUEST & RECOVERY WORKFLOW"
    p.font.size = Pt(11)
    p.font.bold = True
    p.font.color.rgb = HEADER_ACCENT

    ten_steps = [
        ("1. Renter Selects Listing", "Renter selects available listing (e.g. L01) and opens GH03 Request Viewing Sheet.", SKY_BLUE),
        ("2. Form Input & Submit", "Renter selects preferred window ('Tomorrow Evening'), enters optional note, taps 'Request Viewing'.", SKY_BLUE),
        ("3. Pure Domain Validation", "ProptechBusinessRules.validateNewViewingRequest() runs BR-1, BR-1b, BR-2, BR-3 checks.", HEADER_ACCENT),
        ("4. Single Active Request Check", "Repository verifies zero active requests exist in SQLite for this listing.", HEADER_ACCENT),
        ("5. Idempotency Key Creation", "UUID requestId and idempotencyKey generated ONCE on initial creation.", AMBER_ORANGE),
        ("6. Atomic SQLite Commit", "In 1 transaction: Listing -> VIEWING_REQUESTED; Request inserted (REQUESTED, PENDING_SYNC); Audit event logged.", AMBER_ORANGE),
        ("7. Remote Outbox Dispatch", "Repository calls remoteService.submitViewingRequest(newRequest, clientListingVersion).", TEXT_LIGHT),
        ("8. Success Path -> SUBMITTED", "Remote confirms; request syncState updates to SUBMITTED; audit event recorded; UI updates via stream.", EMERALD_GREEN),
        ("9. Network Drop Path -> RETRYABLE", "If remote throws NetworkException: request updates to SYNC_FAILED_RETRYABLE. Listing stays locked. Recovery Banner shown.", CRIMSON_RED),
        ("10. Safe Idempotent Retry", "User taps 'Retry' in GH04. retrySync() resends with IDENTICAL idempotency key. Zero duplicate holds.", EMERALD_GREEN)
    ]
    for i, (st, desc, col) in enumerate(ten_steps):
        p = tf3_r.add_paragraph()
        p.text = f"{st}: {desc}"
        p.font.size = Pt(8.2)
        p.font.color.rgb = col

    # Speaker Notes Slide 3
    s3.notes_slide.notes_text_frame.text = (
        "Let's dive into the core technical engine: the Viewing Request and Outbox Synchronization workflow.\n\n"
        "Look at the sequence on this slide. Most naive mobile apps make an HTTP POST request first, wait for a spinner, and if the network drops on the Mumbai metro, the user double-taps and creates duplicate bookings.\n\n"
        "GharHold reverses this. When the renter taps 'Request Viewing', we first run our pure domain rules. Then, we execute an atomic SQLite transaction via Drift. "
        "In that single transaction, we update the listing to VIEWING_REQUESTED, insert the request record with a unique UUID idempotency key, and write a structured audit event. "
        "Even if the network drops instantly, the request is permanently stored on the device.\n\n"
        "Notice our dual safety net: we don't just rely on application logic. In our SQLite schema, we enforce a database partial unique index on requests(listing_id) for active statuses. "
        "This guarantees at the database storage engine level that two active requests can never co-exist for the same property.\n\n"
        "When synchronization fails, we move the request to SYNC_FAILED_RETRYABLE. The user is shown a clear recovery banner, and when they tap Retry, we reuse the exact same idempotency key—guaranteeing zero duplicate rows on the server."
    )

    # =========================================================================
    # SLIDE 4: ARCHITECTURAL DECISION RECORDS (ADRS)
    # =========================================================================
    s4 = prs.slides.add_slide(blank_layout)
    set_slide_background(s4)
    add_header(s4, 4, "Architectural Decision Records (ADRs) & Trade-offs", 
               "Rigorous trade-off analysis across all 8 core architectural decision dimensions")

    # Table layout for ADRs (Top 1.5, Left 0.8, Width 11.733, Height 5.5)
    # We will create 8 structured compact cards in a 4x2 grid
    adr_data = [
        ("1. Local-First & Outbox", "Implemented (ADR-001)",
         "Context: Flaky transit network causes dropped requests & duplicate holds.\n"
         "Decision: SQLite via Drift as single source of truth; local commit before remote sync.\n"
         "Alternatives: Direct HTTP REST, in-memory cache, CouchDB.\n"
         "Consequence: Instant UI, offline resilience. Trade-off: Outbox management.\n"
         "Revisit: Transition to real multi-master cloud backend.",
         HEADER_ACCENT),

        ("2. Pure Domain State Machine", "Implemented (ADR-002)",
         "Context: Inventory coordination requires strict transition invariants.\n"
         "Decision: Pure Dart domain layer with zero framework/DB imports.\n"
         "Alternatives: Business logic in Flutter State or SQL triggers.\n"
         "Consequence: 100% testable in milliseconds; zero framework coupling.\n"
         "Revisit: Server-driven dynamic rule engine requirements.",
         SKY_BLUE),

        ("3. Single Active Request Invariant", "Implemented (BR-1b)",
         "Context: Double-booking and ghost availability destroy trust in Mumbai.\n"
         "Decision: Max 1 active request per listing via DB partial unique index.\n"
         "Alternatives: Open multi-renter waitlists, first-to-pay auctions.\n"
         "Consequence: Eliminates ghost holds. Trade-off: Other renters wait.\n"
         "Revisit: Support for open-house viewing queues or batch slots.",
         EMERALD_GREEN),

        ("4. Remote Boundary & Faults", "Implemented / Simulated",
         "Context: Offline recovery & conflicts must be evaluated on 1 device.\n"
         "Decision: RemoteService port with SimulatedRemoteService (dropNetwork, staleConflict).\n"
         "Alternatives: Mockito mocks, cloud backend, airplane mode.\n"
         "Consequence: Deterministic, reproducible evaluation without cloud lag.\n"
         "Revisit: Deployment to production staging/cloud infrastructure.",
         AMBER_ORANGE),

        ("5. Structured Observability", "Implemented",
         "Context: Need internal state audit trail + external app health monitoring.\n"
         "Decision: Dual pipeline: DiagnosticSink (SQLite) + Measure.sh (NDK/spans).\n"
         "Alternatives: Console logs only, Firebase Analytics alone.\n"
         "Consequence: Durable in-app evidence + zero-PII mobile crash telemetry.\n"
         "Revisit: Centralized enterprise regulatory logging requirements.",
         SKY_BLUE),

        ("6. Privacy & Scope Boundaries", "Implemented",
         "Context: Tenant safety, location security, and hackathon credential hygiene.\n"
         "Decision: Approximate areas only; zero secrets in repo; MsrMask on inputs.\n"
         "Alternatives: Google Maps GPS, exact flat numbers, payment gateway.\n"
         "Consequence: Zero stalking risk; cloud-independent clean repository.\n"
         "Revisit: Production KYC verification & title deed escrow.",
         HEADER_ACCENT),

        ("7. Repository Pattern & Streams", "Implemented",
         "Context: Flutter widgets coupling directly to SQLite or network calls.\n"
         "Decision: ProptechRepository exposes reactive Drift streams (watchListings).\n"
         "Alternatives: Direct DB queries in UI, InheritedWidget callbacks.\n"
         "Consequence: UI has zero SQL knowledge; updates are auto-pushed.\n"
         "Revisit: Cross-platform native rewrite (Swift/Kotlin).",
         EMERALD_GREEN),

        ("8. AI Assistance & Fallback", "Planned / Architectural",
         "Context: Move-in cost complexity needs plain explanations without hallucinated fees.\n"
         "Decision: Domain computes numbers deterministically; LLM only flags/explains.\n"
         "Alternatives: LLM calculates lease numbers directly, static FAQ.\n"
         "Consequence: Guaranteed arithmetic truth; safe fallback on timeout.\n"
         "Revisit: Integration of production Gemini API gateway.",
         AMBER_ORANGE),
    ]

    for i, (title, status, content, col) in enumerate(adr_data):
        row = i // 4
        col_idx = i % 4
        bx = Inches(0.8 + col_idx * 2.98)
        by = Inches(1.5 + row * 2.75)
        add_card(s4, bx, by, Inches(2.85), Inches(2.65), border_color=col)
        tb_adr = s4.shapes.add_textbox(bx + Inches(0.08), by + Inches(0.08), Inches(2.69), Inches(2.5))
        atf = tb_adr.text_frame
        atf.word_wrap = True
        atf.margin_left = atf.margin_top = atf.margin_right = atf.margin_bottom = 0
        p = atf.paragraphs[0]
        p.text = title
        p.font.size = Pt(9.5)
        p.font.bold = True
        p.font.color.rgb = col
        p = atf.add_paragraph()
        p.text = f"Status: {status}"
        p.font.size = Pt(8)
        p.font.bold = True
        p.font.color.rgb = TEXT_LIGHT
        p = atf.add_paragraph()
        p.text = content
        p.font.size = Pt(7.5)
        p.font.color.rgb = TEXT_MUTED

    # Speaker Notes Slide 4
    s4.notes_slide.notes_text_frame.text = (
        "On Slide 4, we present our Architectural Decision Records. Good architecture is defined by the quality of its trade-offs. Here we document all eight core decisions.\n\n"
        "Let's highlight three critical choices:\n"
        "First, Decision 1: Local-First Outbox. Rather than treating mobile as a thin client to a cloud server, Drift/SQLite is our single source of truth. The UI updates in zero milliseconds because it reads from local streams.\n"
        "Second, Decision 3: Single Active Request. We chose a strict partial unique index on the database table. Even if a bug were introduced in the Flutter UI, SQLite itself physically rejects any attempt to insert a second active request on an occupied listing.\n"
        "Third, look at Decision 8: AI Assistance. Notice how we approach AI responsibly: our architecture mandates that pure Dart domain logic deterministically calculates every rupee of rent, deposit, and stamp duty. If an LLM is introduced to provide plain-language explanations, it is strictly isolated to an explanatory advisory role. If the model times out or hallucinates, the system falls back instantly to deterministic math. This is how proptech software should be built."
    )

    # =========================================================================
    # SLIDE 5: CORE, FAILURE & CHANGE WALKTHROUGHS
    # =========================================================================
    s5 = prs.slides.add_slide(blank_layout)
    set_slide_background(s5)
    add_header(s5, 5, "Core, Failure, and Change Walkthroughs", 
               "System resilience under failure and architectural adaptability under evolving requirements")

    # Left Column: Failure Matrix & Recovery (Left 0.8, Top 1.5, Width 6.8, Height 5.5)
    add_card(s5, Inches(0.8), Inches(1.5), Inches(6.8), Inches(5.5))
    tb_s5_l = s5.shapes.add_textbox(Inches(1.0), Inches(1.65), Inches(6.4), Inches(5.2))
    tf5_l = tb_s5_l.text_frame
    tf5_l.word_wrap = True

    p = tf5_l.paragraphs[0]
    p.text = "FAILURE MODES, DETECTION & DETERMINISTIC RECOVERY"
    p.font.size = Pt(11)
    p.font.bold = True
    p.font.color.rgb = HEADER_ACCENT

    failures = [
        ("Network Drop During Transit",
         "• Detection: SimulatedRemoteService throws NetworkException.\n• UI: GH04 shows 'Saved on this device — sync pending' + Recovery Banner.\n• Evidence: SYNC_FAILURE (ERR_NETWORK_DROP) in SQLite audit_events.\n• Recovery: User taps 'Retry'; request resubmitted with IDENTICAL idempotencyKey.",
         CRIMSON_RED),
        ("Duplicate Submission Attempts",
         "• Detection: SQLite UNIQUE constraint on idempotency_key.\n• UI: UI suppresses repeated clicks; existing request state retained.\n• Recovery: Exactly-once delivery guaranteed; zero duplicate requests.",
         AMBER_ORANGE),
        ("Stale-Version Conflict (Concurrent Update)",
         "• Detection: Remote service compares clientListingVersion with serverVersion.\n• UI: Request marked 'Aborted — Listing Unavailable'; listing updates to UNAVAILABLE.\n• Evidence: CONFLICT event logged with v1 -> v2 and ERR_STALE_VERSION.\n• Recovery: Transaction updates local listing to v2 and aborts stale request.",
         SKY_BLUE),
        ("Interrupted App Crash / Restart During Sync",
         "• Detection: runStartupRecovery() scans for orphaned PENDING_SYNC rows on startup.\n• UI: Converts stuck requests to SYNC_FAILED_RETRYABLE with safe Retry CTA.\n• Evidence: RESUME_SCAN event logged with recovered request ID.\n• Recovery: Clean startup recovery without silent data loss.",
         EMERALD_GREEN)
    ]
    for stitle, sbody, scol in failures:
        p = tf5_l.add_paragraph()
        p.text = stitle
        p.font.size = Pt(9.5)
        p.font.bold = True
        p.font.color.rgb = scol
        p = tf5_l.add_paragraph()
        p.text = sbody
        p.font.size = Pt(8.2)
        p.font.color.rgb = TEXT_LIGHT

    # Right Column: Change Walkthrough (Left 7.8, Top 1.5, Width 4.733, Height 5.5)
    add_card(s5, Inches(7.8), Inches(1.5), Inches(4.733), Inches(5.5))
    tb_s5_r = s5.shapes.add_textbox(Inches(8.0), Inches(1.65), Inches(4.333), Inches(5.2))
    tf5_r = tb_s5_r.text_frame
    tf5_r.word_wrap = True

    p = tf5_r.paragraphs[0]
    p.text = "CHANGE WALKTHROUGH: EVOLVING REQUIREMENTS"
    p.font.size = Pt(11)
    p.font.bold = True
    p.font.color.rgb = HEADER_ACCENT

    p = tf5_r.add_paragraph()
    p.text = "Hypothetical Requirement: Support multiple active viewing requests per listing (Queue / Batch Viewings up to N)."
    p.font.size = Pt(9)
    p.font.bold = True
    p.font.color.rgb = SKY_BLUE

    p = tf5_r.add_paragraph()
    p.text = "How Our Clean Boundaries Absorb the Change:"
    p.font.size = Pt(9.5)
    p.font.bold = True
    p.font.color.rgb = TEXT_LIGHT

    impacts = [
        ("1. Pure Domain Rules (lib/domain/)", 
         "Update validateNewViewingRequest() check from hasActiveRequest to activeCount < maxAllowed (N). Zero framework impact.", 
         HEADER_ACCENT),
        ("2. Drift SQLite Schema (lib/data/)", 
         "Drop partial unique index via migration; add queue_position integer column to requests table.", 
         AMBER_ORANGE),
        ("3. Repository Logic (lib/data/)", 
         "Assign incrementing queuePosition inside the existing atomic transaction.", 
         SKY_BLUE),
        ("4. UI Layer (lib/ui/)", 
         "GH01-GH03 require ZERO logic rewrites. GH04 renders 'Queue Position: 2 of 3'. GH05 renders ordered candidate queue.", 
         EMERALD_GREEN),
        ("5. Observability & Tests", 
         "Audit sinks record queue transitions automatically; update unit tests for N-threshold.", 
         TEXT_LIGHT)
    ]
    for comp, desc, col in impacts:
        p = tf5_r.add_paragraph()
        p.text = f"• {comp}:\n  {desc}"
        p.font.size = Pt(8.2)
        p.font.color.rgb = col

    p = tf5_r.add_paragraph()
    p.text = "Architectural Benefit: 0% of UI widget code rewritten—only domain rules and DB constraints evolve."
    p.font.size = Pt(8.5)
    p.font.bold = True
    p.font.color.rgb = HEADER_ACCENT

    # Speaker Notes Slide 5
    s5.notes_slide.notes_text_frame.text = (
        "Finally, Slide 5 proves the operational resilience and evolvability of GharHold.\n\n"
        "In Section B, look at how we handle every failure mode. Take network failure: when a packet drops in a basement or train station, our outbox catches it, marks the request SYNC_FAILED_RETRYABLE, and displays a clear recovery banner. "
        "The request is safe in local SQLite. On retry, the exact original idempotency key is reused, preventing duplicates.\n\n"
        "Even more impressive is startup recovery: if the OS kills the app while a request is pending sync, our repository runs a startup recovery scan on launch. "
        "It locates the orphaned record, marks it retryable, logs a RESUME_SCAN audit event, and alerts the user. A transaction is never silently dropped.\n\n"
        "In Section C, we address the ultimate test of software architecture: how easily does it adapt to change? "
        "If business stakeholders ask us tomorrow to support multiple active viewing requests instead of one, look at our change-impact map. "
        "Because our domain rules are strictly separated from UI and database storage, we only modify a single rule method and a database constraint. "
        "The UI widgets and reactive streams require zero rewrites. That is the power of verifiable Clean Architecture."
    )

    # Save presentation
    output_path = os.path.join(os.getcwd(), "GHARHOLD_ARCHITECTURE_PRESENTATION.pptx")
    prs.save(output_path)
    print(f"Successfully generated {output_path}")

if __name__ == "__main__":
    create_deck()
