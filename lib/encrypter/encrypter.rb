require 'bcrypt'
class Encrypter

    def self.encrypt_password(password)
        cipher = Hash.new
        cipher[:salt] = BCrypt::Engine.generate_salt
        cipher[:encrypted] = encrypt password, cipher[:salt]
        cipher
    end

    def self.encrypt(string_to_encrypt, salt)
        BCrypt::Engine.hash_secret(string_to_encrypt, salt)
    end

    def self.is_cipher_correct?(cipher, string)
        new_cipher = encrypt string, cipher[:salt]
        new_cipher == cipher[:encrypted]
    end

end