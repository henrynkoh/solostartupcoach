module Rack
  class Attack
    ### Configure Cache ###
    Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV.fetch('REDIS_URL', nil))

    ### Throttle Spammy Clients ###
    # Throttle all requests by IP (60rpm)
    throttle('req/ip', limit: 300, period: 5.minutes) do |req|
      req.ip unless req.path.start_with?('/assets')
    end

    # Throttle login attempts by IP address (5 per minute)
    throttle('logins/ip', limit: 5, period: 1.minute) do |req|
      req.ip if req.path == '/users/sign_in' && req.post?
    end

    # Throttle login attempts by email address (5 per minute)
    throttle('logins/email', limit: 5, period: 1.minute) do |req|
      req.params['email'].to_s.downcase.gsub(/\s+/, '') if req.path == '/users/sign_in' && req.post?
    end

    # Throttle API requests by token
    throttle('api/token', limit: 30, period: 1.minute) do |req|
      req.get_header('HTTP_AUTHORIZATION') if req.path.start_with?('/api/')
    end

    ### Prevent Brute-Force Login Attacks ###
    # Block suspicious requests for '/users/sign_in' and '/users/sign_up'
    blocklist('allow2ban/ip') do |req|
      Allow2Ban.filter(req.ip, maxretry: 10, findtime: 1.minute, bantime: 1.hour) do
        req.path.start_with?('/users/sign_in', '/users/sign_up') && req.post?
      end
    end

    ### Custom Throttle Response ###
    self.throttled_response = lambda do |env|
      now = Time.zone.now
      match_data = env['rack.attack.match_data']

      headers = {
        'Content-Type' => 'application/json',
        'X-RateLimit-Limit' => match_data[:limit].to_s,
        'X-RateLimit-Remaining' => '0',
        'X-RateLimit-Reset' => (now + (match_data[:period] - (now.to_i % match_data[:period]))).to_s
      }

      [429, headers, [{ error: 'Throttled: Too many requests' }.to_json]]
    end
  end
end
