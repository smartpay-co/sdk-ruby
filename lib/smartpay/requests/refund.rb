# frozen_string_literal: true

module Smartpay
  module Requests
    # Refund
    class Refund
      include Validator

      attr_accessor :payload

      REQUIREMENT_KEY_NAME = %i[payment amount currency].freeze

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
          payment: payload[:payment],
          amount: payload[:amount],
          currency: payload[:currency],
          reason: payload[:reason],
          reference: payload[:reference],
          description: payload[:description],
          metadata: payload[:metadata] || {}
        }
      end
    end
  end
end
