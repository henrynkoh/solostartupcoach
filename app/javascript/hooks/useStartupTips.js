import { useState, useEffect, useCallback } from 'react';
import { api } from '../utils/api';
import { toast } from 'react-hot-toast';
import { handleNetworkError, handleValidationErrors } from '../utils/networkErrorHandler';
import { measureAsyncPerformance } from '../utils/performance';

export const useStartupTips = (page = 1) => {
  const [tips, setTips] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [meta, setMeta] = useState({ total_pages: 1 });

  useEffect(() => {
    fetchTips();
  }, [page]);

  const fetchTips = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await measureAsyncPerformance(
        `Fetching startup tips page ${page}`,
        () => api.get(`/startup_tips?page=${page}`)
      );
      setTips(data.startup_tips);
      setMeta(data.meta);
    } catch (error) {
      const { message } = handleNetworkError(error, 'fetching startup tips');
      setError({ message, retry: fetchTips });
    } finally {
      setLoading(false);
    }
  }, [page]);

  const createTip = async (tipData) => {
    try {
      const data = await api.post('/startup_tips', { startup_tip: tipData });
      setTips((prevTips) => [data.startup_tip, ...prevTips]);
      toast.success('Startup tip created successfully');
      return data.startup_tip;
    } catch (error) {
      if (error.errors) {
        const validationMessage = handleValidationErrors(error.errors);
        toast.error(validationMessage);
      } else {
        handleNetworkError(error, 'creating startup tip');
      }
      throw error;
    }
  };

  const updateTip = async (id, tipData) => {
    try {
      const data = await api.put(`/startup_tips/${id}`, { startup_tip: tipData });
      setTips((prevTips) =>
        prevTips.map((tip) =>
          tip.id === id ? data.startup_tip : tip
        )
      );
      toast.success('Startup tip updated successfully');
      return data.startup_tip;
    } catch (error) {
      if (error.errors) {
        const validationMessage = handleValidationErrors(error.errors);
        toast.error(validationMessage);
      } else {
        handleNetworkError(error, 'updating startup tip');
      }
      throw error;
    }
  };

  const deleteTip = async (id) => {
    try {
      await api.delete(`/startup_tips/${id}`);
      setTips((prevTips) => prevTips.filter((tip) => tip.id !== id));
      toast.success('Startup tip deleted successfully');
    } catch (error) {
      handleNetworkError(error, 'deleting startup tip');
      throw error;
    }
  };

  const generateVideo = async (id) => {
    try {
      const data = await api.post(`/startup_tips/${id}/generate_video`);
      setTips((prevTips) =>
        prevTips.map((tip) =>
          tip.id === id ? { ...tip, video: data.video } : tip
        )
      );
      toast.success('Video generation started');
      return data.video;
    } catch (error) {
      handleNetworkError(error, 'generating video');
      throw error;
    }
  };

  return {
    tips,
    loading,
    error,
    meta,
    createTip,
    updateTip,
    deleteTip,
    generateVideo,
    refetch: fetchTips
  };
}; 