# frozen_string_literal: true

module Smartpay
  module Responses
    class CheckoutSession
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def redirect_url(options = {})
        url = "#{checkout_url}/login"
        qs = "session-id=#{URI.encode_www_form_component(response[:id])}&public-key=#{URI.encode_www_form_component(public_key)}"
        
        "#{url}?#{qs}"
      end

      def as_hash
        @response
      end

      def as_json
        @response.to_json
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
