import { createClient } from '@supabase/supabase-js';

const supabaseUrl  = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnon = import.meta.env.VITE_SUPABASE_ANON_KEY;

// createClient throws if either value is an empty string, which would crash
// the entire app at module-load time when the env vars are not yet configured.
// Guard with a no-op stub so email/password auth still works without them.
const supabase = supabaseUrl && supabaseAnon
  ? createClient(supabaseUrl, supabaseAnon, {
      auth: {
        flowType: 'implicit',   // avoids PKCE server-side code exchange timeout
        detectSessionInUrl: true,
        persistSession: true,
      },
    })
  : {
      auth: {
        signInWithOAuth: async () => {
          console.warn('[EduSkills] Google OAuth is not configured. Add VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY to your Netlify environment variables.');
          return { error: new Error('Supabase env vars not configured') };
        },
        getSession: async () => ({ data: { session: null }, error: null }),
      },
    };

export default supabase;
