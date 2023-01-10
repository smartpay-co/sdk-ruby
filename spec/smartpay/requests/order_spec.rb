require "spec_helper"

RSpec.describe Smartpay::Requests::Order do
  subject { Smartpay::Requests::Order.new(request) }

  describe "#check_requirement!" do
    context "when the raw_payload is not contained token" do
      let(:request) { {} }

      it { expect { subject.send(:check_requirement!, subject.class::REQUIREMENT_KEY_NAME) }.to raise_error(Smartpay::Errors::InvalidRequestPayloadError) }
    end
  end

  describe "#normalize_payload" do
    let(:request) do
      {
        token: "token_abc",
        amount: 350,
        currency: "JPY",
        items: [{
          name: "オリジナルス STAN SMITH",
          amount: 250,
          currency: "JPY",
          quantity: 1
        }],
        customerInfo: {
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
        shippingInfo: {
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

    it "fixes the shippingInfo field name" do
      expect(subject.send(:normalize_payload)).to eq(
        {
          token: "token_abc",
          amount: 350,
          captureMethod: nil,
          currency: "JPY",
          items: [{
            quantity: 1,
            kind: nil,
            label: nil,
            description: nil,
            productDescription: nil,
            priceDescription: nil,
            metadata: nil,
            productMetadata: nil,
            priceMetadata: nil,
            amount: 250,
            currency: "JPY",
            brand: nil,
            categories: nil,
            gtin: nil,
            images: nil,
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
          metadata: {},
          reference: "order_ref_1234567",
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
          }
        }
      )
    end

    it "fixes the amount after the shippingInfo field name got fixed" do
      request[:amount] = nil
      subject = Smartpay::Requests::Order.new(request)

      expect(subject.send(:normalize_payload)).to eq(
        {
          token: "token_abc",
          amount: 350,
          captureMethod: nil,
          currency: "JPY",
          items: [{
            quantity: 1,
            kind: nil,
            label: nil,
            description: nil,
            productDescription: nil,
            priceDescription: nil,
            metadata: nil,
            productMetadata: nil,
            priceMetadata: nil,
            amount: 250,
            currency: "JPY",
            brand: nil,
            categories: nil,
            gtin: nil,
            images: nil,
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
          metadata: {},
          reference: "order_ref_1234567",
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
          }
        }
      )
    end
  end

  describe "#normalize_customer_info" do
    let(:request) { {} }

    context "when argument is nil" do
      it { expect(subject.send(:normalize_customer_info, nil)).to be nil }
    end

    context "when argument is not nil" do
      it do
        expect(subject.send(:normalize_customer_info, { email: "success@smartpay.co" })).to eq(
          {
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
          }
        )
      end
    end
  end

  describe "#normalize_shipping" do
    let(:request) { {} }

    context "when argument is nil" do
      it { expect(subject.send(:normalize_shipping, nil)).to be nil }
    end

    context "when argument is not nil" do
      it do
        expect(subject.send(:normalize_shipping, { line1: "line1" })).to eq(
          {
            address:
              {
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
          }
        )
      end
    end
  end

  describe "#normalize_items" do
    let(:request) { {} }

    context "when argument is nil" do
      it { expect(subject.send(:normalize_items, nil)).to eq([]) }
    end

    context "when argument is not nil" do
      it do
        expect(subject.send(:normalize_items, [{ quantity: 1 }])).to eq([{
          quantity: 1,
          kind: nil,
          description: nil,
          productDescription: nil,
          priceDescription: nil,
          metadata: nil,
          productMetadata: nil,
          priceMetadata: nil,
          label: nil,
          amount: nil,
          currency: nil,
          brand: nil,
          categories: nil,
          gtin: nil,
          images: nil,
          name: nil,
          reference: nil,
          url: nil
        }])
      end
    end

    context "with different kinds" do
      it "keeps the original behavior" do
        expect(subject.send(:normalize_items, [
          {
            name: "abc",
            amount: 1000,
            currency: "JPY",
            quantity: 1
          }
        ])).to eq([{
          quantity: 1,
          kind: nil,
          description: nil,
          productDescription: nil,
          priceDescription: nil,
          metadata: nil,
          productMetadata: nil,
          priceMetadata: nil,
          label: nil,
          amount: 1000,
          currency: "JPY",
          brand: nil,
          categories: nil,
          gtin: nil,
          images: nil,
          name: "abc",
          reference: nil,
          url: nil
        }])
      end

      it "supports discount" do
        expect(subject.send(:normalize_items, [
          {
            currency: "JPY",
            amount: 500,
            name: "abc",
            kind: "discount"
          }
        ])).to eq([{
          quantity: nil,
          description: nil,
          productDescription: nil,
          priceDescription: nil,
          metadata: nil,
          productMetadata: nil,
          priceMetadata: nil,
          label: nil,
          amount: 500,
          currency: "JPY",
          brand: nil,
          categories: nil,
          gtin: nil,
          images: nil,
          name: "abc",
          reference: nil,
          url: nil,
          kind: "discount"
        }])
      end

      it "supports tax" do
        expect(subject.send(:normalize_items, [
          {
            currency: "JPY",
            amount: 100,
            name: "abc",
            kind: "tax"
          }
        ])).to eq([{
          quantity: nil,
          description: nil,
          productDescription: nil,
          priceDescription: nil,
          metadata: nil,
          productMetadata: nil,
          priceMetadata: nil,
          label: nil,
          amount: 100,
          currency: "JPY",
          brand: nil,
          categories: nil,
          gtin: nil,
          images: nil,
          name: "abc",
          reference: nil,
          url: nil,
          kind: "tax"
        }])
      end
    end

    describe "#get_total_amount" do
      let(:request) do
        {
          currency: "JPY",
          items: [{
            name: "オリジナルス STAN SMITH",
            amount: 1000,
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
          shippingInfo: {
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

      context "new line items" do
        it 'calculates tax' do
          request[:items] << {
            currency: "JPY",
            amount: 100,
            name: "abc",
            kind: "tax"
          }
          subject = Smartpay::Requests::Order.new(request)
          expect(subject.send(:get_total_amount, request)).to eq(1200)
        end

        it 'calculates discount' do
          request[:items] << {
            currency: "JPY",
            amount: 100,
            name: "abc",
            kind: "discount"
          }
          subject = Smartpay::Requests::Order.new(request)
          expect(subject.send(:get_total_amount, request)).to eq(1000)
        end
      end
    end
  end
end
