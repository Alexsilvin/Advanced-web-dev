-- ================================================================
-- EduSkills Portal — Supabase Schema
-- Run this once in the Supabase SQL Editor to set up your database.
-- ================================================================

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id            UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  email         VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  avatar        TEXT         DEFAULT '',
  bio           TEXT         DEFAULT '',
  role          VARCHAR(50)  DEFAULT 'student'
                  CHECK (role IN ('student', 'instructor', 'admin')),
  created_at    TIMESTAMPTZ  DEFAULT NOW()
);

-- Courses table
CREATE TABLE IF NOT EXISTS courses (
  id              UUID           DEFAULT gen_random_uuid() PRIMARY KEY,
  title           VARCHAR(200)   NOT NULL,
  description     TEXT           NOT NULL,
  category        VARCHAR(100)   NOT NULL,
  thumbnail       TEXT           DEFAULT '',
  color           VARCHAR(20)    DEFAULT '#f5d5d5',
  rating          NUMERIC(2, 1)  DEFAULT 0 CHECK (rating >= 0 AND rating <= 5),
  total_students  INTEGER        DEFAULT 0,
  instructor_id   UUID           REFERENCES users(id) ON DELETE SET NULL,
  duration        VARCHAR(100)   DEFAULT '4 weeks',
  level           VARCHAR(50)    DEFAULT 'Beginner'
                    CHECK (level IN ('Beginner', 'Intermediate', 'Advanced')),
  price           NUMERIC(10, 2) DEFAULT 0,
  is_free         BOOLEAN        DEFAULT TRUE,
  tags            TEXT[]         DEFAULT '{}',
  lessons         JSONB          DEFAULT '[]',
  created_at      TIMESTAMPTZ    DEFAULT NOW()
);

-- Enrollments table
CREATE TABLE IF NOT EXISTS enrollments (
  id                  UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id             UUID        NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id           UUID        NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  progress            INTEGER     DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
  completed_lessons   JSONB       DEFAULT '[]',
  enrolled_at         TIMESTAMPTZ DEFAULT NOW(),
  last_accessed       TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, course_id)
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_courses_category  ON courses(category);
CREATE INDEX IF NOT EXISTS idx_courses_rating    ON courses(rating DESC);
CREATE INDEX IF NOT EXISTS idx_enroll_user_id    ON enrollments(user_id);
CREATE INDEX IF NOT EXISTS idx_enroll_course_id  ON enrollments(course_id);

-- Helper function used by the enrollment route to increment student count atomically
CREATE OR REPLACE FUNCTION increment_course_students(course_id UUID)
RETURNS VOID AS $$
  UPDATE courses SET total_students = total_students + 1 WHERE id = course_id;
$$ LANGUAGE SQL;

-- Disable Row Level Security so the service-role key can read/write freely.
-- If you later want to add per-user access policies, re-enable RLS and add policies.
ALTER TABLE users       DISABLE ROW LEVEL SECURITY;
ALTER TABLE courses     DISABLE ROW LEVEL SECURITY;
ALTER TABLE enrollments DISABLE ROW LEVEL SECURITY;
