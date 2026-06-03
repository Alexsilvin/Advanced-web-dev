const bcrypt = require('bcryptjs');
const supabase = require('../config/supabase');

const normalize = (row) => {
  if (!row) return null;
  const { password_hash, ...rest } = row;
  return { ...rest, _id: rest.id };
};

const User = {
  async findOne({ email }, includePassword = false) {
    const cols = includePassword
      ? 'id, name, email, password_hash, avatar, bio, role, created_at'
      : 'id, name, email, avatar, bio, role, created_at';
    const { data, error } = await supabase
      .from('users')
      .select(cols)
      .eq('email', email)
      .maybeSingle();
    if (error) throw error;
    if (!data) return null;
    const out = normalize(data);
    if (includePassword) out.password_hash = data.password_hash;
    return out;
  },

  async findById(id) {
    const { data, error } = await supabase
      .from('users')
      .select('id, name, email, avatar, bio, role, created_at')
      .eq('id', id)
      .maybeSingle();
    if (error) throw error;
    return normalize(data);
  },

  async create({ name, email, password }) {
    const salt = await bcrypt.genSalt(12);
    const password_hash = await bcrypt.hash(password, salt);
    const { data, error } = await supabase
      .from('users')
      .insert([{ name, email, password_hash, role: 'student', avatar: '', bio: '' }])
      .select('id, name, email, avatar, bio, role, created_at')
      .single();
    if (error) {
      if (error.code === '23505') {
        const err = new Error('Email already registered');
        err.code = 'DUPLICATE_EMAIL';
        throw err;
      }
      throw error;
    }
    return normalize(data);
  },

  async findByGoogleId(googleId) {
    // google_id column only exists after add_google_auth.sql migration is run.
    // Return null gracefully if the column is missing so the route falls back
    // to the email lookup — login still works either way.
    const { data, error } = await supabase
      .from('users')
      .select('id, name, email, avatar, bio, role, created_at')
      .eq('google_id', googleId)
      .maybeSingle();
    if (error) return null;   // column missing → treat as "not found"
    return normalize(data);
  },

  async createOAuth({ name, email, avatar, googleId }) {
    // Base insert — works with the original schema.json (no migration needed)
    const baseInsert = {
      name,
      email,
      password_hash: null,
      role: 'student',
      avatar: avatar || '',
      bio: '',
    };

    // Try with the extended columns first (requires add_google_auth.sql)
    const { data, error } = await supabase
      .from('users')
      .insert([{ ...baseInsert, provider: 'google', google_id: googleId }])
      .select('id, name, email, avatar, bio, role, created_at')
      .single();

    if (!error) return normalize(data);

    // If the extended columns don't exist yet, retry with just the base columns
    if (error.code === '42703' /* undefined_column */ || error.message?.includes('column')) {
      const { data: fallback, error: fallbackError } = await supabase
        .from('users')
        .insert([baseInsert])
        .select('id, name, email, avatar, bio, role, created_at')
        .single();
      if (fallbackError) throw fallbackError;
      return normalize(fallback);
    }

    throw error;
  },

  async findByIdAndUpdate(id, updates) {
    const { data, error } = await supabase
      .from('users')
      .update(updates)
      .eq('id', id)
      .select('id, name, email, avatar, bio, role, created_at')
      .single();
    if (error) throw error;
    return normalize(data);
  },

  comparePassword(plain, hash) {
    return bcrypt.compare(plain, hash);
  },
};

module.exports = User;
