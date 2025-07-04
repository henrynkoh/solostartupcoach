import { useState, useEffect, useCallback, useRef } from 'react';

export const useInfiniteScroll = ({
  hasMore,
  loading,
  onLoadMore,
  threshold = 100,
  rootMargin = '0px'
}) => {
  const [observerTarget, setObserverTarget] = useState(null);
  const observerRef = useRef(null);

  const handleObserver = useCallback(
    (entries) => {
      const target = entries[0];
      if (target.isIntersecting && hasMore && !loading) {
        onLoadMore();
      }
    },
    [hasMore, loading, onLoadMore]
  );

  useEffect(() => {
    const observer = new IntersectionObserver(handleObserver, {
      rootMargin,
      threshold: 0.1
    });

    observerRef.current = observer;

    if (observerTarget) {
      observer.observe(observerTarget);
    }

    return () => {
      if (observerRef.current) {
        observerRef.current.disconnect();
      }
    };
  }, [observerTarget, handleObserver, rootMargin]);

  return setObserverTarget;
}; 