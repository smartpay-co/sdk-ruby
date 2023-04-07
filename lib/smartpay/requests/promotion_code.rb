# frozen_string_literal: true

module Smartpay
  module Requests
    # PromotionCode
    class PromotionCode
      include Validator

      attr_accessor :payload

      REQUIREMENT_KEY_NAME = %i[code coupon].freeze

      def initialize(raw_payload)
        @payload = raw_payload.transform_keys(&:to_sym)
      end

      def as_hash
        check_requirement!(REQUIREMENT_KEY_NAME)
        normalize_payload
      end

      private

      def normalize_payload
        {
          active: payload[:active],
          code: payload[:code],
          coupon: payload[:coupon],
          currency: payload[:currency],
          expiresAt: payload[:expiresAt],
          firstTimeTransaction: payload[:firstTimeTransaction],
          maxRedemptionCount: payload[:maxRedemptionCount],
          metadata: payload[:metadata] || {},
          minimumAmount: payload[:minimumAmount],
          onePerCustomer: payload[:onePerCustomer]
        }
      end
    end
  end
end
