# Solopreneur Startup Coach

An automated YouTube Shorts channel that delivers actionable solopreneur startup tips, leveraging AI, LLMs, and tools like n8n, MCP, and A2A to empower entrepreneurs globally.

## Features

- Automated content generation from startup blogs, AI/LLM news, and tool documentation
- AI-driven strategy analysis and case study generation
- Automated video production with dynamic visuals and TTS narration
- Automated YouTube upload with SEO-optimized metadata
- Web dashboard for monitoring and approval
- Scheduled job processing (Mon-Fri, 6 AM PDT)

## Tech Stack

- Ruby on Rails 7.1
- SQLite (database)
- Sidekiq (background jobs)
- MoviePy (video editing)
- gTTS (text-to-speech)
- Google YouTube API
- NewsAPI (content sourcing)
- Pexels API (stock videos)

## Requirements

- Ruby 3.2.2
- Python 3.8+
- SQLite
- Redis (for Sidekiq)
- API Keys:
  - NewsAPI
  - Pexels
  - Google Cloud (YouTube API)

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/solostartupcoach.git
   cd solostartupcoach
   ```

2. Run the setup script:
   ```bash
   ./scripts/setup.sh
   ```

3. Configure environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

4. Start the services:
   ```bash
   # Start Rails server
   rails server

   # Start Sidekiq
   bundle exec sidekiq -C config/sidekiq.yml
   ```

5. Visit http://localhost:3000 to access the dashboard

## Usage

1. The system automatically crawls startup content every weekday at 6 AM PDT
2. New startup tips appear in the dashboard
3. You can manually trigger script generation for any tip
4. Videos can be automatically produced or require manual approval
5. Approved videos are automatically uploaded to YouTube

## Directory Structure

```
app/
├── controllers/         # Application controllers
├── jobs/               # Background jobs
├── models/             # Database models
├── services/           # Business logic services
└── views/              # UI templates
config/
├── sidekiq.yml         # Sidekiq configuration
└── .env                # Environment variables
public/
├── videos/             # Generated videos
└── thumbnails/         # Video thumbnails
scripts/
└── setup.sh            # Setup script
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Rails](https://rubyonrails.org/)
- [MoviePy](https://zulko.github.io/moviepy/)
- [gTTS](https://gtts.readthedocs.io/)
- [Sidekiq](https://sidekiq.org/)
- [YouTube Data API](https://developers.google.com/youtube/v3)
