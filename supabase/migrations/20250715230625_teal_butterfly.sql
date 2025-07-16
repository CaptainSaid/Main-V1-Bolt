/*
  # Create signups table with proper permissions

  1. New Tables
    - `signups`
      - `id` (uuid, primary key, auto-generated)
      - `name` (text, required)
      - `email` (text, required)
      - `phone` (text, required)
      - `location` (text, required)
      - `created_at` (timestamp with timezone, auto-generated)

  2. Security
    - Enable RLS on `signups` table
    - Add policy for anonymous users to insert signups
    - Add policy for service role to read all signups

  3. Important Notes
    - This will drop and recreate the table if it exists
    - All existing data will be lost
    - Run this only if you're sure you want to reset the table
*/

-- Drop the table if it exists (be careful - this will delete all data!)
DROP TABLE IF EXISTS public.signups;

-- Create the signups table
CREATE TABLE public.signups (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  location text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE public.signups ENABLE ROW LEVEL SECURITY;

-- Create policy to allow anonymous users to insert signups
CREATE POLICY "Allow anonymous signups" ON public.signups
  FOR INSERT TO anon
  WITH CHECK (true);

-- Create policy to allow service role to read all signups
CREATE POLICY "Service role can read signups" ON public.signups
  FOR SELECT TO service_role
  USING (true);

-- Grant necessary permissions
GRANT INSERT ON public.signups TO anon;
GRANT ALL ON public.signups TO service_role;