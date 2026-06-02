import { createClient } from '@supabase/supabase-js';

const supabaseUrl  = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnon = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnon) {
  console.warn(
    '[EduSkills] VITE_SUPABASE_URL or VITE_SUPABASE_ANON_KEY is missing. ' +
    'Google OAuth will not work until these are set in frontend/.env'
  );
}

// This client uses the PUBLIC anon key — safe to expose in the browser.
// It is used ONLY for the OAuth redirect flow.
// All data access uses the backend API (which holds the service-role key).
const supabase = createClient(supabaseUrl ?? '', supabaseAnon ?? '');

export default supabase;
