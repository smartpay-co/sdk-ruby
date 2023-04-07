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

      def get_payments(page_token: nil, max_results: nil, expand: "")
        Responses::Base.new(Client.get("/payments", params: { pageToken: page_token, maxResults: max_results, expand: expand }))
      end

      def update_payment(id, payload, idempotency_key: nil)
        Responses::Base.new(
          Client.patch("/payments/%s" % id, payload: Requests::PaymentUpdate.new(payload).as_hash, idempotency_key: idempotency_key)
        )
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

      def get_refunds(page_token: nil, max_results: nil, expand: "")
        Responses::Base.new(Client.get("/refunds", params: { pageToken: page_token, maxResults: max_results, expand: expand }))
      end

      def update_refund(id, payload, idempotency_key: nil)
        Responses::Base.new(
          Client.patch("/refunds/%s" % id, payload: Requests::RefundUpdate.new(payload).as_hash, idempotency_key: idempotency_key)
        )
      end

      def create_coupon(payload, idempotency_key: nil)
        Responses::Base.new(
          Client.post("/coupons", params: {}, payload: Requests::Coupon.new(payload).as_hash, idempotency_key: idempotency_key)
        )
      end

      def get_coupon(id)
        Responses::Base.new(Client.get("/coupons/%s" % id))
      end

      def get_coupons(page_token: nil, max_results: nil)
        Responses::Base.new(Client.get("/coupons", params: { pageToken: page_token, maxResults: max_results }))
      end

      def update_coupon(id, payload, idempotency_key: nil)
        Responses::Base.new(
          Client.patch("/coupons/%s" % id, payload: Requests::CouponUpdate.new(payload).as_hash, idempotency_key: idempotency_key)
        )
      end

      def create_promotion_code(payload, idempotency_key: nil)
        Responses::Base.new(
          Client.post("/promotion-codes", params: {}, payload: Requests::PromotionCode.new(payload).as_hash, idempotency_key: idempotency_key)
        )
      end

      def get_promotion_code(id)
        Responses::Base.new(Client.get("/promotion-codes/%s" % id))
      end

      def get_promotion_codes(page_token: nil, max_results: nil)
        Responses::Base.new(Client.get("/promotion-codes", params: { pageToken: page_token, maxResults: max_results }))
      end

      def update_promotion_code(id, payload, idempotency_key: nil)
        Responses::Base.new(
          Client.patch("/promotion-codes/%s" % id, payload: Requests::PromotionCodeUpdate.new(payload).as_hash, idempotency_key: idempotency_key)
        )
      end

      def create_webhook_endpoint(payload, idempotency_key: nil)
        Responses::Base.new(
          Client.post("/webhook-endpoints", params: {}, payload: Requests::WebhookEndpoint.new(payload).as_hash, idempotency_key: idempotency_key)
        )
      end

      def get_webhook_endpoint(id)
        Responses::Base.new(Client.get("/webhook-endpoints/%s" % id))
      end

      def get_webhook_endpoints(page_token: nil, max_results: nil)
        Responses::Base.new(Client.get("/webhook-endpoints", params: { pageToken: page_token, maxResults: max_results }))
      end

      def update_webhook_endpoint(id, payload, idempotency_key: nil)
        Responses::Base.new(
          Client.patch("/webhook-endpoints/%s" % id, payload: Requests::WebhookEndpointUpdate.new(payload).as_hash, idempotency_key: idempotency_key)
        )
      end

      def delete_webhook_endpoint(id)
        Responses::Base.new(
          Client.delete("/webhook-endpoints/%s" % id)
        )
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

      def delete_token(id)
        Responses::Base.new(Client.delete("/tokens/%s" % id))
      end
    end
  end
end
