class ApiController < ApplicationController
  def generate_script
    startup_tip = StartupTip.find(params[:startup_tip_id])
    GenerateScriptJob.perform_later(startup_tip.id)
    render json: { message: 'Script generation started' }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end 