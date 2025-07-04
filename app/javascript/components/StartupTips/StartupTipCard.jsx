import React, { useState, memo, useCallback } from 'react';
import { Link } from 'react-router-dom';
import { VideoCameraIcon, PencilIcon, TrashIcon } from '@heroicons/react/24/outline';
import { useStartupTips } from '../../hooks/useStartupTips';
import ConfirmationDialog from '../Common/ConfirmationDialog';

const StartupTipCard = memo(({ tip }) => {
  const { deleteTip, generateVideo } = useStartupTips();
  const [showDeleteDialog, setShowDeleteDialog] = useState(false);

  const handleDelete = async () => {
    setShowDeleteDialog(false);
    await deleteTip(tip.id);
  };

  const handleGenerateVideo = async () => {
    await generateVideo(tip.id);
  };

  const getSentimentColor = (score) => {
    if (!score) return 'bg-gray-100 text-gray-800';
    return score >= 0
      ? 'bg-green-100 text-green-800'
      : 'bg-red-100 text-red-800';
  };

  return (
    <div className="bg-white rounded-lg shadow overflow-hidden">
      <div className="p-6">
        <div className="flex justify-between items-start">
          <h3 className="text-lg font-medium text-gray-900 truncate">
            {tip.title}
          </h3>
          <span
            className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${getSentimentColor(
              tip.sentiment_score
            )}`}
          >
            {tip.sentiment_score
              ? `${(tip.sentiment_score * 100).toFixed(0)}%`
              : 'Analyzing...'}
          </span>
        </div>

        <p className="mt-3 text-sm text-gray-500 line-clamp-3">
          {tip.content}
        </p>

        <div className="mt-6 flex items-center justify-between">
          <div className="flex space-x-3">
            <Link
              to={`/startup-tips/${tip.id}/edit`}
              className="inline-flex items-center px-3 py-1.5 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
              <PencilIcon className="-ml-1 mr-2 h-4 w-4" aria-hidden="true" />
              Edit
            </Link>
            <button
              onClick={() => setShowDeleteDialog(true)}
              className="inline-flex items-center px-3 py-1.5 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-red-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
            >
              <TrashIcon className="-ml-1 mr-2 h-4 w-4" aria-hidden="true" />
              Delete
            </button>
          </div>

          {tip.video ? (
            <Link
              to={`/videos/${tip.video.id}`}
              className="inline-flex items-center px-3 py-1.5 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
              <VideoCameraIcon className="-ml-1 mr-2 h-4 w-4" aria-hidden="true" />
              View Video
            </Link>
          ) : (
            <button
              onClick={handleGenerateVideo}
              className="inline-flex items-center px-3 py-1.5 border border-transparent text-sm font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
            >
              <VideoCameraIcon className="-ml-1 mr-2 h-4 w-4" aria-hidden="true" />
              Generate Video
            </button>
          )}
        </div>
      </div>
      
      <ConfirmationDialog
        isOpen={showDeleteDialog}
        onClose={() => setShowDeleteDialog(false)}
        onConfirm={handleDelete}
        title="Delete Startup Tip"
        message="Are you sure you want to delete this startup tip? This action cannot be undone."
        confirmText="Delete"
        cancelText="Cancel"
        type="danger"
      />
    </div>
  );
});

StartupTipCard.displayName = 'StartupTipCard';

export default StartupTipCard; 