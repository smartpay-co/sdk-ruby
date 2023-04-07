# frozen_string_literal: true

module Smartpay
  module Requests
    # Coupon
    class Coupon
      include Validator

      attr_accessor :payload

      REQUIREMENT_KEY_NAME = %i[discountType name].freeze
      AVAILABLE_DISCOUNT_TYPES = %w[percentage amount].freeze

      def initialize(raw_payload)
        @payload = raw_payload.transform_keys(&:to_sym)
      end

      def as_hash
        check_requirement!(REQUIREMENT_KEY_NAME)
        raise Errors::InvalidRequestPayloadError, :discountType unless AVAILABLE_DISCOUNT_TYPES.include?(payload[:discountType])
        raise Errors::InvalidRequestPayloadError, :discountPercentage if payload[:discountType] == "percentage" && !payload[:discountPercentage]
        raise Errors::InvalidRequestPayloadError, :discountAmount if payload[:discountType] == "amount" && !payload[:discountAmount]

        normalize_payload
      end

      private

      def normalize_payload
        {
          currency: payload[:currency],
          discountAmount: payload[:discountAmount],
          discountPercentage: payload[:discountPercentage],
          discountType: payload[:discountType],
          expiresAt: payload[:expiresAt],
          maxRedemptionCount: payload[:maxRedemptionCount],
          metadata: payload[:metadata] || {},
          name: payload[:name]
        }
      end
    end
  end
end
