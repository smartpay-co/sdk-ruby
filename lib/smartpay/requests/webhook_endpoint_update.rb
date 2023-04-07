# frozen_string_literal: true

module Smartpay
  module Requests
    # WebhookEndpointUpdate
    class WebhookEndpointUpdate < WebhookEndpoint

      def as_hash
        validate_event_subscription
        normalize_payload
      end

      private

      def normalize_payload
        {
          active: payload[:active],
          description: payload[:description],
          eventSubscriptions: payload[:eventSubscriptions],
          metadata: payload[:metadata],
          url: payload[:url]
        }
      end
    end
  end
end
