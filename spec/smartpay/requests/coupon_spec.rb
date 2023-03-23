require "spec_helper"

RSpec.describe Smartpay::Requests::Coupon do
  subject { Smartpay::Requests::Coupon.new(request) }

  describe "#as_hash" do
    context "when the raw_payload does not contain name" do
      let(:request) do
        {
          currency: "JPY",
          discountType: "percentage",
          discountPercentage: 50
        }
      end

      it { expect { subject.send(:as_hash) }.to raise_error(Smartpay::Errors::InvalidRequestPayloadError) }
    end

    context "when discountType is not percentage nor amount" do
      let(:request) do
        {
          currency: "JPY",
          discountType: "test",
          name: "test"
        }
      end

      it { expect { subject.send(:as_hash) }.to raise_error(Smartpay::Errors::InvalidRequestPayloadError) }
    end

    context "when discountType is percentage" do
      let(:request) do
        {
          currency: "JPY",
          discountType: "percentage",
          name: "test"
        }
      end

      it "raises exception when discountPercentage is not given" do
        expect { subject.send(:as_hash) }.to raise_error(Smartpay::Errors::InvalidRequestPayloadError)
      end
    end

    context "when discountType is amount" do
      let(:request) do
        {
          currency: "JPY",
          discountType: "amount",
          name: "test"
        }
      end

      it "raises exception when discountAmount is not given" do
        expect { subject.send(:as_hash) }.to raise_error(Smartpay::Errors::InvalidRequestPayloadError)
      end
    end
  end

  describe "#normalize_payload" do
    let(:request) do
      {
        currency: "JPY",
        discountType: "percentage",
        discountPercentage: 50,
        name: "test"
      }
    end

    it "removes extra fields" do
      expect(subject.send(:normalize_payload)).to eq(
        {
          currency: "JPY",
          discountType: "percentage",
          discountPercentage: 50,
          discountAmount: nil,
          expiresAt: nil,
          maxRedemptionCount: nil,
          metadata: {},
          name: "test"
        })
    end
  end

end
