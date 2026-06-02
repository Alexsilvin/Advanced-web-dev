const supabase = require('../config/supabase');

const seedCourses = [
  {
    title: 'Python for Data Analysis',
    description:
      'Master Python programming for data analysis and visualization. Learn pandas, NumPy, Matplotlib, and Seaborn to analyze real-world datasets and extract meaningful insights. This comprehensive course covers everything from Python basics to advanced data manipulation techniques.',
    category: 'Data Science',
    color: '#f5d5d5',
    rating: 4.8,
    totalStudents: 9530,
    duration: '8 weeks',
    level: 'Intermediate',
    isFree: false,
    price: 0,
    tags: ['python', 'data analysis', 'pandas', 'numpy', 'matplotlib'],
    lessons: [
      { title: 'Introduction to Python', duration: '45 min', videoUrl: '' },
      { title: 'Data Structures in Python', duration: '60 min', videoUrl: '' },
      { title: 'NumPy Fundamentals', duration: '55 min', videoUrl: '' },
      { title: 'Pandas for Data Manipulation', duration: '70 min', videoUrl: '' },
      { title: 'Data Visualization with Matplotlib', duration: '65 min', videoUrl: '' },
      { title: 'Advanced Pandas Operations', duration: '80 min', videoUrl: '' },
      { title: 'Statistical Analysis', duration: '75 min', videoUrl: '' },
      { title: 'Real-world Project', duration: '90 min', videoUrl: '' },
    ],
  },
  {
    title: 'Digital Marketing Fundamentals',
    description:
      'Learn the core principles of digital marketing including SEO, social media marketing, email marketing, and paid advertising. Understand how to build effective digital marketing strategies that drive traffic, generate leads, and grow businesses in the online space.',
    category: 'Digital Marketing',
    color: '#fde8c0',
    rating: 4.9,
    totalStudents: 1463,
    duration: '6 weeks',
    level: 'Beginner',
    isFree: true,
    price: 0,
    tags: ['digital marketing', 'SEO', 'social media', 'email marketing'],
    lessons: [
      { title: 'Introduction to Digital Marketing', duration: '40 min', videoUrl: '' },
      { title: 'Search Engine Optimization (SEO)', duration: '60 min', videoUrl: '' },
      { title: 'Social Media Marketing', duration: '55 min', videoUrl: '' },
      { title: 'Content Marketing Strategy', duration: '50 min', videoUrl: '' },
      { title: 'Email Marketing Campaigns', duration: '45 min', videoUrl: '' },
      { title: 'Paid Advertising (PPC)', duration: '65 min', videoUrl: '' },
    ],
  },
  {
    title: 'Web Development Bootcamp',
    description:
      'A comprehensive full-stack web development course covering HTML, CSS, JavaScript, React, Node.js, and MongoDB. Build real projects from scratch and gain the skills needed to become a professional web developer. Includes deployment strategies and modern development practices.',
    category: 'IT & Software',
    color: '#e8dff5',
    rating: 4.7,
    totalStudents: 6726,
    duration: '12 weeks',
    level: 'Beginner',
    isFree: false,
    price: 0,
    tags: ['web development', 'HTML', 'CSS', 'JavaScript', 'React', 'Node.js'],
    lessons: [
      { title: 'HTML5 Fundamentals', duration: '50 min', videoUrl: '' },
      { title: 'CSS3 and Flexbox', duration: '65 min', videoUrl: '' },
      { title: 'JavaScript Essentials', duration: '80 min', videoUrl: '' },
      { title: 'React.js Basics', duration: '70 min', videoUrl: '' },
      { title: 'Node.js and Express', duration: '75 min', videoUrl: '' },
      { title: 'MongoDB and Mongoose', duration: '60 min', videoUrl: '' },
      { title: 'Building RESTful APIs', duration: '85 min', videoUrl: '' },
      { title: 'Deployment with Netlify & Render', duration: '45 min', videoUrl: '' },
    ],
  },
  {
    title: 'Financial Literacy for Entrepreneurs',
    description:
      'Build a strong financial foundation for your business. Learn how to read financial statements, manage cash flow, understand taxation, and make smart investment decisions. This course is designed for entrepreneurs who want to take control of their business finances.',
    category: 'Entrepreneurship',
    color: '#fdd5c0',
    rating: 5.0,
    totalStudents: 8735,
    duration: '5 weeks',
    level: 'Beginner',
    isFree: true,
    price: 0,
    tags: ['finance', 'entrepreneurship', 'business', 'accounting', 'investment'],
    lessons: [
      { title: 'Financial Statements Overview', duration: '55 min', videoUrl: '' },
      { title: 'Cash Flow Management', duration: '60 min', videoUrl: '' },
      { title: 'Business Taxation Basics', duration: '50 min', videoUrl: '' },
      { title: 'Investment Strategies', duration: '65 min', videoUrl: '' },
      { title: 'Financial Planning for Growth', duration: '70 min', videoUrl: '' },
    ],
  },
  {
    title: 'Digital Citizenship & Online Safety',
    description:
      'Learn how to navigate the digital world safely and responsibly. Topics include cybersecurity basics, protecting personal information online, understanding digital rights, combating misinformation, and developing healthy digital habits for personal and professional life.',
    category: 'Digital Citizenship',
    color: '#d5f5e8',
    rating: 4.6,
    totalStudents: 3210,
    duration: '4 weeks',
    level: 'Beginner',
    isFree: true,
    price: 0,
    tags: ['digital citizenship', 'cybersecurity', 'online safety', 'privacy'],
    lessons: [
      { title: 'Introduction to Digital Citizenship', duration: '35 min', videoUrl: '' },
      { title: 'Cybersecurity Fundamentals', duration: '60 min', videoUrl: '' },
      { title: 'Protecting Your Privacy Online', duration: '50 min', videoUrl: '' },
      { title: 'Digital Rights and Responsibilities', duration: '45 min', videoUrl: '' },
      { title: 'Combating Misinformation', duration: '55 min', videoUrl: '' },
      { title: 'Healthy Digital Habits', duration: '40 min', videoUrl: '' },
    ],
  },
  {
    title: 'UI/UX Design Fundamentals',
    description:
      'Discover the principles of user interface and user experience design. Learn design thinking, wireframing, prototyping, and usability testing. Master tools like Figma to create stunning, user-centered designs. Build a portfolio of real design projects by the end of the course.',
    category: 'Media Training',
    color: '#f5e8d5',
    rating: 4.9,
    totalStudents: 5430,
    duration: '7 weeks',
    level: 'Beginner',
    isFree: false,
    price: 0,
    tags: ['UI design', 'UX design', 'Figma', 'wireframing', 'prototyping'],
    lessons: [
      { title: 'Design Thinking Process', duration: '45 min', videoUrl: '' },
      { title: 'User Research Methods', duration: '60 min', videoUrl: '' },
      { title: 'Wireframing with Figma', duration: '70 min', videoUrl: '' },
      { title: 'Visual Design Principles', duration: '65 min', videoUrl: '' },
      { title: 'Prototyping and Interactions', duration: '75 min', videoUrl: '' },
      { title: 'Usability Testing', duration: '55 min', videoUrl: '' },
      { title: 'Building Your Design Portfolio', duration: '80 min', videoUrl: '' },
    ],
  },
  {
    title: 'Cloud Computing Basics',
    description:
      'Get started with cloud computing and learn the fundamentals of AWS, Azure, and Google Cloud. Understand cloud architecture, services, deployment models, and best practices. This course prepares you for cloud certifications and real-world cloud engineering roles.',
    category: 'IT & Software',
    color: '#d5e8f5',
    rating: 4.7,
    totalStudents: 4120,
    duration: '6 weeks',
    level: 'Beginner',
    isFree: false,
    price: 0,
    tags: ['cloud computing', 'AWS', 'Azure', 'Google Cloud', 'DevOps'],
    lessons: [
      { title: 'Introduction to Cloud Computing', duration: '40 min', videoUrl: '' },
      { title: 'AWS Core Services', duration: '75 min', videoUrl: '' },
      { title: 'Azure Fundamentals', duration: '70 min', videoUrl: '' },
      { title: 'Google Cloud Platform', duration: '65 min', videoUrl: '' },
      { title: 'Cloud Security Best Practices', duration: '60 min', videoUrl: '' },
      { title: 'Deploying Applications to Cloud', duration: '80 min', videoUrl: '' },
    ],
  },
  {
    title: 'Entrepreneurship 101',
    description:
      'Turn your ideas into successful businesses. Learn how to validate business ideas, create business plans, build minimum viable products, find customers, and scale your startup. This course covers the complete entrepreneurial journey from ideation to launch and beyond.',
    category: 'Entrepreneurship',
    color: '#f5d5f0',
    rating: 4.8,
    totalStudents: 7650,
    duration: '8 weeks',
    level: 'Beginner',
    isFree: true,
    price: 0,
    tags: ['entrepreneurship', 'startup', 'business plan', 'MVP', 'fundraising'],
    lessons: [
      { title: 'The Entrepreneurial Mindset', duration: '45 min', videoUrl: '' },
      { title: 'Idea Validation Techniques', duration: '60 min', videoUrl: '' },
      { title: 'Creating a Business Plan', duration: '75 min', videoUrl: '' },
      { title: 'Building an MVP', duration: '70 min', videoUrl: '' },
      { title: 'Customer Acquisition Strategies', duration: '65 min', videoUrl: '' },
      { title: 'Funding Your Startup', duration: '55 min', videoUrl: '' },
      { title: 'Scaling Your Business', duration: '80 min', videoUrl: '' },
      { title: 'Legal and Operational Basics', duration: '50 min', videoUrl: '' },
    ],
  },
];

const seedDatabase = async () => {
  try {
    const { count, error: countErr } = await supabase
      .from('courses')
      .select('id', { count: 'exact', head: true });
    if (countErr) throw countErr;

    if (count > 0) {
      console.log(`Database already has ${count} courses. Skipping seed.`);
      return { seeded: false, count };
    }

    const rows = seedCourses.map((c) => ({
      title: c.title,
      description: c.description,
      category: c.category,
      color: c.color,
      rating: c.rating,
      total_students: c.totalStudents,
      duration: c.duration,
      level: c.level,
      price: c.price,
      is_free: c.isFree,
      tags: c.tags,
      lessons: c.lessons,
      thumbnail: '',
      instructor_id: null,
    }));

    const { data, error } = await supabase.from('courses').insert(rows).select('id');
    if (error) throw error;

    console.log(`Successfully seeded ${data.length} courses`);
    return { seeded: true, count: data.length };
  } catch (error) {
    console.error('Seed error:', error);
    throw error;
  }
};

module.exports = { seedDatabase, seedCourses };
