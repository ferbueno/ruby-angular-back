require 'digest/sha1'
require 'encrypter/encrypter'

class User < ApplicationRecord
    EMAIL_REGEX = /\A\S+@.+\.\S+\z/i
    validates :first_name, :presence => true
    validates :last_name, :presence => true
    validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
    validates :password, :presence => true

    before_create :perform_before_create
    after_create :create_tenant

    def perform_before_create
        encrypt_password
        create_username
    end

    def encrypt_password
        cipher = Encrypter.encrypt_password self.password
        self.salt, self.password = cipher.values_at(:salt, :encrypted)
    end

    def create_username
        self.username = "#{first_name}#{last_name}".downcase
    end

    private

        def create_tenant
            Apartment::Tenant.create(username)
        end
end
