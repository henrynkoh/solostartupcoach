import { handleNetworkError, handleValidationErrors } from './networkErrorHandler';

const API_BASE_URL = '/api/v1';

const handleResponse = async (response) => {
  if (!response.ok) {
    let errorData;
    try {
      errorData = await response.json();
    } catch {
      errorData = { message: 'An unexpected error occurred' };
    }

    const error = new Error(errorData.message || 'An unexpected error occurred');
    error.status = response.status;
    error.errors = errorData.errors;
    throw error;
  }
  return response.json();
};

const request = async (endpoint, options = {}) => {
  const defaultOptions = {
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('[name="csrf-token"]')?.content
    },
    credentials: 'same-origin'
  };

  try {
    const response = await fetch(
      `${API_BASE_URL}${endpoint}`,
      { ...defaultOptions, ...options }
    );
    return await handleResponse(response);
  } catch (error) {
    // Don't show toast for network errors here - let the calling code handle it
    if (error.name === 'TypeError' && error.message.includes('fetch')) {
      throw error;
    }
    
    // For other errors, handle them appropriately
    handleNetworkError(error, `API request to ${endpoint}`);
    throw error;
  }
};

export const api = {
  get: (endpoint) => request(endpoint),
  
  post: (endpoint, data) => request(endpoint, {
    method: 'POST',
    body: JSON.stringify(data)
  }),
  
  put: (endpoint, data) => request(endpoint, {
    method: 'PUT',
    body: JSON.stringify(data)
  }),
  
  delete: (endpoint) => request(endpoint, {
    method: 'DELETE'
  })
}; 