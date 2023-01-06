require "rest-client"

RSpec.describe Smartpay::Api do
  before do
    Smartpay.configure do |config|
      config.public_key = ENV["SMARTPAY_PUBLIC_KEY"]
      config.secret_key = ENV["SMARTPAY_SECRET_KEY"]
    end
  end

  describe "token flow" do
    context "with valid request payload" do
      it 'compltes the whole token flow' do
        session = Smartpay::Api.create_checkout_session_for_token(
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
                line1: "北青山 3-6-7",
                line2: "青山パラシオタワー 11階",
                subLocality: "",
                locality: "港区",
                administrativeArea: "東京都",
                postalCode: "107-0061",
                country: "JP"
              },
              dateOfBirth: "1985-06-30",
              gender: "male"
            },
            reference: "order_ref_1234567",
            successUrl: "https://docs.smartpay.co/example-pages/checkout-successful",
            cancelUrl: "https://docs.smartpay.co/example-pages/checkout-canceled"
          }
        )

        expect(session.response).not_to be_empty
        expect(session.redirect_url).not_to be_empty

        token_id = session.response[:token][:id]

        login_payload = {
          emailAddress: ENV["TEST_USERNAME"],
          password: ENV["TEST_PASSWORD"]
        }

        login_response = RestClient::Request.execute(
          method: :post,
          url: "https://#{ENV['API_BASE']}/consumers/auth/login",
          timeout: Smartpay.configuration.post_timeout,
          headers: {
            accept: :json,
            content_type: :json
          },
          payload: login_payload.to_json
        )
        login_response_data = JSON.parse(login_response.body, symbolize_names: true)
        access_token = login_response_data[:accessToken]

        RestClient::Request.execute(
          method: :put,
          url: "https://#{ENV['API_BASE']}/tokens/#{token_id}/approve",
          timeout: Smartpay.configuration.post_timeout,
          headers: {
            accept: :json,
            content_type: :json,
            Authorization: "Bearer #{access_token}"
          }
        )

        order_resp = Smartpay::Api.create_order(
          {
            token: token_id,
            currency: "JPY",
            items: [
              {
                name: "オリジナルス STAN SMITH",
                amount: 1000,
                currency: "JPY",
                quantity: 1
              },
              {
                currency: "JPY",
                amount: 500,
                name: "Merchant special discount",
                kind: "discount"
              },
              {
                currency: "JPY",
                amount: 100,
                name: "explicit taxes",
                kind: "tax"
              }
            ],
            customerInfo: {
              accountAge: 20,
              email: "merchant-support@smartpay.co",
              firstName: "田中",
              lastName: "太郎",
              firstNameKana: "たなか",
              lastNameKana: "たろう",
              address: {
                line1: "北青山 3-6-7",
                line2: "青山パラシオタワー 11階",
                subLocality: "",
                locality: "港区",
                administrativeArea: "東京都",
                postalCode: "107-0061",
                country: "JP"
              },
              dateOfBirth: "1985-06-30",
              gender: "male"
            },
            shippingInfo: {
              address: {
                line1: "北青山 3-6-7",
                line2: "青山パラシオタワー 11階",
                subLocality: "",
                locality: "港区",
                administrativeArea: "東京都",
                postalCode: "107-0061",
                country: "JP"
              },
              feeAmount: 100,
              feeCurrency: "JPY"
            },

            captureMethod: "manual",

            reference: "order_ref_1234567"
          }
        )

        expect(order_resp.response).not_to be_empty
        expect(order_resp.as_hash[:object]).to eq "order"
        expect(order_resp.as_hash[:id]).not_to be_empty

        expect(Smartpay::Api.get_token(token_id).as_hash[:id]).to eq token_id
        expect(Smartpay::Api.get_tokens(max_results: 3).as_hash[:maxResults]).to be 3
        expect(Smartpay::Api.disable_token(token_id).http_code).to eq 200
        expect(Smartpay::Api.enable_token(token_id).http_code).to eq 200
        expect(Smartpay::Api.delete_token(token_id).http_code).to eq 204
      end


    end
  end

end
