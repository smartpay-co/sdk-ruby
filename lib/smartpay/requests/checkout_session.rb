# frozen_string_literal: true

require_relative "validator"
require_relative "normalizer"

module Smartpay
  module Requests
    # Request Object to create a CheckoutSession for order
    class CheckoutSession
      include Validator
      include Normalizer

      attr_accessor :payload

      REQUIREMENT_KEY_NAME = %i[successUrl cancelUrl customerInfo shippingInfo currency items].freeze

      def initialize(raw_payload)
        @payload = raw_payload.transform_keys(&:to_sym)
      end

      def as_hash
        check_requirement!(REQUIREMENT_KEY_NAME)
        normalize_payload
      end

      private

      def normalize_payload
        normalized = {
          customerInfo: normalize_customer_info(payload[:customerInfo] || {}),
          captureMethod: payload[:captureMethod],
          currency: payload[:currency],
          description: payload[:description],
          shippingInfo: normalize_shipping(payload[:shippingInfo], payload[:currency]),
          items: normalize_items(payload[:items]),
          locale: payload[:locale],
          metadata: payload[:metadata] || {},
          reference: payload[:reference],
          successUrl: payload[:successUrl],
          cancelUrl: payload[:cancelUrl]
        }

        normalized[:amount] = get_total_amount(normalized)

        normalized
      end


    end
  end
end
