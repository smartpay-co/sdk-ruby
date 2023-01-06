# frozen_string_literal: true

module Smartpay
  class Api
    class << self
      def create_checkout_session(payload)
        return create_checkout_session_for_token(payload) if payload[:mode] == "token"

        Responses::CheckoutSession.new(
          Client.post("/checkout-sessions", params: {}, payload: Requests::CheckoutSession.new(payload).as_hash)
        )
      end

      def create_checkout_session_for_token(payload)
        Responses::CheckoutSession.new(
          Client.post("/checkout-sessions", params: {}, payload: Requests::CheckoutSessionForToken.new(payload).as_hash)
        )
      end

      def create_order(payload)
        Responses::Base.new(
          Client.post("/orders", params:{}, payload: Requests::Order.new(payload).as_hash)
        )
      end

      def get_orders(page_token: nil, max_results: nil, expand: '' )
        Responses::Base.new(Client.get("/orders", params: { pageToken: page_token, maxResults: max_results, expand: expand }))
      end

      def get_order(id, expand: '' )
        Responses::Base.new(Client.get("/orders/%s" % id, params: { expand: expand }))
      end

      def cancel_order(id)
        Responses::Base.new(
          Client.put("/orders/%s/cancellation" % id)
        )
      end

      def create_payment(payload)
        Responses::Base.new(
          Client.post("/payments", params:{}, payload: Requests::Payment.new(payload).as_hash)
        )
      end

      def capture(payload)
        create_payment(payload)
      end

      def get_payment(id, expand: '' )
        Responses::Base.new(Client.get("/payments/%s" % id, params: { expand: expand }))
      end

      def create_refund(payload)
        Responses::Base.new(
          Client.post("/refunds", params:{}, payload: Requests::Refund.new(payload).as_hash)
        )
      end

      def refund(payload)
        create_refund(payload)
      end

      def get_refund(id, expand: '' )
        Responses::Base.new(Client.get("/refunds/%s" % id, params: { expand: expand }))
      end

    end
  end
end
