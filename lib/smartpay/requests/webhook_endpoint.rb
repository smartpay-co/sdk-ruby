# frozen_string_literal: true

module Smartpay
  module Requests
    # WebhookEndpoint
    class WebhookEndpoint
      include Validator

      attr_accessor :payload

      REQUIREMENT_KEY_NAME = %i[url].freeze
      ALLOWED_EVENT_SUBSCRIPTIONS_VALUES = [
        "order.authorized",
        "order.rejected",
        "order.canceled",
        "payment.created",
        "refund.created",
        "payout.generated",
        "payout.paid",
        "coupon.created",
        "coupon.updated",
        "promotion_code.created",
        "promotion_code.updated",
        "merchant_user.created",
        "merchant_user.password_reset",
        "token.approved",
        "token.rejected",
        "token.deleted",
        "token.disabled",
        "token.enabled",
        "token.created",
        "token.used"
      ].freeze

      def initialize(raw_payload)
        @payload = raw_payload.transform_keys(&:to_sym)
      end

      def as_hash
        check_requirement!(REQUIREMENT_KEY_NAME)
        validate_event_subscription
        normalize_payload
      end

      protected

      def validate_event_subscription
        return unless payload[:eventSubscriptions]
        
        payload[:eventSubscriptions].each do |event|
          unless ALLOWED_EVENT_SUBSCRIPTIONS_VALUES.include?(event)
            raise Errors::InvalidRequestPayloadError, "eventSubscriptions.#{event}"
          end
        end
      end

      private

      def normalize_payload
        {
          description: payload[:description],
          eventSubscriptions: payload[:eventSubscriptions],
          metadata: payload[:metadata],
          url: payload[:url]
        }
      end
    end
  end
end
