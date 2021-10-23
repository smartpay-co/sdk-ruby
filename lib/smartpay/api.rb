# frozen_string_literal: true

module Smartpay
  class Api
    class << self
      def create_checkout_session(payload)
        Responses::CheckoutSession.new(
          Client.post('/checkout/sessions', Requests::CheckoutSession.new(payload).as_hash)
        )
      end
    end
  end
end
