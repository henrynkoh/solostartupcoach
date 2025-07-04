class HealthController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    health_status = {
      status: 'ok',
      timestamp: Time.current,
      checks: {
        database: check_database,
        redis: check_redis,
        sidekiq: check_sidekiq
      }
    }

    if health_status[:checks].values.all? { |status| status[:status] == 'ok' }
      render json: health_status
    else
      render json: health_status, status: :service_unavailable
    end
  end

  private

  def check_database
    ActiveRecord::Base.connection.execute('SELECT 1')
    { status: 'ok' }
  rescue StandardError => e
    { status: 'error', message: e.message }
  end

  def check_redis
    Redis.current.ping
    { status: 'ok' }
  rescue StandardError => e
    { status: 'error', message: e.message }
  end

  def check_sidekiq
    ps = Sidekiq::ProcessSet.new
    {
      status: ps.size.positive? ? 'ok' : 'warning',
      workers: ps.size,
      queues: Sidekiq::Queue.all.map { |q| { name: q.name, size: q.size } }
    }
  rescue StandardError => e
    { status: 'error', message: e.message }
  end
end
