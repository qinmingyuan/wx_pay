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
          Time.now.to_i,
          SecureRandom.uuid.tr('-', ''),
          body
        ].join("\n") + "\n"

        sign(options[:key], str)
      end

      def sign(key, string)
        digest = OpenSSL::Digest::SHA256.new
        pkey = OpenSSL::PKey::RSA.new(key)
        signature = pkey.sign(digest, string)

        Base64.strict_encode64(signature)
      end

    end
  end
end
