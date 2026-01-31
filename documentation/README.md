# SurePicks - NFL Pick 'Em Application

## Project Overview

**SurePicks** is a private NFL Pick 'Em web application designed to make weekly NFL game predictions simple, organized, and competitive. The application features a global "Thursday Lock" mechanism that disables all pick modifications every Thursday at 5:00 PM PST, creating a clear "Final Answer" moment for all players in the group.

## Key Features

- **18-Week NFL Season Tracking**: Supports the full NFL regular season schedule
- **Global Thursday Lockout**: All picks automatically lock at 5:00 PM PST every Thursday, preventing late submissions
- **Standings Dashboard**: 
  - Weekly View: Individual user records for selected weeks
  - Season View: Cumulative leaderboard with total wins, losses, and win percentages
- **User Authentication**: Secure login system for group members
- **Real-Time Countdown**: Display countdown timer showing time until Thursday 5:00 PM PST lockout
- **Pick Management**: Intuitive interface for selecting game winners

## Tech Stack

- **Frontend**: Next.js with Tailwind CSS
- **Backend**: Supabase
- **Database**: PostgreSQL (via Supabase)
- **Authentication**: Supabase Auth
- **Hosting**: Vercel

## User Flow

1. User logs in to the application
2. Views current week's NFL matchups
3. Selects winners for each game
4. Sees countdown timer to Thursday 5:00 PM PST lockout
5. Views Standings (weekly and season leaderboards)
6. Returns next week to repeat the process

## Project Structure

```
SurePicks/
├── documentation/
│   ├── README.md (this file)
│   └── PRD.md (Product Requirements Document)
├── frontend/
├── backend/
├── database/
└── .gitignore
```

## Getting Started

See [PRD.md](./PRD.md) for detailed product requirements, technical specifications, and development milestones.

## Questions or Feedback?

This is a private group application. For issues or feature requests, contact the development team.
