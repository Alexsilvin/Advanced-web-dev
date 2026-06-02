import React from 'react';
import { motion } from 'framer-motion';

const CategoryFilter = ({ categories, activeCategory, onSelect }) => {
  return (
    <div className="flex items-center gap-2 overflow-x-auto pb-1 scrollbar-hide">
      {categories.map((category) => {
        const isActive = activeCategory === category;
        return (
          <motion.button
            key={category}
            onClick={() => onSelect(category)}
            whileTap={{ scale: 0.95 }}
            className={`relative flex-shrink-0 px-4 py-2 rounded-full text-sm font-medium transition-colors duration-200
              ${isActive
                ? 'text-white'
                : 'bg-gray-100 text-gray-500 hover:bg-gray-200 hover:text-dark'
              }`}
          >
            {isActive && (
              <motion.div
                layoutId="activeCategory"
                className="absolute inset-0 bg-dark rounded-full"
                transition={{ type: 'spring', stiffness: 400, damping: 30 }}
                style={{ zIndex: 0 }}
              />
            )}
            <span className="relative z-10">{category}</span>
          </motion.button>
        );
      })}
    </div>
  );
};

export default CategoryFilter;
