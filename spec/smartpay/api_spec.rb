require "spec_helper"

RSpec.describe Smartpay::Api do
  describe ".create_checkout_session" do
    it do
      expect(Smartpay::Client).to receive(:post).with("/checkout-sessions", kind_of(Hash)).once
      expect(Smartpay::Api.create_checkout_session({
              amount: 350,
              currency: "JPY",
              items: [{
                name: "オリジナルス STAN SMITH",
                amount: 250,
                currency: "JPY",
                quantity: 1
              }],
              shippingInfo: {
                line1: "line1",
                locality: "locality",
                postalCode: "123",
                country: "JP",
                feeAmount: 100
              },
              customerInfo: {},
              reference: "order_ref_1234567",
              successUrl: "https://docs.smartpay.co/example-pages/checkout-successful",
              cancelUrl: "https://docs.smartpay.co/example-pages/checkout-canceled",
              test: true
            })).to be_an_instance_of(Smartpay::Responses::CheckoutSession)
    end
  end

  describe ".get_orders" do
    it do
      expect(Smartpay::Client).to receive(:get).with("/orders", { params: { pageToken: nil, maxResults: nil, expand: "" } }).once
      expect(Smartpay::Api.get_orders).to be_an_instance_of(Smartpay::Responses::Base)
    end
  end
end
