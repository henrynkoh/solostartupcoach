require 'httparty'

# frozen_string_literal: true

# Service for analyzing startup tips using sentiment analysis
class StartupAnalyzer
  class Error < StandardError; end
  class APIError < Error; end

  # Analyzes the sentiment of a startup tip
  # @param startup_tip [StartupTip] the startup tip to analyze
  # @return [Float] the sentiment score between -1.0 and 1.0
  # @raise [APIError] if the API request fails
  def self.analyze_sentiment(startup_tip)
    new.analyze_sentiment(startup_tip)
  end

  def analyze(startup_tip)
    strategy = generate_strategy(startup_tip.topic, startup_tip.tool)
    case_study = generate_case_study(startup_tip.tool)
    sentiment = analyze_sentiment(startup_tip)
    startup_tip.update!(
      strategy: strategy,
      case_study: case_study,
      sentiment: sentiment
    )
  rescue StandardError => e
    Rails.logger.error("Startup analysis failed: #{e.message}")
  end

  private

  def generate_strategy(topic, tool)
    # Simplified: Hardcoded strategies for MVP
    case topic
    when 'AI Automation'
      "Use #{tool} to automate workflows, save 10 hours/week."
    when 'LLM Content Creation'
      "Leverage #{tool} for marketing content, cut costs by 50%."
    else
      "Boost your startup with #{topic} using #{tool}."
    end
  end

  def generate_case_study(tool)
    # Simplified: Hypothetical cases
    case tool
    when 'n8n'
      'Solopreneur automates customer outreach, earns $10K/month.'
    when 'ChatGPT'
      'Entrepreneur creates blog with LLM, saves $5K.'
    else
      "#{tool} powers solopreneur success."
    end
  end

  def analyze_sentiment(startup_tip)
    raise ArgumentError, 'StartupTip must be provided' unless startup_tip.is_a?(StartupTip)
    raise ArgumentError, 'StartupTip content must be present' if startup_tip.content.blank?

    # Here you would integrate with a sentiment analysis API
    # For now, we'll use a simple implementation
    score = calculate_simple_sentiment(startup_tip.content)
    
    startup_tip.update_sentiment_score(score)
    score
  rescue StandardError => e
    Rails.logger.error("Failed to analyze sentiment for StartupTip##{startup_tip.id}: #{e.message}")
    raise APIError, "Failed to analyze sentiment: #{e.message}"
  end

  # Simple sentiment analysis implementation
  # @param text [String] the text to analyze
  # @return [Float] sentiment score between -1.0 and 1.0
  def calculate_simple_sentiment(text)
    # List of positive and negative words
    positive_words = %w[good great excellent amazing awesome innovative successful growth opportunity positive helpful valuable effective efficient proven reliable]
    negative_words = %w[bad poor terrible horrible ineffective inefficient unreliable risky negative problematic difficult challenging complicated expensive]

    words = text.downcase.split(/\W+/)
    positive_count = words.count { |word| positive_words.include?(word) }
    negative_count = words.count { |word| negative_words.include?(word) }
    total_count = positive_count + negative_count

    return 0.0 if total_count.zero?

    ((positive_count - negative_count).to_f / total_count).clamp(-1.0, 1.0)
  end

  def fetch_news_data(source_url)
    api_url = build_api_url(source_url)
    HTTParty.get(api_url, timeout: 10)
  end

  def build_api_url(source_url)
    base_url = 'https://newsapi.org/v2/everything'
    query = URI.encode_www_form_component(source_url)
    api_key = ENV.fetch('NEWSAPI_KEY', nil)
    "#{base_url}?q=startup+#{query}&apiKey=#{api_key}"
  end

  def calculate_sentiment(articles)
    return 'neutral' if articles.empty?

    total_sentiment = articles.sum { |article| sentiment_score(article) }
    average_sentiment = total_sentiment.to_f / articles.length

    case average_sentiment
    when ->(n) { n > 0.5 } then 'positive'
    when ->(n) { n < -0.5 } then 'negative'
    else 'neutral'
    end
  end

  def sentiment_score(article)
    title = article['title'].to_s.downcase
    description = article['description'].to_s.downcase

    score = 0
    score += 1 if positive_keywords.any? { |word| title.include?(word) || description.include?(word) }
    score -= 1 if negative_keywords.any? { |word| title.include?(word) || description.include?(word) }
    score
  end

  def positive_keywords
    %w[success growth profit innovative breakthrough revolutionary promising]
  end

  def negative_keywords
    %w[failure bankruptcy loss scam fraud investigation shutdown]
  end
end
