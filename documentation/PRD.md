# Product Requirements Document (PRD) - SurePicks

## 1. Executive Summary:

SurePicks is a private NFL Pick 'Em web application with one defining feature: a hard "Thursday Lock" that disables all pick modifications every Thursday at 5:00 PM PST. This global lockout eliminates the need to check individual game kickoff times and creates a clear "Final Answer" moment for all players each week. The application manages an 18-week NFL regular season with a central Standings page serving as the hub for weekly win/loss tracking and cumulative season leaderboards.

---

## 2. Product Vision

**Vision Statement**: Simplify NFL pick selection and competition by providing a unified, fair, and transparent platform where groups can confidently compete throughout the entire NFL regular season.

**Problem Solved**: 
- Eliminates confusion about individual game deadlines
- Prevents late submissions and fairness disputes
- Provides a clear, central location for standings and results

---

## 3. Core Features

### 3.1 Global Thursday Lockout Timer
- **Specification**: Every Thursday at 5:00 PM PST, the entire application becomes read-only for pick submission
- **Behavior**:
  - Users can view current week's games and their existing picks
  - Submit button is disabled after lockout
  - Countdown timer shows time remaining until lockout
  - Lockout applies to ALL users simultaneously (no exceptions)
- **Technical Implementation**: 
  - Server-side validation to enforce lockout
  - Client-side countdown timer for UX
  - Weekly reset at Saturday morning (or configurable time after games conclude)

### 3.2 18-Week NFL Season Structure
- Track all 18 weeks of the NFL regular season
- Each week contains the full slate of games for that week
- Week numbers align with official NFL schedule
- Season tracking from Week 1 through Week 18

### 3.3 Standings Dashboard
Central leaderboard page displaying player rankings and statistics

#### 3.3.1 Weekly View
- Display selected week's standings
- Show each user's record: Wins, Losses, Win Percentage
- Sort options: By wins (descending), alphabetically
- Highlight current logged-in user

#### 3.3.2 Season View
- Cumulative standings across all 18 weeks
- Display for each player:
  - Total Wins (across all weeks)
  - Total Losses (across all weeks)
  - Win Percentage (Wins / Total Picks)
  - Weekly breakdown (optional)
- Primary leaderboard view

### 3.4 User Authentication & Login
- Secure login system for group members
- User profiles with display name
- Session management
- Password reset functionality

### 3.5 Current Week Matchups View
- Display all NFL games for the current week
- Show game details:
  - Away team vs. Home team
  - Game time (optional)
  - Spread/odds (optional)
- User can select a winner for each game
- Visual indication of locked/unlocked status

---

## 4. Technical Specifications

### 4.1 Technology Stack

- **Frontend Framework**: Next.js with TypeScript
- **Styling**: Tailwind CSS
- **Backend/Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Hosting**: Vercel

### 4.2 Database Schema

The database schema is implemented in PostgreSQL (via Supabase) with the following tables:

#### Users Table
```
- user_id (UUID, Primary Key)
- email (String, Unique)
- display_name (String)
- password_hash (String)
- created_at (Timestamp)
- updated_at (Timestamp)
```

#### Games Table
```
- game_id (UUID, Primary Key)
- week_number (Integer, 1-18)
- away_team_id (String)
- home_team_id (String)
- away_team_name (String)
- home_team_name (String)
- scheduled_time (Timestamp)
- winner_id (String, nullable until game concludes)
- created_at (Timestamp)
- updated_at (Timestamp)
```

#### Picks Table
```
- pick_id (UUID, Primary Key)
- user_id (UUID, Foreign Key -> Users)
- game_id (UUID, Foreign Key -> Games)
- week_number (Integer, 1-18)
- selected_team_id (String)
- created_at (Timestamp)
- updated_at (Timestamp)
- is_correct (Boolean, nullable until game concludes)
```

