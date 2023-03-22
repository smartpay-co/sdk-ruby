# frozen_string_literal: true

module Smartpay
  class Api
    class << self
      def create_checkout_session(payload, idempotency_key: nil)
        return create_checkout_session_for_token(payload, idempotency_key: idempotency_key) if payload[:mode] == "token"

        Responses::CheckoutSession.new(
          Client.post("/checkout-sessions", params: {}, payload: Requests::CheckoutSession.new(payload).as_hash, idempotency_key: idempotency_key)
        )
      end

      def create_checkout_session_for_token(payload, idempotency_key: nil)
        Responses::CheckoutSession.new(
          Client.post("/checkout-sessions", params: {}, payload: Requests::CheckoutSessionForToken.new(payload).as_hash, idempotency_key: idempotency_key)
        )
      end

      def get_checkout_session(id, expand: "")
        Responses::Base.new(Client.get("/checkout-sessions/%s" % id, params: { expand: expand }))
      end

      def get_checkout_sessions(page_token: nil, max_results: nil, expand: "")
        Responses::Base.new(Client.get("/checkout-sessions", params: { pageToken: page_token, maxResults: max_results, expand: expand }))
      end

      def create_order(payload, idempotency_key: nil)
        Responses::Base.new(
          Client.post("/orders", params: {}, payload: Requests::Order.new(payload).as_hash, idempotency_key: idempotency_key)
        )
      end

      def get_orders(page_token: nil, max_results: nil, expand: "")
        Responses::Base.new(Client.get("/orders", params: { pageToken: page_token, maxResults: max_results, expand: expand }))
      end

      def get_order(id, expand: "")
        Responses::Base.new(Client.get("/orders/%s" % id, params: { expand: expand }))
      end

      def cancel_order(id, idempotency_key: nil)
        Responses::Base.new(
          Client.put("/orders/%s/cancellation" % id, idempotency_key: idempotency_key)
        )
      end

      def create_payment(payload, idempotency_key: nil)
        Responses::Base.new(
          Client.post("/payments", params: {}, payload: Requests::Payment.new(payload).as_hash, idempotency_key: idempotency_key)
        )
      end

      def capture(payload, idempotency_key: nil)
        create_payment(payload, idempotency_key: idempotency_key)
      end

      def get_payment(id, expand: "")
        Responses::Base.new(Client.get("/payments/%s" % id, params: { expand: expand }))
      end

      def create_refund(payload, idempotency_key: nil)
        Responses::Base.new(
          Client.post("/refunds", params: {}, payload: Requests::Refund.new(payload).as_hash, idempotency_key: idempotency_key)
        )
      end

      def refund(payload, idempotency_key: nil)
        create_refund(payload, idempotency_key: idempotency_key)
      end

      def get_refund(id, expand: "")
        Responses::Base.new(Client.get("/refunds/%s" % id, params: { expand: expand }))
      end

      def get_tokens(page_token: nil, max_results: nil)
        Responses::Base.new(Client.get("/tokens", params: { pageToken: page_token, maxResults: max_results }))
      end

      def get_token(id)
        Responses::Base.new(Client.get("/tokens/%s" % id))
      end

      def enable_token(id, idempotency_key: nil)
        Responses::Base.new(Client.put("/tokens/%s/enable" % id, idempotency_key: idempotency_key))
      end

      def disable_token(id, idempotency_key: nil)
        Responses::Base.new(Client.put("/tokens/%s/disable" % id, idempotency_key: idempotency_key))
      end

      def delete_token(id, idempotency_key: nil)
        Responses::Base.new(Client.delete("/tokens/%s" % id, idempotency_key: idempotency_key))
      end
    end
  end
end
