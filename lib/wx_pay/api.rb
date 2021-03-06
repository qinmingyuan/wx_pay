require 'httpx'
require 'wx_pay/api/v3'

module WxPay
  module Api
    AUTH = 'WECHATPAY2-SHA256-RSA2048'
    BASE = 'https://api.mch.weixin.qq.com'.freeze
    include V3
    extend self

    def execute(method, path, params, options = {})
      method.upcase!
      path = Utils.replace(path, params)
      path = Utils.query(path, params) if method == 'GET'

      options[:nonce_str] ||= SecureRandom.uuid.tr('-', '')
      options[:timestamp] ||= Time.now.to_i
      options[:signature] = sign_params(method, path, params, options)

      url = BASE + path
      opts = {
        headers: common_headers(params, options)
      }
      if method != 'GET'
        opts.merge! body: params.to_json
      end

      JSON.parse HTTPX.request(method, url, **opts).body
    end

    def generate_js_pay_req(params, options = {})
      opts = {
        appId: options[:appid],
        package: "prepay_id=#{params.delete(:prepayid)}",
        signType: 'RSA'
      }
      opts.merge! params
      opts[:timeStamp] ||= Time.now.to_i.to_s
      opts[:nonceStr] ||= SecureRandom.uuid.tr('-', '')
      opts[:paySign] = WxPay::Sign.generate_sign(opts)
      opts
    end

    def prepare_params(method, path, params, options)
      result = {}
      result.merge! signature: sign_params(method, path, params, options)
      result
    end

    def common_headers(params, options)
      r = {
        mchid: options[:mchid],
        serial_no: options[:serial_no],
        nonce_str: options[:nonce_str],
        timestamp: options[:timestamp],
        signature: options[:signature]
      }.map(&->(k,v){ "#{k}=\"#{v}\"" }).join(',')
      {
        Authorization: [AUTH, r].join(' '),
        'Content-Type': 'application/json',
        Accept: 'application/json'
      }
    end

    def sign_params(method, path, params, options)
      Sign::Rsa.generate(method, path, params, options)
    end

  end
end
