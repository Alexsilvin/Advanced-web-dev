const supabase = require('../config/supabase');

const ENROLLMENT_COLS = `
  id, user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed,
  course:courses(
    id, title, description, color, category, thumbnail, rating,
    instructor_id, duration, level, lessons, total_students
  )
`.trim();

const normalize = (row) => {
  if (!row) return null;
  const { user_id, course_id, completed_lessons, enrolled_at, last_accessed, ...rest } = row;
  return {
    ...rest,
    _id: rest.id,
    userId: user_id,
    courseId: course_id,
    completedLessons: completed_lessons || [],
    enrolledAt: enrolled_at,
    lastAccessed: last_accessed,
  };
};

const Enrollment = {
  async findOne({ userId, courseId }) {
    const { data, error } = await supabase
      .from('enrollments')
      .select('id, user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed')
      .eq('user_id', userId)
      .eq('course_id', courseId)
      .maybeSingle();
    if (error) throw error;
    return normalize(data);
  },

  async findByUser(userId) {
    const { data, error } = await supabase
      .from('enrollments')
      .select(ENROLLMENT_COLS)
      .eq('user_id', userId)
      .order('last_accessed', { ascending: false });
    if (error) throw error;
    return (data || []).map(normalize);
  },

  async countByUser(userId) {
    const { count, error } = await supabase
      .from('enrollments')
      .select('id', { count: 'exact', head: true })
      .eq('user_id', userId);
    if (error) throw error;
    return count || 0;
  },

  async create({ userId, courseId }) {
    const { data, error } = await supabase
      .from('enrollments')
      .insert([{ user_id: userId, course_id: courseId, progress: 0, completed_lessons: [] }])
      .select(ENROLLMENT_COLS)
      .single();
    if (error) {
      if (error.code === '23505') {
        const err = new Error('Already enrolled in this course');
        err.code = 'DUPLICATE_ENROLLMENT';
        throw err;
      }
      throw error;
    }
    return normalize(data);
  },

  async updateProgress(userId, courseId, { progress, completedLessons, lastAccessed }) {
    const updates = { last_accessed: lastAccessed || new Date().toISOString() };
    if (progress !== undefined) updates.progress = progress;
    if (completedLessons !== undefined) updates.completed_lessons = completedLessons;

    const { data, error } = await supabase
      .from('enrollments')
      .update(updates)
      .eq('user_id', userId)
      .eq('course_id', courseId)
      .select(ENROLLMENT_COLS)
      .single();
    if (error) throw error;
    return normalize(data);
  },
};

module.exports = Enrollment;
