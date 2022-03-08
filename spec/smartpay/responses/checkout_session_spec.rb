require 'spec_helper'

RSpec.describe Smartpay::Responses::CheckoutSession do
  subject { Smartpay::Responses::CheckoutSession.new(response) }

  let(:response) { JSON.parse(File.read("./spec/fixtures/checkout_session.json"), symbolize_names: true) }

  describe '#redirect_url' do
    context 'without promotion code' do
      it do
        expect(subject.redirect_url).to eq(
          'https://checkout.smartpay.co/checkout_test_oTQpCvZzZ52UvKbrN5i4B8'
        )
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
