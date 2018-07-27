require 'apartment/elevators/generic'
require 'jwt'

module JWTElevator
    class JWTElevator < Apartment::Elevators::Generic
        def parse_tenant_name(request)
            hmac_secret = 'hTsyqVwuX492AeIa0XOyOTz3rQuWCEWv'
            authorization = request.get_header('HTTP_AUTHORIZATION') if request.has_header?('HTTP_AUTHORIZATION')
            if (authorization.nil?) 
                return nil
            end
            token = authorization[7..-1]
            decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
            decoded_token[0]['username']
        end

    end
end