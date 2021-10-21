require 'spec_helper'

RSpec.describe Smartpay::Responses::CheckoutSession do
  describe '#redirect_url' do
    subject { Smartpay::Responses::CheckoutSession.new(response) }

    let(:response) { JSON.parse(File.read("./spec/fixtures/checkout_session.json"), symbolize_names: true) }

    before do
      Smartpay.configuration.checkout_url  = 'https://checkout.smartpay.test'
      Smartpay.configuration.public_api_key  = 'pk_test_1234'
    end

    it do
      expect(subject.redirect_url).to eq(
        'https://checkout.smartpay.test/login?session-id=checkout_test_oTQpCvZzZ52UvKbrN5i4B8&public-key=pk_test_1234'
      )
    end
  end
end
