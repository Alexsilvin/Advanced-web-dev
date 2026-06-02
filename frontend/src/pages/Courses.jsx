import React, { useState, useEffect, useCallback } from 'react';
import { motion } from 'framer-motion';
import { Search, X, ChevronLeft, ChevronRight, SlidersHorizontal } from 'lucide-react';
import Sidebar from '../components/Sidebar';
import CourseCard from '../components/CourseCard';
import api from '../services/api';

const CATEGORIES = [
  'All',
  'IT & Software',
  'Media Training',
  'Business',
  'Data Science',
  'Digital Marketing',
  'Entrepreneurship',
  'Digital Citizenship',
];

const CourseCardSkeleton = () => (
  <div className="rounded-2xl overflow-hidden bg-gray-100 animate-pulse">
    <div className="p-5">
      <div className="flex justify-between mb-4">
        <div className="h-6 w-24 bg-gray-200 rounded-full" />
        <div className="h-6 w-12 bg-gray-200 rounded-full" />
      </div>
      <div className="h-5 w-full bg-gray-200 rounded mb-2" />
      <div className="h-5 w-3/4 bg-gray-200 rounded mb-4" />
    </div>
    <div className="px-5 pb-4 flex justify-between">
      <div className="h-4 w-16 bg-gray-200 rounded" />
      <div className="h-4 w-16 bg-gray-200 rounded" />
    </div>
  </div>
);

