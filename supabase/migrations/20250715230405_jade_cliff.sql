/*
  # Fix signups table and RLS policies

  1. Tables
    - Ensure `signups` table exists with correct structure
    - `id` (uuid, primary key, auto-generated)
    - `name` (text, required)
    - `email` (text, required)
    - `phone` (text, required)
    - `location` (text, required)
    - `created_at` (timestamp, auto-generated)

  2. Security
    - Enable RLS on `signups` table
    - Add policy for anonymous users to insert signups
    - Add policy for service role to read signups

  3. Notes
    - Uses IF NOT EXISTS to prevent errors
    - Drops and recreates policies to ensure they're correct
*/

-- Create the signups table if it doesn't exist
CREATE TABLE IF NOT EXISTS signups (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  location text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE signups ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Anyone can insert signups" ON signups;
DROP POLICY IF EXISTS "Service role can read all signups" ON signups;

-- Create policy for anonymous users to insert
CREATE POLICY "Anyone can insert signups"
  ON signups
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Create policy for service role to read
CREATE POLICY "Service role can read all signups"
  ON signups
  FOR SELECT
  TO service_role
  USING (true);

-- Grant necessary permissions
GRANT INSERT ON signups TO anon;
GRANT SELECT ON signups TO service_role;