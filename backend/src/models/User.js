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
