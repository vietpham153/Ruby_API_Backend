module Api 
  module V1
    class ChallengesController < ApplicationController
      before_action :authenticate_user!, only: %i[create update destroy]
      before_action :set_challenges, only: %i[show update destroy]
      before_action :authorize_admin, only: %i[create update destroy]

      # GET api/v1/challenge
      def index
        # Show all challenges
        @challenges = Challenge.all
        render json: @challenges
      end

      # GET api/v1/challenges/:id
      def show
        #Show single challenge
        if @challenge
          render json: { message: 'Challenge found', data: @challenge }
        else
          render json: { message: 'Challenge not found', data: @challenge.errors }
        end
      end

      # PATCH/PUT api/v1/challenges/:id
      def update
        #update single challenge
        if @challenge.update(challenge_params)
          render json: { message: 'Challenge updated successful', data: @challenge }
        else
          render json: { message: 'Failed to update challenge', data: @challenge.errors }
        end
      end

      # DELETE api/v1/challenges/:id
      def destroy
        #delete single challenge
        if @challenge.destroy
          render json: { message: 'Challenge deleted successful', data: @challenge }
        else
          render json: { message: 'Failed to delete challenge', data: @challenge.errors }
        end
      end

       # POST api/v1/challenge
      def create
        # @challenge = Challenge.new(challenge_params.merge(user_id: current_user.id))
        @challenge = current_user.challenges.build(challenge_params)
        # Check if user is authenticated before creating a challenge


          if @challenge.save
            render json: { message: 'Challenge added successful', data: @challenge }
          else
            render json: { message: 'Failed to added challenge', data: @challenge.errors }
          end
      end

      private

      def authorize_admin
        render json: { message: 'Forbidden action' } unless current_user.email == EVN['ADMIN_EMAIL']
      end

      def set_challenges
        @challenge = Challenge.find(params[:id])
      end
      def challenge_params
        params.require(:challenge).permit(:title, :description, :start_date, :end_date)
      end
    end
  end 
end 