-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users Table
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  display_name VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Games Table
CREATE TABLE games (
  game_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  week_number INTEGER NOT NULL CHECK (week_number >= 1 AND week_number <= 18),
  away_team_id VARCHAR(10) NOT NULL,
  home_team_id VARCHAR(10) NOT NULL,
  away_team_name VARCHAR(50) NOT NULL,
  home_team_name VARCHAR(50) NOT NULL,
  scheduled_time TIMESTAMP NOT NULL,
  winner_id VARCHAR(10),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Picks Table
CREATE TABLE picks (
  pick_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  game_id UUID NOT NULL REFERENCES games(game_id) ON DELETE CASCADE,
  week_number INTEGER NOT NULL CHECK (week_number >= 1 AND week_number <= 18),
  selected_team_id VARCHAR(10) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_correct BOOLEAN,
  UNIQUE(user_id, game_id)
);

-- Create indexes for performance
CREATE INDEX idx_games_week ON games(week_number);
CREATE INDEX idx_games_scheduled_time ON games(scheduled_time);
CREATE INDEX idx_picks_user_id ON picks(user_id);
CREATE INDEX idx_picks_game_id ON picks(game_id);
CREATE INDEX idx_picks_week ON picks(week_number);

-- View for Weekly Standings
CREATE VIEW weekly_standings AS
SELECT 
  u.user_id,
  u.display_name,
  p.week_number,
  SUM(CASE WHEN p.is_correct = TRUE THEN 1 ELSE 0 END) AS wins,
  SUM(CASE WHEN p.is_correct = FALSE THEN 1 ELSE 0 END) AS losses,
  ROUND(
    SUM(CASE WHEN p.is_correct = TRUE THEN 1 ELSE 0 END)::DECIMAL / 
    NULLIF(COUNT(p.pick_id), 0) * 100, 
    2
  ) AS win_percentage
FROM users u
LEFT JOIN picks p ON u.user_id = p.user_id
GROUP BY u.user_id, u.display_name, p.week_number
ORDER BY p.week_number, wins DESC, win_percentage DESC;

-- View for Season Standings
CREATE VIEW season_standings AS
SELECT 
  u.user_id,
  u.display_name,
  SUM(CASE WHEN p.is_correct = TRUE THEN 1 ELSE 0 END) AS total_wins,
  SUM(CASE WHEN p.is_correct = FALSE THEN 1 ELSE 0 END) AS total_losses,
  ROUND(
    SUM(CASE WHEN p.is_correct = TRUE THEN 1 ELSE 0 END)::DECIMAL / 
    NULLIF(COUNT(p.pick_id), 0) * 100, 
    2
  ) AS win_percentage,
  ROW_NUMBER() OVER (ORDER BY 
    SUM(CASE WHEN p.is_correct = TRUE THEN 1 ELSE 0 END) DESC,
    ROUND(
      SUM(CASE WHEN p.is_correct = TRUE THEN 1 ELSE 0 END)::DECIMAL / 
      NULLIF(COUNT(p.pick_id), 0) * 100, 
      2
    ) DESC
  ) AS rank
FROM users u
LEFT JOIN picks p ON u.user_id = p.user_id
GROUP BY u.user_id, u.display_name
ORDER BY rank;
