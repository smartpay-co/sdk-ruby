# frozen_string_literal: true

module Smartpay
  class Api
    class << self
      def create_checkout_session(payload)
        Responses::CheckoutSession.new(Client.post('/checkout/sessions', payload))
      end
    end
  end
end
