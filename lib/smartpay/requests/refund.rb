# frozen_string_literal: true

module Smartpay
  module Requests
    class Refund
      attr_accessor :payload

      REQUIREMENT_KEY_NAME = [:payment, :amount, :currency].freeze

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
          payment: payload.dig(:payment),
          amount: payload.dig(:amount),
          currency: payload.dig(:currency),
          reason: payload.dig(:reason),
          reference: payload.dig(:reference),
          description: payload.dig(:description),
          metadata: payload.dig(:metadata) || {},
        }
      end
    end
  end
end
