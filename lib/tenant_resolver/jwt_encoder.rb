#
#   This will solve the tenant on a 
#   per/request basis. The tenant will be
#   the user's username, which will be obtained
#   from the JWT.
#

require 'jwt'

class JWTEncoder
    def self.encode_token(user)
        hmac_secret = 'hTsyqVwuX492AeIa0XOyOTz3rQuWCEWv'
        payload = {
            full_name: user.first_name + user.last_name,
            username: "#{user.first_name + user.last_name}".downcase,
            email: user.email,
            exp: Time.now.to_i + 4 * 3600,
            iss: "Ruby Angular Issuer Co."
        }
        token = JWT.encode payload, hmac_secret, 'HS256'
        token
    end
end