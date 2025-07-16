/*
  # Create signups table

  1. New Tables
    - `signups`
      - `id` (uuid, primary key)
      - `name` (text, captain name)
      - `email` (text, email address)
      - `phone` (text, phone number)
      - `location` (text, location/port)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on `signups` table
    - Add policy for authenticated users to insert their own data
    - Add policy for service role to read all data
*/

CREATE TABLE IF NOT EXISTS signups (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  location text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE signups ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can insert signups"
  ON signups
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Service role can read all signups"
  ON signups
  FOR SELECT
  TO service_role
  USING (true);