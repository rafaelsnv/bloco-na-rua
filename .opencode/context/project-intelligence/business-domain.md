<!-- Context: project-intelligence/business-domain | Priority: high | Version: 3.0 | Updated: 2026-07-02 -->

# Business Domain — BlocoNaRua

**Core Concept**: A mobile app that helps Brazilian carnival block organizers and members coordinate logistics: create blocks, invite members via code, schedule meetings, track RSVPs. Primary language: pt-BR.

---

## Problem

Brazilian carnival blocks ("blocos de rua") need to coordinate dozens to thousands of members across multiple pre-carnival meetings ("ensaios"). Today, organizers rely on WhatsApp groups + spreadsheets — these break down:

- ❌ Member lists get out of sync
- ❌ Meeting RSVPs are invisible to non-attendees
- ❌ Invite codes are shared insecurely
- ❌ No audit trail for who manages which block
- ❌ No central place to see "all my blocks"

---

## Users & Jobs-To-Be-Done

### Persona 1: Block Leader ("Líder do Bloco")
- **Goal**: Run a carnival block efficiently
- **Jobs**:
  - Create a block with a name and image
  - Generate invite codes (member + manager)
  - Schedule meetings ("ensaios") with date/time/location
  - Add/remove members
  - See who RSVP'd to each meeting

### Persona 2: Block Member ("Folião")
- **Goal**: Stay informed about block activities
- **Jobs**:
  - Join a block via invite code
  - See upcoming meetings
  - RSVP (yes/no) to meetings
  - View block details (image, leader, etc.)

### Out of scope (v1)
- Public block discovery (search nearby blocks)
- In-app chat / DMs
- Payments / financial tracking
- Push notifications (planned for v2)

---

## Value Proposition

| Before (today)               | After (BlocoNaRua)                              |
| ---------------------------- | ---------------------------------------------- |
| Manual invite via WhatsApp   | One-time invite code, shareable once            |
| Scattered RSVPs               | Per-meeting presence list, real-time           |
| Lost in group chat             | Dashboard: "My blocks" + "Upcoming meetings"  |
| No member hierarchy           | Member + Manager roles (separate invite codes)  |

---

## Key Business Concepts

| Concept              | Definition                                                       |
| -------------------- | ---------------------------------------------------------------- |
| **Carnival Block**   | A "bloco de rua" — themed street parade group for carnival        |
| **Member**           | A person who joined at least one block                            |
| **Manager**          | A member with elevated permissions (separate invite code)         |
| **Meeting (Ensaio)** | Pre-carnival gathering with date/time/location                    |
| **Presence**         | Member's RSVP for a meeting (yes/no)                              |
| **Invite Code**      | Alphanumeric code to join a block (one for member, one for manager) |

---

## Success Metrics (proposed, not yet tracked)

- DAU / MAU ratio (target ≥ 30%)
- Meetings created per block per week
- RSVPs submitted per meeting (target ≥ 60% of members)
- Invite-code conversion rate

---

## Constraints

- **No payment processing** — out of scope v1
- **No social graph** — only block membership, not friends
- **Single backend per region** — no multi-tenant logic in app

---

## Reference

- `business-tech-bridge.md` — how business concepts map to entities + use cases
- `lookup/entities.md` — entity catalog
- `lookup/use-cases.md` — current orchestration layer
- `concepts/device-types.md` — pt-BR target
