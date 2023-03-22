# frozen_string_literal: true

# PaymentUpdate
module Smartpay
  module Requests
    class PaymentUpdate
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
          reference: payload[:reference],
          description: payload[:description],
          metadata: payload[:metadata] || {}
        }
      end
    end
  end
end
