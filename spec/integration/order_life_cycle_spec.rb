require "rest-client"

RSpec.describe Smartpay::Api do
  before do
    Smartpay.configure do |config|
      config.public_key = ENV["SMARTPAY_PUBLIC_KEY"]
      config.secret_key = ENV["SMARTPAY_SECRET_KEY"]
    end
  end

  describe ".lifecycle_of_order" do
    context "with valid request payload" do
      it do
        session = Smartpay::Api.create_checkout_session({
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

          reference: "order_ref_1234567",
          successUrl: "https://docs.smartpay.co/example-pages/checkout-successful",
          cancelUrl: "https://docs.smartpay.co/example-pages/checkout-canceled"
        })

        expect(session.response).not_to be_empty
        expect(session.redirect_url).not_to be_empty

        retrieved_checkout_session = Smartpay::Api.get_checkout_session(session.response[:id])
        expect(retrieved_checkout_session.response[:order]).to eq(session.response[:order][:id])

        list_checkout_sessions = Smartpay::Api.get_checkout_sessions(max_results: 3)
        expect(list_checkout_sessions.response[:maxResults]).to eq(3)

        order_id = session.response[:order][:id]
        PAYMENT_AMOUNT = 150

        login_payload = {
          emailAddress: ENV["TEST_USERNAME"],
          password: ENV["TEST_PASSWORD"]
        }

        login_response = RestClient::Request.execute(method: :post, url: "https://#{ENV['API_BASE']}/consumers/auth/login",
                                                     timeout: Smartpay.configuration.request_timeout,
                                                     headers: {
                                                 accept: :json,
                                                 content_type: :json
                                               },
                                                     payload: login_payload.to_json)
        login_response_data = JSON.parse(login_response.body, symbolize_names: true)
        access_token = login_response_data[:accessToken]

        authorization_payload = {
          paymentMethod: "pm_test_visaApproved",
          paymentPlan: "pay_in_three"
        }

        authorization_response = RestClient::Request.execute(method: :post, url: "https://#{ENV['API_BASE']}/orders/#{order_id}/authorizations",
                                                             timeout: Smartpay.configuration.request_timeout,
                                                             headers: {
            accept: :json,
            content_type: :json,
            Authorization: "Bearer #{access_token}"
          },
                                                             payload: authorization_payload.to_json)

        payment1 = Smartpay::Api.create_payment({
          order: order_id,
          amount: PAYMENT_AMOUNT,
          currency: "JPY",
          cancel_remainder: "manual"
        })

        payment2 = Smartpay::Api.capture({
          order: order_id,
          amount: PAYMENT_AMOUNT,
          currency: "JPY",
          cancel_remainder: "manual"
        })

        expect(payment1.as_hash[:id]).not_to be_empty
        expect(payment2.as_hash[:id]).not_to be_empty
        expect(payment2.as_hash[:amount]).to eq PAYMENT_AMOUNT

        Smartpay::Api.update_payment(payment2.as_hash[:id], { reference: "test" })

        retrieved_payment_2 = Smartpay::Api.get_payment(payment2.as_hash[:id])

        expect(retrieved_payment_2.as_hash[:id]).to eq payment2.as_hash[:id]
        expect(retrieved_payment_2.as_hash[:amount]).to eq PAYMENT_AMOUNT
        expect(retrieved_payment_2.as_hash[:reference]).to eq "test"

        list_payments = Smartpay::Api.get_payments(max_results: 3)
        expect(list_payments.response[:maxResults]).to eq(3)

        REFUND_AMOUNT = 1

        order = Smartpay::Api.get_order(order_id)
        refundable_payment = order.as_hash[:payments][0]

        refund1 = Smartpay::Api.create_refund({
          payment: refundable_payment,
          amount: REFUND_AMOUNT,
          currency: "JPY",
          reason: Smartpay::REJECT_REQUEST_BY_CUSTOMER
        })

        refund2 = Smartpay::Api.refund({
          payment: refundable_payment,
          amount: REFUND_AMOUNT + 1,
          currency: "JPY",
          reason: Smartpay::REJECT_REQUEST_BY_CUSTOMER
        })

        expect(refund1.as_hash[:amount]).to eq REFUND_AMOUNT
        expect(refund2.as_hash[:amount]).to eq REFUND_AMOUNT + 1

        Smartpay::Api.update_refund(refund2.as_hash[:id], { reference: "test" })

        retrieved_refund2 = Smartpay::Api.get_refund(refund2.as_hash[:id])

        expect(retrieved_refund2.as_hash[:id]).to eq refund2.as_hash[:id]
        expect(retrieved_refund2.as_hash[:amount]).to eq REFUND_AMOUNT + 1
        expect(retrieved_refund2.as_hash[:reference]).to eq "test"

        list_refunds = Smartpay::Api.get_refunds(max_results: 3)
        expect(list_refunds.response[:maxResults]).to eq(3)

      end
    end

    context "cancel an order" do
      it do
        session = Smartpay::Api.create_checkout_session({
          currency: "JPY",
          items: [
            {
              name: "オリジナルス STAN SMITH",
              amount: 250,
              currency: "JPY",
              quantity: 1
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

          reference: "order_ref_1234567",
          successUrl: "https://docs.smartpay.co/example-pages/checkout-successful",
          cancelUrl: "https://docs.smartpay.co/example-pages/checkout-canceled"
        })

        expect(session.response).not_to be_empty
        expect(session.redirect_url).not_to be_empty

        order_id = session.response[:order][:id]

        login_payload = {
          emailAddress: ENV["TEST_USERNAME"],
          password: ENV["TEST_PASSWORD"]
        }

        login_response = RestClient::Request.execute(method: :post, url: "https://#{ENV['API_BASE']}/consumers/auth/login",
                                                     timeout: Smartpay.configuration.request_timeout,
                                                     headers: {
                                                 accept: :json,
                                                 content_type: :json
                                               },
                                                     payload: login_payload.to_json)
        login_response_data = JSON.parse(login_response.body, symbolize_names: true)
        access_token = login_response_data[:accessToken]

        authorization_payload = {
          paymentMethod: "pm_test_visaApproved",
          paymentPlan: "pay_in_three"
        }

        authorization_response = RestClient::Request.execute(method: :post, url: "https://#{ENV['API_BASE']}/orders/#{order_id}/authorizations",
                                                             timeout: Smartpay.configuration.request_timeout,
                                                             headers: {
            accept: :json,
            content_type: :json,
            Authorization: "Bearer #{access_token}"
          },
                                                             payload: authorization_payload.to_json)

        result = Smartpay::Api.cancel_order(order_id);

        expect(result.as_hash[:status]).to eq "canceled"
      end
    end

  end

  describe ".get_orders" do
    context "with valid params" do
      it do
        orders = Smartpay::Api.get_orders(
          max_results: 3
        )
        expect(orders.response).not_to be_empty
        expect(orders.response[:maxResults]).to be 3
      end
    end
  end
end
