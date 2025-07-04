// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import "@hotwired/stimulus-loading"
import "trix"
import "@rails/actiontext"
import "chartkick"
import "Chart.bundle"
import "@rails/request.js"
import "@rails/activestorage"
import * as ActiveStorage from "@rails/activestorage"
import { DateTime } from "luxon"
import _ from "lodash"
import React from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter as Router } from 'react-router-dom';
import { AuthProvider } from './hooks/useAuth';
import AppRoutes from './routes';
import ErrorBoundary from './components/Common/ErrorBoundary';
import './stylesheets/application.css';

// Initialize ActiveStorage
ActiveStorage.start()

// Make libraries available globally where needed
window.Chartkick = Chartkick
window.DateTime = DateTime
window._ = _

// Stimulus controllers
const application = Application.start()
const context = require.context("./controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

// Configure Chartkick
Chartkick.configure({
  language: "en",
  mapsApiKey: null,
  loading: "Loading...",
  colors: ["#4f46e5", "#06b6d4", "#10b981", "#f59e0b", "#ef4444"]
})

document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('root');
  if (container) {
    const root = createRoot(container);
    root.render(
      <React.StrictMode>
        <ErrorBoundary>
          <Router>
            <AuthProvider>
              <AppRoutes />
            </AuthProvider>
          </Router>
        </ErrorBoundary>
      </React.StrictMode>
    );
  }
});
