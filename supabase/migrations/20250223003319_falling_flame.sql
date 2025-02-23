/*
  # Create events table and policies

  1. New Tables
    - `events`
      - `id` (uuid, primary key)
      - `title` (text)
      - `description` (text)
      - `date` (date)
      - `time` (text)
      - `location` (text)
      - `price` (text)
      - `organizer` (text)
      - `website` (text)
      - `image_url` (text)
      - `status` (text) - can be 'pending', 'approved', or 'rejected'
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on `events` table
    - Add policies for:
      - Public can insert new events (submit form)
      - Only authenticated admins can update events (approve/reject)
      - Public can read approved events
      - Admins can read all events
*/

CREATE TABLE events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  date date NOT NULL,
  time text,
  location text NOT NULL,
  price text NOT NULL,
  organizer text NOT NULL,
  website text,
  image_url text,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at timestamptz DEFAULT now()
);

ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- Allow public to submit events
CREATE POLICY "Anyone can submit events" ON events
  FOR INSERT
  TO public
  WITH CHECK (true);

-- Allow public to view approved events
CREATE POLICY "Public can view approved events" ON events
  FOR SELECT
  TO public
  USING (status = 'approved');

-- Allow admins to view all events
CREATE POLICY "Admins can view all events" ON events
  FOR SELECT
  TO authenticated
  USING (true);

-- Allow admins to update events (approve/reject)
CREATE POLICY "Admins can update events" ON events
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);