# frozen_string_literal: true

require "rest-client"
require "retries"
require "securerandom"

module Smartpay
  class Client
    class << self
      def get(path, params: {})
        request_params = default_params.merge(params)
        with_retries(retry_options) do
          RestClient::Request.execute(
            method: :get,
            url: api_url(path),
            headers: headers.merge(params: request_params),
            timeout: timeout
          )
        end
      end

      def post(path, params: {}, payload: {}, idempotency_key: nil)
        request(:post, path, params: params, payload: payload, idempotency_key: idempotency_key)
      end

      def put(path, params: {}, payload: {}, idempotency_key: nil)
        request(:put, path, params: params, payload: payload, idempotency_key: idempotency_key)
      end

      def patch(path, params: {}, payload: {}, idempotency_key: nil)
        request(:patch, path, params: params, payload: payload, idempotency_key: idempotency_key)
      end

      def delete(path, params: {}, idempotency_key: nil)
        request(:delete, path, params: params, idempotency_key: idempotency_key)
      end

      private

      def request(method, path, params: {}, payload: {}, idempotency_key: nil)
        request_params = default_params.merge(params)
        request_payload = default_payload.merge(payload)
        idempotency_key ||= nonce
        with_retries(retry_options) do
          RestClient::Request.execute(
            method: method,
            url: api_url(path),
            headers: headers.merge({ Idempotency_Key: idempotency_key }).merge(params: request_params),
            timeout: timeout,
            payload: request_payload.to_json
          )
        end
      end

      def nonce 
        SecureRandom.hex
      end

      def api_url(path)
        "#{Smartpay.configuration.api_url}#{path}"
      end

      def timeout
        Smartpay.configuration.request_timeout
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

      def default_params
        {
          'dev-lang': :ruby,
          'sdk-version': Smartpay::VERSION
        }.freeze
      end

      def retry_options
        Smartpay.configuration.retry_options
      end

      def default_payload
        {}.freeze
      end
    end
  end
end
