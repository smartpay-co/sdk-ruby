require 'spec_helper'

RSpec.describe Smartpay::Requests::CheckoutSession do
  subject { Smartpay::Requests::CheckoutSession.new(request) }

  describe '#check_requirement!' do
    context 'when the raw_payload is not contained successUrl' do
      let(:request) { {} }

      it { expect { subject.send(:check_requirement!) }.to raise_error(Smartpay::Errors::InvalidRequestPayloadError) }
    end

    context 'when the raw_payload is not contained customerInfo' do
      let(:request) do
        {
          successUrl: 'https://docs.smartpay.co/example-pages/checkout-successful',
          cancelUrl: 'https://docs.smartpay.co/example-pages/checkout-canceled',
          currency: 'JPY',
          items: []
        }
      end

      it { expect { subject.send(:check_requirement!) }.not_to raise_error(Smartpay::Errors::InvalidRequestPayloadError) }
    end
  end

  describe '#normalize_payload' do
    let(:request) do
      {
        amount: 350,
        currency: "JPY",
        items: [{
          name: "オリジナルス STAN SMITH",
          amount: 250,
          currency: "JPY",
          quantity: 1
        }],
        customer: {
          accountAge: 20,
          email: "merchant-support@smartpay.co",
          firstName: "田中",
          lastName: "太郎",
          firstNameKana: "たなか",
          lastNameKana: "たろう",
          address: {
            line1: "3-6-7",
            line2: "青山パラシオタワー 11階",
            subLocality: "",
            locality: "港区北青山",
            administrativeArea: "東京都",
            postalCode: "107-0061",
            country: "JP"
          },
          dateOfBirth: "1985-06-30",
          gender: "male"
        },
        shipping: {
          line1: "line1",
          locality: "locality",
          postalCode: "123",
          country: "JP",
          feeAmount: 100
        },
        reference: "order_ref_1234567",
        successUrl: "https://docs.smartpay.co/example-pages/checkout-successful",
        cancelUrl: "https://docs.smartpay.co/example-pages/checkout-canceled",
        test: true
      }
    end

    it do
      expect(subject.send(:normalize_payload)).to eq({
        amount: 350,
        captureMethod: nil,
        currency: "JPY",
        items: [{
          quantity: 1,
          label: nil,
          description: nil,
          productDescription: nil,
          priceDescription: nil,
          metadata: nil,
          productMetadata: nil,
          priceMetadata: nil,
          amount: 250,
          currency: "JPY",
          metadata: nil,
          brand: nil,
          categories: nil,
          description: nil,
          gtin: nil,
          images: nil,
          metadata: nil,
          name: "オリジナルス STAN SMITH",
          reference: nil,
          url: nil
        }],
        shippingInfo: {
          address: {
            administrativeArea: nil,
            country: "JP",
            line1: "line1",
            line2: nil,
            line3: nil,
            line4: nil,
            line5: nil,
            locality: "locality",
            postalCode: "123",
            subLocality: nil
          },
          addressType: nil,
          feeAmount: 100,
          feeCurrency: "JPY"
        },
        description: nil,
        metadata: {},
        reference: "order_ref_1234567",
        successUrl: "https://docs.smartpay.co/example-pages/checkout-successful",
        cancelUrl: "https://docs.smartpay.co/example-pages/checkout-canceled",
        customerInfo: {
          accountAge: 20,
          address: {
            administrativeArea: "東京都",
            country: "JP",
            line1: "3-6-7",
            line2: "青山パラシオタワー 11階",
            locality: "港区北青山",
            postalCode: "107-0061",
            subLocality: ""
          },
          dateOfBirth: "1985-06-30",
          emailAddress: "merchant-support@smartpay.co",
          firstName: "田中",
          firstNameKana: "たなか",
          lastName: "太郎",
          lastNameKana: "たろう",
          legalGender: "male",
          phoneNumber: nil,
          reference: nil
        },
      })
    end
  end

  describe '#normalize_customer_info' do
    let(:request) { {} }

    context 'when argument is nil' do
      it { expect(subject.send(:normalize_customer_info, nil)).to be nil }
    end

    context 'when argument is not nil' do
      it do
        expect(subject.send(:normalize_customer_info, { email: 'success@smartpay.co' })).to eq({
          accountAge: nil,
          address: nil,
          dateOfBirth: nil,
          emailAddress: "success@smartpay.co",
          firstName: nil,
          firstNameKana: nil,
          lastName: nil,
          lastNameKana: nil,
          legalGender: nil,
          phoneNumber: nil,
          reference: nil
        })
      end
    end
  end

  describe '#normalize_shipping' do
    let(:request) { {} }

    context 'when argument is nil' do
      it { expect(subject.send(:normalize_shipping, nil)).to be nil }
    end

    context 'when argument is not nil' do
      it do
        expect(subject.send(:normalize_shipping, { line1: 'line1' })).to eq({
          address: {
            administrativeArea: nil,
            country: nil,
            line1: "line1",
            line2: nil,
            line3: nil,
            line4: nil,
            line5: nil,
            locality: nil,
            postalCode: nil,
            subLocality: nil
          },
          addressType: nil,
          feeAmount: nil,
          feeCurrency: nil
        })
      end
    end
  end

  describe '#normalize_items' do
    let(:request) { {} }

    context 'when argument is nil' do
      it { expect(subject.send(:normalize_items, nil)).to eq([]) }
    end

    context 'when argument is not nil' do
      it do
        expect(subject.send(:normalize_items, [{ quantity: 1 }])).to eq([{
          quantity: 1,
          description: nil,
          productDescription: nil,
          priceDescription: nil,
          metadata: nil,
          productMetadata: nil,
          priceMetadata: nil,
          label: nil,
          amount: nil,
          currency: nil,
          metadata: nil,
          brand: nil,
          categories: nil,
          description: nil,
          gtin: nil,
          images: nil,
          metadata: nil,
          name: nil,
          reference: nil,
          url: nil
        }])
      end
    end
  end
end
