require 'spec_helper'

RSpec.describe Smartpay::Responses::CheckoutSession do
  subject { Smartpay::Responses::CheckoutSession.new(response) }

  let(:response) { JSON.parse(File.read("./spec/fixtures/checkout_session.json"), symbolize_names: true) }

  before do
    Smartpay.configuration.checkout_url  = 'https://checkout.smartpay.test'
    Smartpay.configuration.public_key  = 'pk_test_1234'
  end

  describe '#redirect_url' do
    context 'without promotion code' do
      it do
        expect(subject.redirect_url).to eq(
          'https://checkout.smartpay.test/login?session-id=checkout_test_oTQpCvZzZ52UvKbrN5i4B8&public-key=pk_test_1234'
        )
      end
    end

    context 'with promotion code' do
      let(:response) { JSON.parse(File.read("./spec/fixtures/checkout_session_promotion.json"), symbolize_names: true) }

      describe '#redirect_url' do
        it do
          expect(subject.redirect_url).to eq(
            'https://checkout.smartpay.test/login?session-id=checkout_test_oTQpCvZzZ52UvKbrN5i4B8&public-key=pk_test_1234&promotion-code=ZOO'
          )
        end
      end
    end
  end

  describe '#as_hash' do
    it { expect(subject.as_hash).to be_a(Hash) }
  end

  describe '#as_json' do
    it { expect(subject.as_json).to be_a(String) }
  end
end
