require 'tenant_resolver/jwt_encoder'

class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def_param_group :user do
    param :user, Hash, :required => true do
      param :first_name, String, :desc => "User's given name", :required => true
      param :last_name, String, :desc => "User's family name", :required => true
      param :email, /\A\S+@.+\.\S+\z/i, :desc => "User's email", :required => true
      param :password, String, :desc => "User's password", :required => true
    end
  end

  api :GET, '/users', 'Get all users'
  formats ['json']
  description 'Gets all users related to the application. All users are the tenants.'
  returns :array_of => :user, :code => 200, :desc => "All pets"
  def index
    @users = User.all
  end

  api :GET, '/users/:id', 'Get a specific user'
  formats ['json']
  param :id, Integer, :desc => "User's ID", :required => true
  returns :code => 200, :desc => "Specified user" do
    param_group :user
  end
  def show
  end

  api :POST, '/users', 'Create a new user.'
  formats ['json']
  param_group :user
  formats ['json']
  description 'Creates a new user in the DB. It then creates a new tenant.'
  def create
    @user = User.new user_params
    if @user.save
      render json: {token: JWTEncoder.encode_token(@user)}
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end
end
