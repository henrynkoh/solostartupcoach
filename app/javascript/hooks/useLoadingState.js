import { useState, useCallback, useRef } from 'react';

export const useLoadingState = (initialState = {}) => {
  const [loadingStates, setLoadingStates] = useState(initialState);
  const loadingTimeouts = useRef(new Map());

  const setLoading = useCallback((key, duration = 500) => {
    setLoadingStates(prev => ({ ...prev, [key]: true }));
    
    // Clear existing timeout for this key
    if (loadingTimeouts.current.has(key)) {
      clearTimeout(loadingTimeouts.current.get(key));
    }
    
    // Set minimum loading duration to prevent flickering
    const timeout = setTimeout(() => {
      setLoadingStates(prev => ({ ...prev, [key]: false }));
      loadingTimeouts.current.delete(key);
    }, duration);
    
    loadingTimeouts.current.set(key, timeout);
  }, []);

  const setLoaded = useCallback((key) => {
    setLoadingStates(prev => ({ ...prev, [key]: false }));
    
    // Clear timeout if it exists
    if (loadingTimeouts.current.has(key)) {
      clearTimeout(loadingTimeouts.current.get(key));
      loadingTimeouts.current.delete(key);
    }
  }, []);

  const setError = useCallback((key) => {
    setLoadingStates(prev => ({ ...prev, [key]: false }));
    
    // Clear timeout if it exists
    if (loadingTimeouts.current.has(key)) {
      clearTimeout(loadingTimeouts.current.get(key));
      loadingTimeouts.current.delete(key);
    }
  }, []);

  const isLoading = useCallback((key) => {
    return loadingStates[key] || false;
  }, [loadingStates]);

  const isAnyLoading = useCallback(() => {
    return Object.values(loadingStates).some(Boolean);
  }, [loadingStates]);

  // Cleanup timeouts on unmount
  const cleanup = useCallback(() => {
    loadingTimeouts.current.forEach(timeout => clearTimeout(timeout));
    loadingTimeouts.current.clear();
  }, []);

  return {
    loadingStates,
    setLoading,
    setLoaded,
    setError,
    isLoading,
    isAnyLoading,
    cleanup
  };
}; 