# frozen_string_literal: true

module Smartpay
  class Api
    class << self
      def create_checkout_session(payload)
        Responses::CheckoutSession.new(
          Client.post("/checkout-sessions", Requests::CheckoutSession.new(payload).as_hash)
        )
      end

      def get_orders(page_token: '', limit: 20)
        Responses::Base.new(Client.get("/orders", { pageToken: page_token, maxResults: limit }))
      end
    end
  end
end
