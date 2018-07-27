require 'tenant_resolver/jwt_encoder'
require 'encrypter/encrypter'
class LoginController < ApplicationController
    #POST /login
    def create
        @login = Login.new login_params
        @user = User.find_by :email => @login.email
        cipher = { :encrypted => @user.password, :salt => @user.salt }

        if (Encrypter.is_cipher_correct? cipher, @login.password)
            puts "User logged in!"
            token = JWTEncoder.encode_token(@user)
            render plain: token
        else
            render "Error logging in", :status => 500
        end
    end

    private
        def login_params
            params.require(:login).permit(:email, :password)
        end
end