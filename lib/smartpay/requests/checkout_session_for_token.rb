# frozen_string_literal: true

require_relative "validator"
require_relative "normalizer"

module Smartpay
  module Requests
    # Request Object to create a CheckoutSession for token
    class CheckoutSessionForToken
      include Validator
      include Normalizer

      attr_accessor :payload

      REQUIREMENT_KEY_NAME = %i[successUrl cancelUrl customerInfo mode].freeze

      def initialize(raw_payload)
        @payload = raw_payload.transform_keys(&:to_sym)
        raise Errors::InvalidRequestPayloadError, "mode" unless payload[:mode] == "token"
      end

      def as_hash
        check_requirement!(REQUIREMENT_KEY_NAME)
        normalize_payload
      end

      private

      def normalize_payload
        {
          mode: payload[:mode],
          customerInfo: normalize_customer_info(payload[:customerInfo] || {}),
          metadata: payload[:metadata] || {},
          locale: payload[:locale],
          reference: payload[:reference],
          successUrl: payload[:successUrl],
          cancelUrl: payload[:cancelUrl]
        }
      end

    end
  end
end
