const supabase = require('./supabase');

const connectDB = async () => {
  try {
    const { error } = await supabase.from('courses').select('id').limit(1);
    if (error && error.code !== 'PGRST116') throw error;
    console.log('Supabase connected successfully');
  } catch (error) {
    console.error(`Supabase connection error: ${error.message}`);
    process.exit(1);
  }
};

module.exports = connectDB;
