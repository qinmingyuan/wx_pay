require 'openssl'

module WxPay
  module Sign
    module Rsa
      extend self

      def generate(method, path, params, options = {})
        if method.upcase! == 'GET'
          body = nil
        else
          body = params.to_json
        end

        str = [
          method.upcase,
          path,
          options[:timestamp],
          options[:nonce_str],
          body
        ].join("\n") + "\n"
        binding.pry
        sign(rsa2_key, str)
      end

      def sign(key, string)
        digest = OpenSSL::Digest::SHA256.new
        pkey = OpenSSL::PKey::RSA.new(key)
        signature = pkey.sign(digest, string)

        Base64.strict_encode64(signature)
      end

      def rsa2_key
        File.read(Rails.root.join 'config/apiclient_key.pem')
      end

    end
  end
end
