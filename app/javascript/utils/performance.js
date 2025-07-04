// Performance monitoring utilities
export const measurePerformance = (name, fn) => {
  const start = performance.now();
  const result = fn();
  const end = performance.now();
  
  if (process.env.NODE_ENV === 'development') {
    console.log(`${name} took ${(end - start).toFixed(2)}ms`);
  }
  
  return result;
};

export const measureAsyncPerformance = async (name, fn) => {
  const start = performance.now();
  const result = await fn();
  const end = performance.now();
  
  if (process.env.NODE_ENV === 'development') {
    console.log(`${name} took ${(end - start).toFixed(2)}ms`);
  }
  
  return result;
};

// Memory usage monitoring
export const logMemoryUsage = (label = 'Memory Usage') => {
  if (process.env.NODE_ENV === 'development' && performance.memory) {
    const memory = performance.memory;
    console.log(`${label}:`, {
      used: `${(memory.usedJSHeapSize / 1048576).toFixed(2)} MB`,
      total: `${(memory.totalJSHeapSize / 1048576).toFixed(2)} MB`,
      limit: `${(memory.jsHeapSizeLimit / 1048576).toFixed(2)} MB`
    });
  }
};

// Component render performance
export const withPerformanceTracking = (Component, componentName) => {
  return React.memo((props) => {
    const renderStart = performance.now();
    
    React.useEffect(() => {
      const renderEnd = performance.now();
      if (process.env.NODE_ENV === 'development') {
        console.log(`${componentName} rendered in ${(renderEnd - renderStart).toFixed(2)}ms`);
      }
    });
    
    return <Component {...props} />;
  });
};

// Debounced function with performance tracking
export const debounceWithTracking = (func, wait, name = 'Debounced Function') => {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      measurePerformance(name, () => func(...args));
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}; 