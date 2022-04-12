# frozen_string_literal: true

module Smartpay
  module Requests
    class Payment
      attr_accessor :payload

      REQUIREMENT_KEY_NAME = [:order, :amount, :currency].freeze

      def initialize(raw_payload)
        @payload = raw_payload.transform_keys(&:to_sym)
      end

      def as_hash
        check_requirement!
        normalize_payload
      end

      private

      def check_requirement!
        REQUIREMENT_KEY_NAME.each do |key_name|
          raise Errors::InvalidRequestPayloadError, key_name unless payload.include?(key_name)
        end
      end

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
