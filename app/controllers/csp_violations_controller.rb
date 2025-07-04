class CspViolationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  skip_before_action :authenticate_user!

  def create
    return head :ok unless should_log_violation?

    log_csp_violation
    head :ok
  end

  private

  def should_log_violation?
    report = parse_csp_report
    return false if report.blank?

    blocked_uri = report['blocked-uri']
    violated_directive = report['violated-directive']

    blocked_uri.present? && violated_directive.present?
  end

  def log_csp_violation
    report = parse_csp_report
    Rails.logger.warn(
      "CSP Violation: #{report['violated-directive']} - " \
      "Blocked URI: #{report['blocked-uri']} - " \
      "Source: #{report['source-file']}"
    )
  end

  def parse_csp_report
    return {} if request.raw_post.blank?

    JSON.parse(request.raw_post)['csp-report'] || {}
  rescue JSON::ParserError
    {}
  end
end
