import React from 'react';
import { useStats } from '../../hooks/useStats';
import { useJobStatus } from '../../hooks/useJobStatus';
import StatsCard from './StatsCard';
import JobStatusList from './JobStatusList';
import ErrorMessage from '../Common/ErrorMessage';
import LoadingSpinner from '../Common/LoadingSpinner';
import Skeleton from '../Common/Skeleton';
import {
  VideoCameraIcon,
  LightBulbIcon,
  ChartBarIcon,
  ClockIcon,
} from '@heroicons/react/24/outline';

const Dashboard = () => {
  const { stats, loading: statsLoading, error: statsError } = useStats();
  const { jobs, loading: jobsLoading, error: jobsError } = useJobStatus();

  const statsCards = [
    {
      title: 'Total Tips',
      value: stats?.total_tips || 0,
      icon: LightBulbIcon,
      color: 'bg-blue-500',
    },
    {
      title: 'Total Videos',
      value: stats?.total_videos || 0,
      icon: VideoCameraIcon,
      color: 'bg-green-500',
    },
    {
      title: 'Average Sentiment',
      value: stats?.average_sentiment
        ? `${(stats.average_sentiment * 100).toFixed(0)}%`
        : 'N/A',
      icon: ChartBarIcon,
      color: 'bg-purple-500',
    },
    {
      title: 'Active Jobs',
      value: jobs?.filter((job) => job.status === 'processing').length || 0,
      icon: ClockIcon,
      color: 'bg-yellow-500',
    },
  ];

  if (statsError || jobsError) {
    return (
      <ErrorMessage
        title="Error loading dashboard data"
        message={statsError?.message || jobsError?.message}
        className="mb-6"
      />
    );
  }

  const isLoading = statsLoading || jobsLoading;

  if (isLoading) {
    return (
      <div className="space-y-6">
        <Skeleton type="text" lines={1} width="w-48" height="h-8" />
        
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
          {Array.from({ length: 4 }).map((_, index) => (
            <Skeleton key={index} type="card" />
          ))}
        </div>

        <div className="bg-white shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <Skeleton type="text" lines={1} width="w-32" height="h-6" />
            <div className="mt-4 space-y-4">
              {Array.from({ length: 3 }).map((_, index) => (
                <Skeleton key={index} type="text" lines={2} />
              ))}
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>

      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
        {statsCards.map((stat) => (
          <StatsCard
            key={stat.title}
            title={stat.title}
            value={stat.value}
            icon={stat.icon}
            color={stat.color}
            loading={false}
          />
        ))}
      </div>

      <div className="bg-white shadow rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <h2 className="text-lg font-medium text-gray-900">Recent Jobs</h2>
          <div className="mt-4">
            <JobStatusList jobs={jobs} loading={false} />
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard; 