# Solopreneur Startup Coach - 10-Minute Quickstart Guide

## Table of Contents
1. [Prerequisites Check](#prerequisites-check)
2. [Installation Steps](#installation-steps)
3. [Initial Configuration](#initial-configuration)
4. [First Run](#first-run)
5. [Next Steps](#next-steps)
6. [Troubleshooting](#troubleshooting)

## Prerequisites Check

### System Requirements
- Operating System:
  ```bash
  # Check OS version
  uname -a  # Unix/Linux/macOS
  ver       # Windows
  ```

- Hardware:
  ```bash
  # Check CPU cores
  nproc     # Linux
  sysctl -n hw.ncpu  # macOS
  
  # Check RAM
  free -h   # Linux
  vm_stat   # macOS
  ```

### Software Requirements
1. Ruby:
   ```bash
   # Check Ruby version
   ruby -v  # Should be 3.2.2+
   
   # Install if needed
   rbenv install 3.2.2
   rbenv global 3.2.2
   ```

2. Python:
   ```bash
   # Check Python version
   python3 --version  # Should be 3.8+
   
   # Install if needed
   pyenv install 3.8.12
   pyenv global 3.8.12
   ```

3. Database:
   ```bash
   # Check SQLite version
   sqlite3 --version  # Should be 3.x
   
   # Install if needed
   brew install sqlite  # macOS
   sudo apt install sqlite3  # Ubuntu
   ```

4. Package Managers:
   ```bash
   # Check package managers
   gem -v
   pip -V
   npm -v
   ```

## Installation Steps

### 1. Clone Repository
```bash
# Clone the repo
git clone https://github.com/yourusername/solostartupcoach.git
cd solostartupcoach

# Check structure
ls -la
```

### 2. Install Dependencies
```bash
# Ruby dependencies
bundle install

# Python packages
pip install -r requirements.txt

# Node packages
yarn install
```

### 3. Setup Database
```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# Load sample data
rails db:seed
```

### 4. Start Services
```bash
# Start Redis
brew services start redis  # macOS
sudo service redis start  # Ubuntu

# Start Sidekiq
bundle exec sidekiq -C config/sidekiq.yml

# Start Rails server
rails server
```

## Initial Configuration

### 1. API Keys Setup
```bash
# Copy example env file
cp .env.example .env

# Edit with your keys
nano .env  # or use your preferred editor
```

Required API keys:
- NewsAPI: Sign up at https://newsapi.org
- Pexels: Register at https://www.pexels.com/api
- YouTube: Create project at https://console.cloud.google.com

### 2. Basic Settings
```ruby
# config/application.rb
config.time_zone = 'America/Los_Angeles'  # Change to your timezone
config.i18n.default_locale = :en          # Change for different language
```

### 3. Job Schedule
```yaml
# config/sidekiq.yml
:schedule:
  crawl_startup_tips_job:
    cron: '0 6 * * 1-5'  # Weekdays 6 AM
    class: CrawlStartupTipsJob
```

## First Run

### 1. Health Check
```bash
# Check system status
rails health:check

# Verify API connections
rails api:test_connections

# Test job processing
rails jobs:test
```

### 2. Create First Content
```bash
# Generate startup tip
rails generate:tip

# Create video
rails generate:video

# Test upload
rails youtube:test_upload
```

### 3. Monitor Progress
1. Visit http://localhost:3000/dashboard
2. Check job status in Sidekiq UI
3. Monitor logs: `tail -f log/development.log`

## Next Steps

### 1. Customize Content
- Edit templates in `lib/assets/templates/`
- Modify video styles in `app/services/video_producer.rb`
- Adjust AI parameters in `config/initializers/ai.rb`

### 2. Setup Monitoring
```bash
# Enable monitoring
rails monitoring:setup

# Configure alerts
rails alerts:configure
```

### 3. Schedule Production
```bash
# Review schedule
rails schedule:list

# Modify if needed
rails schedule:modify
```

## Troubleshooting

### Common Issues

1. Database Connection:
   ```bash
   # Reset database
   rails db:reset
   
   # Check connection
   rails db:version
   ```

2. Job Processing:
   ```bash
   # Clear job queue
   rails jobs:clear
   
   # Restart Sidekiq
   rails jobs:restart
   ```

3. API Errors:
   ```bash
   # Test API connections
   rails api:test
   
   # Clear API cache
   rails api:clear_cache
   ```

### Quick Fixes

1. Permission Issues:
   ```bash
   # Fix permissions
   chmod -R 755 .
   chmod -R 777 tmp log storage
   ```

2. Dependency Problems:
   ```bash
   # Update all dependencies
   bundle update
   yarn upgrade
   pip install --upgrade -r requirements.txt
   ```

3. Cache Issues:
   ```bash
   # Clear all caches
   rails tmp:clear
   rails log:clear
   rails assets:clean
   ```

### Getting Help
- Documentation: Check `docs/` directory
- Issues: Visit GitHub repository
- Support: Email support@solostartupcoach.com

Remember: The system runs automatically on weekdays at 6 AM PDT. You can monitor progress and manage content through the web dashboard at http://localhost:3000. 