require 'spec_helper'

RSpec.describe Smartpay::Api do
  describe '.create_checkout_session' do
    it do
      expect(Smartpay::Client).to receive(:post).with('/checkout/sessions', kind_of(Hash)).once
      expect(Smartpay::Api.create_checkout_session({
        successURL: "https://docs.smartpay.co/example-pages/checkout-successful",
        cancelURL: "https://docs.smartpay.co/example-pages/checkout-canceled"
      })).to be_an_instance_of(Smartpay::Responses::CheckoutSession)
    end
  end
end
