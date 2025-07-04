import { useState, useEffect } from 'react';
import { api } from '../utils/api';

export const useVideos = (page = 1) => {
  const [videos, setVideos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [meta, setMeta] = useState({ total_pages: 1 });

  useEffect(() => {
    fetchVideos();
  }, [page]);

  const fetchVideos = async () => {
    try {
      setLoading(true);
      const data = await api.get(`/videos?page=${page}`);
      setVideos(data.videos);
      setMeta(data.meta);
      setError(null);
    } catch (error) {
      setError(error);
    } finally {
      setLoading(false);
    }
  };

  const getVideo = async (id) => {
    try {
      const data = await api.get(`/videos/${id}`);
      return data.video;
    } catch (error) {
      throw error;
    }
  };

  const retryVideoGeneration = async (id) => {
    try {
      const data = await api.post(`/videos/${id}/retry`);
      setVideos((prevVideos) =>
        prevVideos.map((video) =>
          video.id === id ? data.video : video
        )
      );
      return data.video;
    } catch (error) {
      throw error;
    }
  };

  const retryVideoUpload = async (id) => {
    try {
      const data = await api.post(`/videos/${id}/retry_upload`);
      setVideos((prevVideos) =>
        prevVideos.map((video) =>
          video.id === id ? data.video : video
        )
      );
      return data.video;
    } catch (error) {
      throw error;
    }
  };

  return {
    videos,
    loading,
    error,
    meta,
    getVideo,
    retryVideoGeneration,
    retryVideoUpload
  };
}; 