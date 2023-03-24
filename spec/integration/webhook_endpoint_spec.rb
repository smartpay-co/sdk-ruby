require "rest-client"

RSpec.describe Smartpay::Api do
  before do
    Smartpay.configure do |config|
      config.public_key = ENV["SMARTPAY_PUBLIC_KEY"]
      config.secret_key = ENV["SMARTPAY_SECRET_KEY"]
    end
  end

  describe "webhook-endpoints API" do
    context "with valid request payload" do
      it "performs CRUD to webhook-endpoint resource" do
        webhook_endpoint = Smartpay::Api.create_webhook_endpoint(
          {
            url: "https://www.example.com/ruby-test",
            eventSubscriptions: %w[token.used token.created]
          }
        )

        expect(webhook_endpoint.response).not_to be_empty
        expect(webhook_endpoint.response[:url]).to eq("https://www.example.com/ruby-test")
        webhook_endpoint_id = webhook_endpoint.response[:id]

        expect(Smartpay::Api.update_webhook_endpoint(webhook_endpoint_id, { active: false }).http_code).to eq 200

        retrieved_webhook_endpoint = Smartpay::Api.get_webhook_endpoint(webhook_endpoint_id)
        expect(retrieved_webhook_endpoint.response[:active]).to eq false

        expect(Smartpay::Api.get_webhook_endpoints(max_results: 3).as_hash[:maxResults]).to be 3

        expect(Smartpay::Api.delete_webhook_endpoint(webhook_endpoint_id).http_code).to eq 204
      end
    end
  end
end
