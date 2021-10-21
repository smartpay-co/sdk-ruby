# frozen_string_literal: true

require 'rest-client'

module Smartpay
  class Client
    class << self
      def post(path, payload = {})
        response = RestClient::Request.execute(method: :post, url: api_url(path), headers: headers, timeout: timeout, payload: payload.to_json)
        JSON.parse(response.body, symbolize_names: true)
      end

      private

      def api_url(path)
        "#{Smartpay.configuration.api_url}#{path}"
      end

      def timeout
        Smartpay.configuration.post_timeout
      end

      def headers
        {
          accept: :json,
          content_type: :json,
          Authorization: "Basic #{private_api_key}"
        }
      end

      def private_api_key
        Smartpay.configuration.private_api_key
      end
    end
  end
end
