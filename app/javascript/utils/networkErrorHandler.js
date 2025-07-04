import { toast } from 'react-hot-toast';

export const handleNetworkError = (error, context = '') => {
  let message = 'An unexpected error occurred';
  let title = 'Error';

  if (error.name === 'TypeError' && error.message.includes('fetch')) {
    message = 'Network error. Please check your internet connection.';
    title = 'Connection Error';
  } else if (error.status === 401) {
    message = 'You are not authorized to perform this action.';
    title = 'Unauthorized';
  } else if (error.status === 403) {
    message = 'You do not have permission to access this resource.';
    title = 'Forbidden';
  } else if (error.status === 404) {
    message = 'The requested resource was not found.';
    title = 'Not Found';
  } else if (error.status === 422) {
    message = error.message || 'Validation error. Please check your input.';
    title = 'Validation Error';
  } else if (error.status === 500) {
    message = 'Server error. Please try again later.';
    title = 'Server Error';
  } else if (error.status >= 500) {
    message = 'Server error. Please try again later.';
    title = 'Server Error';
  } else if (error.status >= 400) {
    message = error.message || 'Request error. Please try again.';
    title = 'Request Error';
  } else if (error.message) {
    message = error.message;
  }

  // Log error for debugging
  console.error(`Error in ${context}:`, error);

  // Show toast notification
  toast.error(message, {
    duration: 5000,
    position: 'bottom-right',
  });

  return { title, message };
};

export const handleValidationErrors = (errors) => {
  if (typeof errors === 'string') {
    return errors;
  }

  if (Array.isArray(errors)) {
    return errors.join(', ');
  }

  if (typeof errors === 'object') {
    return Object.values(errors).flat().join(', ');
  }

  return 'Validation error occurred';
};

export const isNetworkError = (error) => {
  return (
    error.name === 'TypeError' && 
    (error.message.includes('fetch') || error.message.includes('network'))
  );
};

export const isServerError = (error) => {
  return error.status >= 500;
};

export const isClientError = (error) => {
  return error.status >= 400 && error.status < 500;
}; 