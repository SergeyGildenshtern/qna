class Api::V1::ProfilesController < Api::V1::BaseController
  expose :users, -> { User.all.without current_resource_owner }

  authorize_resource class: User

  def me
    render json: current_resource_owner
  end

  def other
    render json: users, root: "users"
  end
end
