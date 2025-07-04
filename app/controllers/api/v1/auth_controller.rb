class Api::V1::AuthController < ApiController
  def me
    if current_user
      render json: { user: current_user }
    else
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end
end 