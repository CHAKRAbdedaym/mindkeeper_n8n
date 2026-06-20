CREATE TABLE IF NOT EXISTS entries (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT NOW(),
  category TEXT,
  content TEXT
);
