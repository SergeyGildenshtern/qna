class RewardsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  expose :rewards, -> { current_user.rewards }
end
