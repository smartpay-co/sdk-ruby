require 'spec_helper'

RSpec.describe Smartpay::Api do
  describe '.create_checkout_session' do
    it do
      expect(Smartpay::Client).to receive(:post).with('/checkout/sessions', {}).once
      expect(Smartpay::Api.create_checkout_session({})).to be_an_instance_of(Smartpay::Responses::CheckoutSession)
    end
  end
end