const Courses = () => {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchInput, setSearchInput] = useState('');
  const [searchQuery, setSearchQuery] = useState('');
  const [activeCategory, setActiveCategory] = useState('All');
  const [page, setPage] = useState(1);
  const [pagination, setPagination] = useState({ total: 0, pages: 1 });
  const [showFilters, setShowFilters] = useState(false);
  const limit = 9;

  const fetchCourses = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams({ page, limit });
      if (activeCategory !== 'All') params.append('category', activeCategory);
      if (searchQuery) params.append('search', searchQuery);

      const res = await api.get(`/courses?${params}`);
      setCourses(res.data.courses || []);
      setPagination(res.data.pagination || { total: 0, pages: 1 });
    } catch (err) {
      console.error('Error fetching courses:', err);
    } finally {
      setLoading(false);
    }
  }, [activeCategory, searchQuery, page]);

  useEffect(() => {
    fetchCourses();
  }, [fetchCourses]);

  const handleSearch = (e) => {
    e.preventDefault();
    setSearchQuery(searchInput);
    setPage(1);
  };

  const handleCategoryChange = (cat) => {
    setActiveCategory(cat);
    setPage(1);
  };

  const clearSearch = () => {
    setSearchInput('');
    setSearchQuery('');
    setPage(1);
  };

  return (
    <div className="flex h-screen overflow-hidden bg-edubg">
      <Sidebar />

      <main className="flex-1 overflow-y-auto px-6 py-6">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-6"
        >
          <h1 className="text-2xl font-black text-dark mb-1">Explore Courses</h1>
          <p className="text-sm text-gray-500">
            {pagination.total} courses available across all categories
          </p>
        </motion.div>

        {/* Search + Filter Bar */}
        <div className="flex items-center gap-3 mb-6">
          <form onSubmit={handleSearch} className="flex-1 relative">
            <Search size={16} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              value={searchInput}
              onChange={(e) => setSearchInput(e.target.value)}
              placeholder="Search courses, topics, or keywords..."
              className="input-field pl-11 pr-10"
            />
            {searchInput && (
              <button
                type="button"
                onClick={clearSearch}
                className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 hover:text-dark"
              >
                <X size={14} />
              </button>
            )}
          </form>
          <button
            onClick={() => setShowFilters(!showFilters)}
            className={`flex items-center gap-2 px-4 py-2.5 rounded-xl text-sm font-medium transition-colors
              ${showFilters ? 'bg-dark text-white' : 'bg-white text-gray-600 hover:bg-gray-50'}`}
          >
            <SlidersHorizontal size={15} />
            Filters
          </button>
        </div>

        <div className="flex gap-6">
          {/* Category Sidebar */}
          <motion.aside
            animate={{ width: showFilters ? 200 : 0, opacity: showFilters ? 1 : 0 }}
            transition={{ duration: 0.2 }}
            className="flex-shrink-0 overflow-hidden"
          >
            <div className="bg-white rounded-2xl p-4 shadow-sm" style={{ width: 200 }}>
              <h3 className="font-semibold text-dark text-sm mb-3">Categories</h3>
              <div className="space-y-1">
                {CATEGORIES.map((cat) => (
                  <button
                    key={cat}
                    onClick={() => handleCategoryChange(cat)}
                    className={`w-full text-left px-3 py-2 rounded-lg text-sm transition-colors
                      ${activeCategory === cat
                        ? 'bg-dark text-white font-medium'
                        : 'text-gray-600 hover:bg-gray-100'
                      }`}
                  >
                    {cat}
                  </button>
                ))}
              </div>
            </div>
          </motion.aside>

          {/* Courses Grid */}
          <div className="flex-1">
            {/* Active category indicator */}
            {(activeCategory !== 'All' || searchQuery) && (
              <div className="flex items-center gap-2 mb-4 flex-wrap">
                {activeCategory !== 'All' && (
                  <span className="flex items-center gap-1 bg-dark text-white text-xs px-3 py-1 rounded-full">
                    {activeCategory}
                    <button onClick={() => handleCategoryChange('All')}>
                      <X size={10} className="ml-1" />
                    </button>
                  </span>
                )}
                {searchQuery && (
                  <span className="flex items-center gap-1 bg-dark text-white text-xs px-3 py-1 rounded-full">
                    "{searchQuery}"
                    <button onClick={clearSearch}>
                      <X size={10} className="ml-1" />
                    </button>
                  </span>
                )}
              </div>
            )}

            <div className="grid grid-cols-3 gap-4">
              {loading
                ? Array.from({ length: 6 }).map((_, i) => <CourseCardSkeleton key={i} />)
                : courses.length > 0
                ? courses.map((course, index) => (
                    <motion.div
                      key={course._id}
                      initial={{ opacity: 0, y: 16 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: index * 0.05 }}
                    >
                      <CourseCard course={course} />
                    </motion.div>
                  ))
                : (
                  <div className="col-span-3 text-center py-16">
                    <div className="text-5xl mb-4">📚</div>
                    <p className="text-lg font-semibold text-dark mb-2">No courses found</p>
                    <p className="text-sm text-gray-500">
                      Try adjusting your search or filter criteria
                    </p>
                    <button
                      onClick={() => { clearSearch(); handleCategoryChange('All'); }}
                      className="mt-4 btn-primary"
                    >
                      Clear filters
                    </button>
                  </div>
                )
              }
            </div>

            {/* Pagination */}
            {pagination.pages > 1 && (
              <div className="flex items-center justify-center gap-3 mt-8">
                <button
                  onClick={() => setPage((p) => Math.max(1, p - 1))}
                  disabled={page === 1}
                  className="w-9 h-9 rounded-xl bg-white shadow-sm flex items-center justify-center
                    text-gray-500 hover:text-dark disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
                >
                  <ChevronLeft size={16} />
                </button>

                {Array.from({ length: pagination.pages }, (_, i) => i + 1).map((p) => (
                  <button
                    key={p}
                    onClick={() => setPage(p)}
                    className={`w-9 h-9 rounded-xl text-sm font-medium transition-colors
                      ${page === p
                        ? 'bg-dark text-white shadow-sm'
                        : 'bg-white text-gray-500 hover:text-dark shadow-sm'
                      }`}
                  >
                    {p}
                  </button>
                ))}

                <button
                  onClick={() => setPage((p) => Math.min(pagination.pages, p + 1))}
                  disabled={page === pagination.pages}
                  className="w-9 h-9 rounded-xl bg-white shadow-sm flex items-center justify-center
                    text-gray-500 hover:text-dark disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
                >
                  <ChevronRight size={16} />
                </button>
              </div>
            )}
          </div>
        </div>
      </main>
    </div>
  );
};

export default Courses;
