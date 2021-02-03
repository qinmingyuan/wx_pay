require 'wx_pay/result'
require 'wx_pay/sign'
require 'wx_pay/service'
require 'wx_pay/version'
require 'openssl'
require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup # ready!

module WxPay
  extend self
  @extra_rest_client_options = {}
  @debug_mode = true
  @sandbox_mode = false

  attr_accessor :appid, :mch_id, :key, :appsecret, :extra_rest_client_options, :debug_mode
  attr_accessor :sandbox_mode, :manual_get_sandbox_key
  attr_reader :apiclient_cert, :apiclient_key

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

  def debug_mode?
    @debug_mode
  end

  def sandbox_mode?
    @sandbox_mode
  end

  def manual_get_sandbox_key?
    @manual_get_sandbox_key
  end

end
