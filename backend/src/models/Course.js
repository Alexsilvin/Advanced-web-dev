const supabase = require('../config/supabase');

const COURSE_COLS = `
  id, title, description, category, thumbnail, color, rating,
  total_students, instructor_id, duration, level, price, is_free,
  tags, lessons, created_at,
  instructor:users!courses_instructor_id_fkey(id, name, avatar, bio)
`.trim();

const normalize = (row) => {
  if (!row) return null;
  const { instructor_id, total_students, is_free, ...rest } = row;
  return {
    ...rest,
    _id: rest.id,
    totalStudents: total_students,
    isFree: is_free,
    instructorId: instructor_id,
  };
};

const Course = {
  async find({ category, search } = {}, { sort = 'rating', page = 1, limit = 12 } = {}) {
    let query = supabase.from('courses').select(COURSE_COLS);

    if (category && category !== 'All') query = query.eq('category', category);
    if (search) {
      query = query.or(
        `title.ilike.%${search}%,description.ilike.%${search}%`
      );
    }

    const from = (page - 1) * limit;
    const to = from + limit - 1;
    query = query.order('rating', { ascending: false }).range(from, to);

    const { data, error, count } = await query;
    if (error) throw error;
    return { courses: (data || []).map(normalize), total: count || 0 };
  },

  async findById(id) {
    const { data, error } = await supabase
      .from('courses')
      .select(COURSE_COLS)
      .eq('id', id)
      .maybeSingle();
    if (error) throw error;
    return normalize(data);
  },

  async findFeatured(limit = 4) {
    const { data, error } = await supabase
      .from('courses')
      .select(COURSE_COLS)
      .order('rating', { ascending: false })
      .limit(limit);
    if (error) throw error;
    return (data || []).map(normalize);
  },

  async count(filters = {}) {
    let query = supabase.from('courses').select('id', { count: 'exact', head: true });
    if (filters.category && filters.category !== 'All') query = query.eq('category', filters.category);
    const { count, error } = await query;
    if (error) throw error;
    return count || 0;
  },

  async create(courseData) {
    const insert = {
      title: courseData.title,
      description: courseData.description,
      category: courseData.category,
      thumbnail: courseData.thumbnail || '',
      color: courseData.color || '#f5d5d5',
      rating: courseData.rating || 0,
      total_students: courseData.totalStudents || 0,
      instructor_id: courseData.instructorId || null,
      duration: courseData.duration || '4 weeks',
      level: courseData.level || 'Beginner',
      price: courseData.price || 0,
      is_free: courseData.isFree !== undefined ? courseData.isFree : true,
      tags: courseData.tags || [],
      lessons: courseData.lessons || [],
    };
    const { data, error } = await supabase
      .from('courses')
      .insert([insert])
      .select(COURSE_COLS)
      .single();
    if (error) throw error;
    return normalize(data);
  },

  async findByIdAndUpdate(id, updates) {
    const mapped = {};
    if (updates.title !== undefined) mapped.title = updates.title;
    if (updates.description !== undefined) mapped.description = updates.description;
    if (updates.category !== undefined) mapped.category = updates.category;
    if (updates.color !== undefined) mapped.color = updates.color;
    if (updates.totalStudents !== undefined) mapped.total_students = updates.totalStudents;
    if (updates.rating !== undefined) mapped.rating = updates.rating;

    const { data, error } = await supabase
      .from('courses')
      .update(mapped)
      .eq('id', id)
      .select(COURSE_COLS)
      .single();
    if (error) throw error;
    return normalize(data);
  },

  async incrementStudents(id) {
    const { error } = await supabase.rpc('increment_course_students', { course_id: id });
    if (error) throw error;
  },
};

module.exports = Course;
