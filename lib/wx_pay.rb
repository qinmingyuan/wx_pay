require 'wx_pay/result'
require 'wx_pay/sign'
require 'wx_pay/service'
require 'wx_pay/version'
require 'openssl'
require 'zeitwerk'
require 'active_support/configurable'
#loader = Zeitwerk::Loader.for_gem
#loader.setup # ready!

module WxPay
  include ActiveSupport::Configurable
  extend self

  def set_apiclient_by_pkcs12(str, pass)
    pkcs12 = OpenSSL::PKCS12.new(str, pass)
    @apiclient_cert = pkcs12.certificate
    @apiclient_key = pkcs12.key

    pkcs12
  end

  def apiclient_cert=(cert)
    @apiclient_cert = OpenSSL::X509::Certificate.new(cert)
  end

  def apiclient_key=(key)
    @apiclient_key = OpenSSL::PKey::RSA.new(key)
  end

  configure do |config|
    config.sandbox = false
    config.pid = nil
    config.appid = nil
    config.target_id = nil
    config.oauth_url = 'https://openauth.alipay.com/oauth2/appToAppAuth.htm'
    config.oauth_callback = nil
    config.return_url = nil
    config.notify_url = nil
    config.return_rsa = ''
    config.rsa2_path = 'config/alipay_rsa2.pem'
  end

end
