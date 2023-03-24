# frozen_string_literal: true

module Smartpay
  module Requests
    # PromotionCodeUpdate
    class PromotionCodeUpdate
      attr_accessor :payload

      def initialize(raw_payload)
        @payload = raw_payload.transform_keys(&:to_sym)
      end

      def as_hash
        normalize_payload
      end

      private

      def normalize_payload
        {
          active: payload[:active],
          metadata: payload[:metadata] || {}
        }
      end
    end
  end
end
