# frozen_string_literal: true

require "rest-client"

module Smartpay
  class Client
    class << self
      def get(path, payload = {})
        request_payload = default_payload.merge(payload)
        response = RestClient::Request.execute(method: :get, url: api_url(path),
                                               headers: headers.merge(params: request_payload),
                                               timeout: timeout)
        JSON.parse(response.body, symbolize_names: true)
      end

      def post(path, payload = {})
        request_payload = default_payload.merge(payload)
        response = RestClient::Request.execute(method: :post, url: api_url(path), headers: headers, timeout: timeout,
                                               payload: request_payload.to_json)
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
          Authorization: "Basic #{secret_key}"
        }
      end

      def secret_key
        Smartpay.configuration.secret_key
      end

      def default_payload
        {
          'dev-lang': :ruby,
          'sdk-version': Smartpay::VERSION
        }.freeze
      end
    end
  end
end
