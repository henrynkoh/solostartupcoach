import React from 'react';
import { ExclamationCircleIcon } from '@heroicons/react/24/solid';

const FormError = ({ error, className = '' }) => {
  if (!error) return null;

  return (
    <div className={`flex items-center mt-2 text-sm text-red-600 ${className}`}>
      <ExclamationCircleIcon className="h-4 w-4 mr-1 flex-shrink-0" />
      <span>{error}</span>
    </div>
  );
};

export default FormError; 