module WxPay
  module Api
    module V3
      APIS = {
        invoke_unifiedorder: {
          method: 'POST',
          path: '/v3/pay/transactions/jsapi',
          required: [:appid, :mchid, :description, :out_trade_no, :notify_url, :amount, :payer],
          optional: [:time_expire, :attach, :goods_tag, :detail, :scene_info]
        }
      }.freeze

      APIS.each do |key, api|
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def #{key}(params, options = {})
  
            #check_required_options(params, #{api[:required]}) 
            execute('#{api[:method]}', '#{api[:path]}', params, options)     
          end
        RUBY_EVAL
      end
    end
  end
end
