import { useState, useEffect } from 'react';
import { api } from '../utils/api';

export const useJobStatus = () => {
  const [jobs, setJobs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchJobs();
    const interval = setInterval(fetchJobs, 5000); // Poll every 5 seconds
    return () => clearInterval(interval);
  }, []);

  const fetchJobs = async () => {
    try {
      setLoading(true);
      const data = await api.get('/jobs');
      setJobs(data.jobs);
      setError(null);
    } catch (error) {
      setError(error);
    } finally {
      setLoading(false);
    }
  };

  const getJobStatus = async (jobId) => {
    try {
      const data = await api.get(`/jobs/${jobId}`);
      return data.job;
    } catch (error) {
      throw error;
    }
  };

  const retryJob = async (jobId) => {
    try {
      const data = await api.post(`/jobs/${jobId}/retry`);
      setJobs((prevJobs) =>
        prevJobs.map((job) =>
          job.id === jobId ? data.job : job
        )
      );
      return data.job;
    } catch (error) {
      throw error;
    }
  };

  const cancelJob = async (jobId) => {
    try {
      const data = await api.post(`/jobs/${jobId}/cancel`);
      setJobs((prevJobs) =>
        prevJobs.map((job) =>
          job.id === jobId ? data.job : job
        )
      );
      return data.job;
    } catch (error) {
      throw error;
    }
  };

  return {
    jobs,
    loading,
    error,
    getJobStatus,
    retryJob,
    cancelJob
  };
}; 