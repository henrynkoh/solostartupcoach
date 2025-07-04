import React, { memo, useMemo } from 'react';
import { Link } from 'react-router-dom';
import { PlayIcon, ClockIcon } from '@heroicons/react/24/outline';

const VideoCard = memo(({ video }) => {
  const getStatusColor = useMemo(() => (status) => {
    switch (status) {
      case 'processing':
        return 'bg-yellow-100 text-yellow-800';
      case 'generated':
        return 'bg-blue-100 text-blue-800';
      case 'uploading':
        return 'bg-purple-100 text-purple-800';
      case 'uploaded':
        return 'bg-green-100 text-green-800';
      case 'failed':
        return 'bg-red-100 text-red-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  }, []);

  const formatDuration = useMemo(() => (seconds) => {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
  }, []);

  return (
    <div className="bg-white rounded-lg shadow overflow-hidden">
      <div className="relative">
        {video.youtube_url ? (
          <a
            href={video.youtube_url}
            target="_blank"
            rel="noopener noreferrer"
            className="block aspect-video bg-gray-100 relative"
          >
            <img
              src={`https://img.youtube.com/vi/${video.youtube_url.split('v=')[1]}/maxresdefault.jpg`}
              alt={video.title}
              className="w-full h-full object-cover"
            />
            <div className="absolute inset-0 flex items-center justify-center">
              <PlayIcon className="h-16 w-16 text-white opacity-75 hover:opacity-100 transition-opacity" />
            </div>
          </a>
        ) : (
          <div className="aspect-video bg-gray-100 flex items-center justify-center">
            <ClockIcon className="h-16 w-16 text-gray-400" />
          </div>
        )}

        {video.duration && (
          <div className="absolute bottom-2 right-2 px-2 py-1 bg-black bg-opacity-75 rounded text-white text-sm">
            {formatDuration(video.duration)}
          </div>
        )}
      </div>

      <div className="p-4">
        <div className="flex justify-between items-start">
          <h3 className="text-lg font-medium text-gray-900 truncate">
            {video.title}
          </h3>
          <span
            className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${getStatusColor(
              video.status
            )}`}
          >
            {video.status}
          </span>
        </div>

        <p className="mt-2 text-sm text-gray-500 line-clamp-2">
          {video.description}
        </p>

        <div className="mt-4">
          <Link
            to={`/startup-tips/${video.startup_tip.id}`}
            className="text-sm text-blue-600 hover:text-blue-500"
          >
            View Original Tip
          </Link>
        </div>

        {video.error_message && (
          <div className="mt-4 p-3 bg-red-50 rounded-md">
            <p className="text-sm text-red-700">{video.error_message}</p>
          </div>
        )}
      </div>
    </div>
  );
});

VideoCard.displayName = 'VideoCard';

export default VideoCard; 