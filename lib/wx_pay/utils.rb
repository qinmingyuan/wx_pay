module WxPay
  module Utils
    extend self

    def replace(string, params = {})
      string.scan(/{\w+}/).map do |match|
        r = match[1..-2]
        next unless params.key?(r.to_sym)
        string.gsub!(match, params.delete(r.to_sym).to_s)
      end

      string
    end

    def query(path, params = {})
      query = params.map do |k, v|
        "#{k}=#{v}" if v.to_s != ''
      end.join('&')
      if query.present?
        [path, query].join('?')
      else
        path
      end
    end

  end
end
