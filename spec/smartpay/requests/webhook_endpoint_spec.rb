require "spec_helper"

RSpec.describe Smartpay::Requests::WebhookEndpoint do
  subject { Smartpay::Requests::WebhookEndpoint.new(request) }

  describe "#as_hash" do
    context "when the raw_payload does not contain url" do
      let(:request) do
        {}
      end

      it { expect { subject.send(:as_hash) }.to raise_error(Smartpay::Errors::InvalidRequestPayloadError) }
    end

    context "when the eventSubscriptions contains invalid event" do
      let(:request) do
        {
          url: "https://example.com",
          eventSubscriptions: ["invalid_event"]
        }
      end

      it { expect { subject.send(:as_hash) }.to raise_error(Smartpay::Errors::InvalidRequestPayloadError) }
    end
  end

end
