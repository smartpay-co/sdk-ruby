require "rest-client"

RSpec.describe Smartpay::Api do
  before do
    Smartpay.configure do |config|
      config.public_key = ENV["SMARTPAY_PUBLIC_KEY"]
      config.secret_key = ENV["SMARTPAY_SECRET_KEY"]
    end
  end

  describe "coupon flow" do
    context "with valid request payload" do
      it "performs CRUD to coupon resource" do
        coupon = Smartpay::Api.create_coupon(
          {
            name: "integration-test from sdk-ruby",
            discountType: "percentage",
            discountPercentage: 50
          }
        )

        expect(coupon.response).not_to be_empty
        expect(coupon.response[:name]).to eq("integration-test from sdk-ruby")
        coupon_id = coupon.response[:id]

        expect(Smartpay::Api.update_coupon(coupon_id, { active: false }).http_code).to eq 200

        retrieved_coupon = Smartpay::Api.get_coupon(coupon_id)
        expect(retrieved_coupon.response[:active]).to eq false

        expect(Smartpay::Api.get_coupons(max_results: 3).as_hash[:maxResults]).to be 3
      end
    end

    context "with a active coupon" do
      before do
        coupon = Smartpay::Api.create_coupon(
          {
            name: "integration-test from sdk-ruby",
            discountType: "percentage",
            discountPercentage: 50
          }
        )
        @coupon_id = coupon.response[:id]
      end

      it "performs CRUD to promotion-code resource" do
        promotion_code = Smartpay::Api.create_promotion_code(
          {
            code: "TEST_COUPON_RUBY_#{Time.now.to_i}",
            coupon: @coupon_id
          }
        )
        expect(promotion_code.response).not_to be_empty
        expect(promotion_code.http_code).to eq 200
        promotion_code_id = promotion_code.response[:id]

        expect(Smartpay::Api.update_promotion_code(promotion_code_id, { active: false }).http_code).to eq 200

        retrieved_promotion_code = Smartpay::Api.get_promotion_code(promotion_code_id)
        expect(retrieved_promotion_code.response[:active]).to eq false

        expect(Smartpay::Api.get_promotion_codes(max_results: 3).as_hash[:maxResults]).to be 3
      end
    end
  end

end
