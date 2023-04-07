require "spec_helper"

RSpec.describe Smartpay::Requests::WebhookEndpointUpdate do
  subject { Smartpay::Requests::WebhookEndpointUpdate.new(request) }

  describe "#as_hash" do
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