#### Standings View (Query Result)
```
- user_id (UUID)
- display_name (String)
- week_number (Integer, optional for weekly view)
- wins (Integer)
- losses (Integer)
- win_percentage (Decimal)
- rank (Integer, calculated)
```

### 4.3 Lockout Logic

**Function: `canSubmitPicks()`**
```
Input: Current system time (UTC)
Output: Boolean (true = can submit, false = locked)

Algorithm:
1. Get current date/time in PST timezone
2. Calculate next Thursday at 5:00 PM PST
3. If current time >= Thursday 5:00 PM PST AND < Friday 12:00 AM PST:
   return false (locked)
4. Else:
   return true (unlocked)

Edge Cases:
- Handle daylight saving time transitions
- Handle year boundary (Week 18 games may cross into January)
- Server-side enforcement mandatory; client-side for UX only
```

### 4.3 Standings Query Logic

**Function: `getWeeklyStandings(weekNumber)`**
```
Input: week_number (Integer 1-18)
Output: Ordered list of standings for that week

Algorithm:
1. For each user:
   a. COUNT picks where week_number = input AND is_correct = true -> wins
   b. COUNT picks where week_number = input AND is_correct = false -> losses
   c. Calculate win_percentage = wins / (wins + losses)
2. Sort by wins DESC, then alphabetically by display_name
3. Add rank (1, 2, 3, etc.)
4. Return result set
```

**Function: `getSeasonStandings()`**
```
Input: None
Output: Ordered list of cumulative standings across all weeks

Algorithm:
1. For each user:
   a. SUM wins across all weeks
   b. SUM losses across all weeks
   c. Calculate win_percentage = total_wins / (total_wins + total_losses)
2. Sort by total_wins DESC, then alphabetically by display_name
3. Add rank (1, 2, 3, etc.)
4. Return result set
```

### 4.4 Tech Stack Details

**Frontend**:
- Framework: Next.js (latest stable version)
- Styling: Tailwind CSS
- State Management: React Context or Zustand
- HTTP Client: Fetch API or Axios
- Real-Time Updates: Supabase Realtime

**Backend**:
- Supabase (PostgreSQL + Auth)
- API: RESTful or GraphQL (via Supabase)
- Serverless Functions: Supabase Edge Functions

**Deployment**:
- Frontend: Vercel (native Next.js support)
- Backend: Supabase Cloud

---

## 5. Project Roadmap

### Milestone 1: Project Setup & Infrastructure (Week 1)
- [ ] Initialize Next.js project
- [ ] Set up Supabase project
- [ ] Configure Tailwind CSS
- [ ] Set up version control and CI/CD
- [ ] Design database schema and implement in PostgreSQL
- [ ] Create project documentation

**Deliverable**: Basic project structure with database ready

