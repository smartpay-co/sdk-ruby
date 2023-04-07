# frozen_string_literal: true

module Smartpay
  module Requests
    # PaymentUpdate
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
