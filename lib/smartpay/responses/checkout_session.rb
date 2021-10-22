# frozen_string_literal: true

module Smartpay
  module Responses
    class CheckoutSession
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def redirect_url
        URI.escape("#{checkout_url}/login?session-id=#{response[:id]}&public-key=#{public_key}")
      end

      private

      def checkout_url
        Smartpay.configuration.checkout_url
      end

      def public_key
        Smartpay.configuration.public_key
      end
    end
  end
end
