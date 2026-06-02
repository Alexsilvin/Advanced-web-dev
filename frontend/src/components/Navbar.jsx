import React, { useState } from 'react';
import { Search, Bell, X } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const Navbar = ({ onSearch }) => {
  const [searchValue, setSearchValue] = useState('');
  const { user } = useAuth();
  const navigate = useNavigate();

  const getInitials = (name) => {
    if (!name) return 'U';
    return name.split(' ').map((n) => n[0]).join('').toUpperCase().slice(0, 2);
  };

  const handleSearch = (e) => {
    e.preventDefault();
    if (onSearch) onSearch(searchValue);
  };

  const handleClear = () => {
    setSearchValue('');
    if (onSearch) onSearch('');
  };

  return (
    <div className="flex items-center gap-4 mb-6">
      <form onSubmit={handleSearch} className="flex-1 relative max-w-md">
        <Search size={16} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" />
        <input
          type="text"
          value={searchValue}
          onChange={(e) => setSearchValue(e.target.value)}
          placeholder="Search courses, topics..."
          className="w-full pl-10 pr-10 py-2.5 bg-white rounded-xl border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-dark focus:ring-opacity-10 focus:border-dark transition-all"
        />
        {searchValue && (
          <button
            type="button"
            onClick={handleClear}
            className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-dark"
          >
            <X size={14} />
          </button>
        )}
      </form>

      <button className="w-9 h-9 rounded-xl bg-white shadow-sm flex items-center justify-center text-gray-500 hover:text-dark transition-colors relative">
        <Bell size={16} />
        <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-red-400 rounded-full" />
      </button>

      <button
        onClick={() => navigate('/profile')}
        className="w-9 h-9 rounded-full flex items-center justify-center text-sm font-bold text-white flex-shrink-0"
        style={{ background: 'linear-gradient(135deg, #a78bfa, #f472b6)' }}
      >
        {user?.avatar ? (
          <img src={user.avatar} alt={user.name} className="w-full h-full rounded-full object-cover" />
        ) : (
          getInitials(user?.name)
        )}
      </button>
    </div>
  );
};

export default Navbar;