### Milestone 2: The "Picking" Engine (Week 2-3)
- [ ] Implement user authentication (login/signup)
- [ ] Create Games table and seed with 18-week NFL schedule
- [ ] Build Matchups View page (display current week's games)
- [ ] Implement pick submission logic
- [ ] Implement Thursday lockout logic (server-side validation)
- [ ] Add countdown timer component (client-side)
- [ ] Build pick editing interface

**Deliverable**: Users can log in and submit picks before Thursday 5:00 PM PST

### Milestone 3: The Standings Logic (Week 4)
- [ ] Implement game result updates (winner_id population)
- [ ] Build weekly Standings query
- [ ] Build season Standings query
- [ ] Create Standings dashboard page
- [ ] Implement weekly/season view toggle
- [ ] Add sorting and filtering options
- [ ] Display user rankings and statistics

**Deliverable**: Functional Standings page showing accurate win/loss records

### Milestone 4: Deployment & Polish (Week 5)
- [ ] Implement responsive design for mobile
- [ ] Add error handling and edge cases
- [ ] Perform testing (unit, integration, E2E)
- [ ] Set up monitoring and logging
- [ ] Deploy frontend to Vercel
- [ ] Deploy backend to Supabase
- [ ] Conduct UAT with sample group
- [ ] Create user documentation

**Deliverable**: Live, production-ready application

---

## 6. User Stories

### US-001: User Authentication
**As a** group member  
**I want to** securely log in with my email and password  
**So that** my picks are tracked and associated with my account

**Acceptance Criteria**:
- User can sign up with email and password
- User can log in with correct credentials
- User receives error on incorrect credentials
- Session persists across page refreshes
- User can log out

### US-002: View Current Week's Games
**As a** user  
**I want to** see all NFL games for the current week  
**So that** I can make my picks

**Acceptance Criteria**:
- Page displays all games for current week
- Each game shows away team vs. home team
- Games are clearly organized
- Current week number is displayed

### US-003: Submit Picks
**As a** user  
**I want to** select a winner for each game before Thursday 5:00 PM PST  
**So that** my picks are recorded and compete for the week

**Acceptance Criteria**:
- User can click to select a team for each game
- Submit button saves all picks
- User receives confirmation of submission
- Picks cannot be submitted after 5:00 PM PST Thursday
- Error message displays if submission attempted after lockout

### US-004: View Countdown Timer
**As a** user  
**I want to** see a countdown showing time until Thursday 5:00 PM PST  
**So that** I know when picks will lock

**Acceptance Criteria**:
- Countdown timer displays on Matchups page
- Timer updates in real-time
- Timer shows days, hours, minutes, seconds remaining
- Timer displays when lockout has occurred

### US-005: View Weekly Standings
**As a** user  
**I want to** see how everyone did in a specific week  
**So that** I can compare my performance week-by-week

**Acceptance Criteria**:
- Standings page displays all users
- Standings show wins, losses, win percentage for selected week
- Users are ranked by wins (descending)
- Current user is highlighted
- User can select different weeks to view

### US-006: View Season Standings
**As a** user  
**I want to** see the cumulative leaderboard for the entire season  
**So that** I know who is winning overall

**Acceptance Criteria**:
- Season view displays all users with cumulative stats
- Stats show total wins, total losses, and win percentage across all 18 weeks
- Users are ranked by total wins
- Leaderboard is updated after each game concludes

---

## 7. Non-Functional Requirements

| Requirement | Specification |
|-------------|---------------|
| **Performance** | Page load < 2 seconds; Standings calculation < 500ms |
| **Availability** | 99.5% uptime (excluding scheduled maintenance) |
| **Security** | HTTPS; Password hashing (bcrypt); Auth tokens (JWT) |
| **Scalability** | Support 100+ concurrent users without degradation |
| **Compatibility** | Chrome, Firefox, Safari, Edge (latest versions); Mobile responsive |
| **Data Retention** | Retain all season data for 2+ years |
| **Backup** | Automated daily backups; 30-day retention |

---

## 8. Success Metrics

- Users successfully log in and submit picks every week
- 100% of picks lock at Thursday 5:00 PM PST (zero late submissions)
- Standings accurately reflect game results within 1 hour of game conclusion
- Application maintains 99%+ uptime
- User satisfaction score ≥ 4.5/5.0

---

## 9. Future Enhancements (Post-MVP)

- [ ] Tie-breaker scoring system
- [ ] Weekly prizes/rewards tracking
- [ ] Historical season archives
- [ ] Mobile native apps (iOS/Android)
- [ ] Confidence point system
- [ ] Invite/create custom leagues
- [ ] Email notifications for reminders
- [ ] Analytics and statistics breakdown
- [ ] Integration with official NFL API for real-time scores

---

## 10. Assumptions & Constraints

**Assumptions**:
- Users have stable internet connection
- NFL schedule remains 18 weeks
- Thursday 5:00 PM PST is optimal cutoff for group
- Supabase account is available and funded

**Constraints**:
- MVP must be completed within 5 weeks
- Limited to private group (not public platform)
- No real-money betting or gambling compliance required
- Initial group size: ≤ 50 users

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | Jan 2026 | Dev Team | Initial PRD creation |

