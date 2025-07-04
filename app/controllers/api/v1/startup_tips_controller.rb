# frozen_string_literal: true

module Api
  module V1
    # API endpoints for managing startup tips
    class StartupTipsController < ApiController
      before_action :set_startup_tip, only: %i[show update destroy]
      before_action :authenticate_user!, except: %i[index show]

      # GET /api/v1/startup_tips
      def index
        @startup_tips = StartupTip.page(pagination_params[:page])
                                 .per(pagination_params[:per_page])
                                 .order(created_at: :desc)

        render json: {
          startup_tips: @startup_tips,
          meta: {
            current_page: @startup_tips.current_page,
            total_pages: @startup_tips.total_pages,
            total_count: @startup_tips.total_count
          }
        }
      end

      # GET /api/v1/startup_tips/:id
      def show
        render json: @startup_tip
      end

      # POST /api/v1/startup_tips
      def create
        @startup_tip = StartupTip.new(startup_tip_params)

        if @startup_tip.save
          # Queue analysis job
          AnalyzeStartupTipsJob.perform_later(@startup_tip.id)

          render json: @startup_tip, status: :created
        else
          render json: {
            error: 'Validation Error',
            errors: @startup_tip.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/startup_tips/:id
      def update
        if @startup_tip.update(startup_tip_params)
          # Re-queue analysis if content changed
          if @startup_tip.saved_change_to_content?
            AnalyzeStartupTipsJob.perform_later(@startup_tip.id)
          end

          render json: @startup_tip
        else
          render json: {
            error: 'Validation Error',
            errors: @startup_tip.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/startup_tips/:id
      def destroy
        @startup_tip.destroy
        head :no_content
      end

      private

      def set_startup_tip
        @startup_tip = StartupTip.find(params[:id])
      end

      def startup_tip_params
        params.require(:startup_tip).permit(:title, :content)
      end
    end
  end
end 