import React from 'react';

const Skeleton = ({ 
  type = 'text', 
  lines = 1, 
  className = '',
  width = 'w-full',
  height = 'h-4'
}) => {
  const renderSkeleton = () => {
    switch (type) {
      case 'text':
        return (
          <div className={`animate-pulse ${className}`}>
            {Array.from({ length: lines }).map((_, index) => (
              <div
                key={index}
                className={`bg-gray-200 rounded ${width} ${height} mb-2 ${
                  index === lines - 1 ? 'w-3/4' : ''
                }`}
              />
            ))}
          </div>
        );
      
      case 'card':
        return (
          <div className={`animate-pulse bg-white rounded-lg shadow overflow-hidden ${className}`}>
            <div className="p-6">
              <div className="flex justify-between items-start mb-4">
                <div className="bg-gray-200 rounded h-6 w-3/4" />
                <div className="bg-gray-200 rounded-full h-6 w-16" />
              </div>
              <div className="space-y-2">
                <div className="bg-gray-200 rounded h-4 w-full" />
                <div className="bg-gray-200 rounded h-4 w-5/6" />
                <div className="bg-gray-200 rounded h-4 w-4/6" />
              </div>
              <div className="flex justify-between items-center mt-6">
                <div className="flex space-x-2">
                  <div className="bg-gray-200 rounded h-8 w-16" />
                  <div className="bg-gray-200 rounded h-8 w-16" />
                </div>
                <div className="bg-gray-200 rounded h-8 w-24" />
              </div>
            </div>
          </div>
        );
      
      case 'avatar':
        return (
          <div className={`animate-pulse ${className}`}>
            <div className={`bg-gray-200 rounded-full ${width} ${height}`} />
          </div>
        );
      
      case 'button':
        return (
          <div className={`animate-pulse ${className}`}>
            <div className={`bg-gray-200 rounded-md ${width} ${height}`} />
          </div>
        );
      
      case 'image':
        return (
          <div className={`animate-pulse ${className}`}>
            <div className={`bg-gray-200 rounded ${width} ${height}`} />
          </div>
        );
      
      default:
        return (
          <div className={`animate-pulse bg-gray-200 rounded ${width} ${height} ${className}`} />
        );
    }
  };

  return renderSkeleton();
};

export default Skeleton; 