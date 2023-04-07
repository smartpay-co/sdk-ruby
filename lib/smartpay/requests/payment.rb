# frozen_string_literal: true

module Smartpay
  module Requests
    # Payment
    class Payment
      include Validator

      attr_accessor :payload

      REQUIREMENT_KEY_NAME = %i[order amount currency].freeze

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
          order: payload.dig(:order),
          amount: payload.dig(:amount),
          currency: payload.dig(:currency),
          reference: payload.dig(:reference),
          cancelRemainder: payload.dig(:cancel_remainder),
          description: payload.dig(:description),
          metadata: payload.dig(:metadata) || {},
        }
      end
    end
  end
end
