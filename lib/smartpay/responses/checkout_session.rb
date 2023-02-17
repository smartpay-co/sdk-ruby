# frozen_string_literal: true

module Smartpay
  module Responses
    class CheckoutSession < Base
      def redirect_url(options = {})
        url = response[:url]

        if options && options[:promotionCode]
          qs = "?promotion-code=#{options[:promotionCode]}"

          return "#{url}#{qs}"
        end

        url
      end
    end
  end
end
