import React from 'react';
import { motion } from 'framer-motion';
import { useNavigate } from 'react-router-dom';
import { Star, Users, Clock, BarChart2 } from 'lucide-react';

const CourseCard = ({ course }) => {
  const navigate = useNavigate();

  const formatStudents = (count) => {
    if (!count) return '0';
    if (count >= 1000) return `${(count / 1000).toFixed(1)}k`;
    return count.toString();
  };

  const levelColors = {
    Beginner: 'text-green-600 bg-green-100',
    Intermediate: 'text-yellow-600 bg-yellow-100',
    Advanced: 'text-red-600 bg-red-100',
  };

  const avatarColors = ['#f5d5d5', '#fde8c0', '#e8dff5', '#fdd5c0', '#d5f5e8'];

  return (
    <motion.div
      whileHover={{ scale: 1.03, y: -4 }}
      whileTap={{ scale: 0.98 }}
      transition={{ type: 'spring', stiffness: 300, damping: 20 }}
      onClick={() => navigate(`/courses/${course._id}`)}
      className="cursor-pointer rounded-2xl overflow-hidden shadow-sm hover:shadow-lg transition-shadow duration-300"
      style={{ backgroundColor: course.color || '#f5d5d5' }}
    >
      {/* Card Header */}
      <div className="p-5 pb-3">
        <div className="flex items-start justify-between mb-4">
          <span className="text-xs font-semibold bg-white bg-opacity-70 text-dark px-3 py-1 rounded-full">
            {course.category}
          </span>
          <div className="flex items-center gap-1 bg-white bg-opacity-70 px-2 py-1 rounded-full">
            <Star size={12} className="text-yellow-500 fill-yellow-500" />
            <span className="text-xs font-bold text-dark">{course.rating?.toFixed(1) || '0.0'}</span>
          </div>
        </div>

        {/* Title */}
        <h3 className="font-bold text-dark text-base leading-snug line-clamp-2 mb-3 min-h-[2.8rem]">
          {course.title}
        </h3>

        {/* Level Badge */}
        <div className="mb-3">
          <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${levelColors[course.level] || levelColors.Beginner}`}>
            {course.level || 'Beginner'}
          </span>
        </div>
      </div>

      {/* Card Footer */}
      <div className="px-5 pb-4 flex items-center justify-between">
        <div className="flex items-center gap-1 text-gray-600">
          <Users size={13} />
          <span className="text-xs font-medium">{formatStudents(course.totalStudents)}</span>
        </div>

        <div className="flex items-center gap-1 text-gray-600">
          <Clock size={13} />
          <span className="text-xs font-medium">{course.duration || '4 weeks'}</span>
        </div>

        {/* Instructor avatars */}
        <div className="flex -space-x-2">
          {[0, 1].map((i) => (
            <div
              key={i}
              className="w-6 h-6 rounded-full border-2 border-white flex items-center justify-center text-xs font-bold text-dark"
              style={{ backgroundColor: avatarColors[i % avatarColors.length] }}
            >
              {course.instructor?.name?.[0] || 'I'}
            </div>
          ))}
        </div>
      </div>
    </motion.div>
  );
};

export default CourseCard;
