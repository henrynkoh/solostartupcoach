import React, { Suspense, lazy } from 'react';
import LoadingSpinner from './LoadingSpinner';

const LazyLoad = ({ 
  component: Component, 
  fallback = <LoadingSpinner size="lg" text="Loading..." />,
  ...props 
}) => {
  return (
    <Suspense fallback={fallback}>
      <Component {...props} />
    </Suspense>
  );
};

// Helper function to create lazy components
export const createLazyComponent = (importFunc, fallback) => {
  const LazyComponent = lazy(importFunc);
  return (props) => (
    <LazyLoad 
      component={LazyComponent} 
      fallback={fallback} 
      {...props} 
    />
  );
};

export default LazyLoad; 