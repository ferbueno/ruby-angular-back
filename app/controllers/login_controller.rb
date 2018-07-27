require 'tenant_resolver/jwt_encoder'
require 'encrypter/encrypter'
class LoginController < ApplicationController

    def_param_group :login do
        param :login, Hash, :required => true do
            param :email, /\A\S+@.+\.\S+\z/i, :desc => "User's email", :required => true
            param :password, String, :desc => "User's password", :required => true
        end
    end

    def_param_group :user_login do
        param :user, Hash, :required => true do
            param :first_name, String, :desc => "User's first name"
            param :last_name, String, :desc => "User's last name"
            param :email, String, :desc => "User's email"
        end
        param :token, String, :desc => "Authentication token to use in every request"
    end

    #POST /login
    api :POST, '/login', 'Logs in the specified user'
    formats ['json']
    description 'Gets all users related to the application. All users are the tenants.'
    param_group :login
    returns :code => 200, :desc => "Specified user" do
        param_group :user_login
      end
    def create
        @login = Login.new login_params
        @user = User.find_by :email => @login.email
        cipher = { :encrypted => @user.password, :salt => @user.salt }

        if (Encrypter.is_cipher_correct? cipher, @login.password)
            puts "User logged in!"
            token = JWTEncoder.encode_token(@user)
            render template: 'login/create.json.jbuilder', locals: { token: token, user: @user }
        else
            render "Error logging in", :status => 500
        end
    end

    private
        def login_params
            params.require(:login).permit(:email, :password)
        end
end