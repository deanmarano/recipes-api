class UsersController < ApplicationController
  before_action :doorkeeper_authorize!

  # GET /users
  def index
    @users = User.all

    render json: @users
  end


  # GET /users/1
  def show
    render json: UserSerializer.new(user).serialized_json
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:email, :password_digest, :name)
  end

  # Find the user that owns the access token
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
