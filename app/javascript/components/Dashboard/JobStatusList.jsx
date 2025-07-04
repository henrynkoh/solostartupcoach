import React from 'react';
import { Link } from 'react-router-dom';
import {
  CheckCircleIcon,
  XCircleIcon,
  ClockIcon,
} from '@heroicons/react/24/outline';

const JobStatusList = ({ jobs, loading }) => {
  const getStatusIcon = (status) => {
    switch (status) {
      case 'completed':
        return (
          <CheckCircleIcon
            className="h-5 w-5 text-green-500"
            aria-hidden="true"
          />
        );
      case 'failed':
        return (
          <XCircleIcon className="h-5 w-5 text-red-500" aria-hidden="true" />
        );
      default:
        return (
          <ClockIcon className="h-5 w-5 text-yellow-500" aria-hidden="true" />
        );
    }
  };

  const getStatusText = (status) => {
    switch (status) {
      case 'completed':
        return 'text-green-800 bg-green-100';
      case 'failed':
        return 'text-red-800 bg-red-100';
      default:
        return 'text-yellow-800 bg-yellow-100';
    }
  };

  if (loading) {
    return (
      <div className="space-y-4">
        {[...Array(3)].map((_, i) => (
          <div
            key={i}
            className="animate-pulse flex items-center justify-between p-4 bg-gray-50 rounded-md"
          >
            <div className="flex items-center space-x-4">
              <div className="h-5 w-5 bg-gray-200 rounded-full" />
              <div className="h-4 w-48 bg-gray-200 rounded" />
            </div>
            <div className="h-4 w-24 bg-gray-200 rounded" />
          </div>
        ))}
      </div>
    );
  }

  if (!jobs?.length) {
    return (
      <div className="text-center py-6 text-gray-500">
        No recent jobs to display
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {jobs.map((job) => (
        <div
          key={job.id}
          className="flex items-center justify-between p-4 bg-gray-50 rounded-md"
        >
          <div className="flex items-center space-x-4">
            {getStatusIcon(job.status)}
            <div>
              <h4 className="text-sm font-medium text-gray-900">
                {job.job_type}
              </h4>
              <p className="text-sm text-gray-500">{job.description}</p>
            </div>
          </div>

          <div className="flex items-center space-x-4">
            <span
              className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${getStatusText(
                job.status
              )}`}
            >
              {job.status}
            </span>

            {job.resource_type && job.resource_id && (
              <Link
                to={`/${job.resource_type.toLowerCase()}s/${job.resource_id}`}
                className="text-sm text-blue-600 hover:text-blue-500"
              >
                View Resource
              </Link>
            )}
          </div>
        </div>
      ))}
    </div>
  );
};

export default JobStatusList; 