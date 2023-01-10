require "spec_helper"

RSpec.describe Smartpay::Requests::CheckoutSessionForToken do
  subject { Smartpay::Requests::CheckoutSessionForToken.new(request) }

  describe "#initialize" do
    context "when the mode in raw_payload is not token" do
      it { expect { Smartpay::Requests::CheckoutSessionForToken.new({}) }.to raise_error(Smartpay::Errors::InvalidRequestPayloadError) }
    end
  end

  describe "#check_requirement!" do
    context "when the raw_payload is not contained successUrl" do
      let(:request) { {:mode => 'token'} }

      it { expect { subject.send(:check_requirement!, subject.class::REQUIREMENT_KEY_NAME) }.to raise_error(Smartpay::Errors::InvalidRequestPayloadError) }
    end
  end

  describe "#normalize_payload" do
    let(:request) do
      {
        mode: "token",
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
        reference: "order_ref_1234567",
        successUrl: "https://docs.smartpay.co/example-pages/checkout-successful",
        cancelUrl: "https://docs.smartpay.co/example-pages/checkout-canceled",
        test: true
      }
    end

    it "removes extra fields" do
      expect(subject.send(:normalize_payload)).to eq({
        mode: 'token',
        locale: nil,
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

end
