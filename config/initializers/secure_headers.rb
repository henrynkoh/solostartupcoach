SecureHeaders::Configuration.default do |config|
  config.cookies = {
    secure: true,
    httponly: true,
    samesite: {
      strict: true
    }
  }

  config.x_frame_options = 'DENY'
  config.x_content_type_options = 'nosniff'
  config.x_xss_protection = '1; mode=block'
  config.x_download_options = 'noopen'
  config.x_permitted_cross_domain_policies = 'none'
  config.referrer_policy = %w[origin-when-cross-origin strict-origin-when-cross-origin]

  config.csp = {
    default_src: ["'self'"],
    base_uri: ["'self'"],
    child_src: ["'self'"],
    connect_src: ["'self'"],
    font_src: ["'self'", 'https://fonts.gstatic.com'],
    form_action: ["'self'"],
    frame_ancestors: ["'none'"],
    frame_src: ["'self'"],
    img_src: ["'self'", 'data:', 'https:'],
    manifest_src: ["'self'"],
    media_src: ["'self'"],
    object_src: ["'none'"],
    script_src: ["'self'", "'unsafe-inline'"],
    style_src: ["'self'", "'unsafe-inline'", 'https://fonts.googleapis.com'],
    worker_src: ["'self'"],
    upgrade_insecure_requests: true
  }

  # Enable HSTS with a 1 year max-age
  config.hsts = "max-age=#{20.years.to_i}; includeSubdomains"
end
