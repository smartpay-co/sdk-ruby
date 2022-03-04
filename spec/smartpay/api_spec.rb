require 'spec_helper'

RSpec.describe Smartpay::Api do
  describe '.create_checkout_session' do
    it do
      expect(Smartpay::Client).to receive(:post).with('/checkout-sessions', kind_of(Hash)).once
      expect(Smartpay::Api.create_checkout_session({
        successUrl: "https://docs.smartpay.co/example-pages/checkout-successful",
        cancelUrl: "https://docs.smartpay.co/example-pages/checkout-canceled",
        items: [],
        currency: 'JPY'
      })).to be_an_instance_of(Smartpay::Responses::CheckoutSession)
    end
  end

  describe '.get_orders' do
    it do
      expect(Smartpay::Client).to receive(:get).with('/orders', { page: 1, count: 20 }).once
      expect(Smartpay::Api.get_orders).to be_an_instance_of(Smartpay::Responses::Base)
    end
  end
end
