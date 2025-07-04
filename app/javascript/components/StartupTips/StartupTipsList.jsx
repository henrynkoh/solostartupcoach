import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { PlusIcon } from '@heroicons/react/24/outline';
import StartupTipCard from './StartupTipCard';
import { useStartupTips } from '../../hooks/useStartupTips';
import Pagination from '../Common/Pagination';
import LoadingSpinner from '../Common/LoadingSpinner';
import ErrorMessage from '../Common/ErrorMessage';
import Skeleton from '../Common/Skeleton';

const StartupTipsList = () => {
  const [page, setPage] = useState(1);
  const { tips, loading, error, meta, refetch } = useStartupTips(page);

  if (loading) {
    return (
      <div>
        <div className="flex justify-between items-center mb-6">
          <Skeleton type="text" lines={1} width="w-48" height="h-8" />
          <Skeleton type="button" width="w-32" height="h-10" />
        </div>
        
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {Array.from({ length: 6 }).map((_, index) => (
            <Skeleton key={index} type="card" />
          ))}
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <ErrorMessage
        title="Error loading startup tips"
        message={error.message}
        onRetry={error.retry}
        className="mb-6"
      />
    );
  }

  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-bold text-gray-900">Startup Tips</h2>
        <Link
          to="/startup-tips/new"
          className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
        >
          <PlusIcon className="-ml-1 mr-2 h-5 w-5" aria-hidden="true" />
          New Tip
        </Link>
      </div>

      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {tips.map((tip) => (
          <StartupTipCard key={tip.id} tip={tip} />
        ))}
      </div>

      <div className="mt-6">
        <Pagination
          currentPage={page}
          totalPages={meta.total_pages}
          onPageChange={setPage}
        />
      </div>
    </div>
  );
};

export default StartupTipsList; 