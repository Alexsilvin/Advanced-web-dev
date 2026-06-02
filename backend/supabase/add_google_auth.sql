-- ============================================================
--  EduSkills — Add Google OAuth support
-- ============================================================
--  Run this in the Supabase SQL Editor AFTER schema.sql
--
--  Changes:
--    • Makes password_hash nullable  (OAuth users have no password)
--    • Adds provider column          ('email' | 'google')
--    • Adds google_id column         (Supabase user UUID for dedup)
-- ============================================================

-- Allow OAuth users who have no password hash
ALTER TABLE users
  ALTER COLUMN password_hash DROP NOT NULL;

-- Track which provider created the account
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS provider VARCHAR(20) NOT NULL DEFAULT 'email';

-- Store the Supabase auth user ID so we can look up returning OAuth users
-- without relying solely on email (emails can change on Google accounts)
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS google_id TEXT UNIQUE;

-- Index for fast OAuth look-up by google_id
CREATE INDEX IF NOT EXISTS idx_users_google_id ON users(google_id);

-- Add a CHECK so only known providers are stored
ALTER TABLE users
  ADD CONSTRAINT chk_provider CHECK (provider IN ('email', 'google'));
