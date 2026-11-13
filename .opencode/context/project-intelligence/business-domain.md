<!-- Context: project-intelligence/business | Priority: high | Version: 1.0 | Updated: 2026-10-20 -->

# Business Domain

**Purpose**: Carnival block management for Brazilian street festivals (Blocos de Rua).
**Audience**: Developers, AI agents, stakeholders needing project context.

## Project Identity

```
Project Name: Bloco na Rua
Tagline: "Gestão de blocos de rua para carnaval brasileiro"
Problem: Disorganized carnival blocks with manual attendance tracking
Solution: Mobile app for block management, meeting scheduling, and presence control
```

## Core Entities

| Entity | Purpose | Key Fields |
|--------|---------|------------|
| Member | App user | id, name, email, phone, profileImage, uuid |
| CarnivalBlock | Block group | id, name, ownerId, inviteCode, managersInviteCode, image |
| CarnivalBlockMember | Membership | id, blockId, memberId, role |
| Meeting | Event | id, name, description, location, meetingDateTime, blockId |
| MeetingPresence | Attendance | id, meetingId, memberId, isPresent |

## User Journey

```
Register/Login → Create/Join Block → Manage Members → Schedule Meetings → Track Attendance
```

| Step | Action | Technical |
|------|--------|----------|
| 1 | Auth via Supabase | Email/password auth with JWT |
| 2 | Create block | CarnivalBlocksEntity + invite codes |
| 3 | Join block | CarnivalBlockMembersEntity via invite code |
| 4 | Schedule meeting | MeetingsEntity with dateTime/location |
| 5 | Mark presence | MeetingPresencesEntity.isPresent |

## Target Users

| Segment | Profile | Needs |
|---------|---------|-------|
| Block Owner | Organizer | Create blocks, manage meetings, view attendance |
| Block Manager | Helper | Edit meetings, view members |
| Member | Participant | View meetings, mark attendance |

## Key Flows

### Create Block
```
1. User taps "+" FAB → CreateBlockScreen
2. Enter name, optional image
3. Backend generates inviteCode + managersInviteCode
4. User shares code with friends
```

### Join Block
```
1. User taps "Join Block" → JoinBlockModal
2. Enter invite code
3. Backend creates CarnivalBlockMembersEntity
4. User sees block in their list
```

### Meeting Attendance
```
1. User opens MeetingDetailsScreen
2. Sees member list with presence toggles
3. Toggle saves MeetingPresenceEntity.isPresent
4. Updates in real-time via API
```

## Value Proposition

**For Users**:
- Organize carnival blocks without spreadsheets/WhatsApp
- Track attendance automatically
- Share blocks via invite codes

**For Business**:
- Scalable presence management
- Reusable for any carnival event

## 📂 Codebase References

| Entity | Path |
|--------|------|
| Members | `lib/domain/entities/members/members_entity.dart` |
| CarnivalBlocks | `lib/domain/entities/carnivalBlock/carnival_blocks_entity.dart` |
| Meetings | `lib/domain/entities/meetings/meetings_entity.dart` |
| MeetingPresences | `lib/domain/entities/meetingPresences/meeting_presences_entity.dart` |
| CarnivalBlockMembers | `lib/domain/entities/carnivalBlockMembers/carnival_block_members_entity.dart` |

## Related Files

- `technical-domain.md` - Technical stack and patterns
- `business-tech-bridge.md` - Feature-to-implementation mapping
- `decisions-log.md` - Business decisions with context
