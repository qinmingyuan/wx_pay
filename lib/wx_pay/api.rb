require 'httpx'
require 'wx_pay/api/v3'

module WxPay
  module Api
    BASE = 'https://api.mch.weixin.qq.com'.freeze
    include V3
    extend self

    def execute(method, path, params, options = {})
      params = prepare_params(params, options)

      url = BASE + path
      HTTPX.request(method, url, params)
    end

    def prepare_params(params, options)
      result = {}
      result.merge! common_params(options)
      result.merge! signature: sign_params(method, path, result)
      result
    end

    def sign_params(method, path, params)
      params[:sign_type] ||= 'RSA2'
      params[:sign] = Alipay2::Sign.generate(params)
      params
    end

  end
end
