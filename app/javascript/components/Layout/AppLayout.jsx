import React from 'react';
import Navbar from './Navbar';
import Sidebar from './Sidebar';
import ToastConfig from '../Common/ToastConfig';

const AppLayout = ({ children }) => {
  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />
      
      <div className="flex">
        <Sidebar />
        
        <main className="flex-1 p-6">
          {children}
        </main>
      </div>
      
      <ToastConfig />
    </div>
  );
};

export default AppLayout; 