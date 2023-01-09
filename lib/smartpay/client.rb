# frozen_string_literal: true

require "rest-client"
require "retries"
require "securerandom"

module Smartpay
  class Client
    class << self
      def get(path, params: {})
        request_params = default_params.merge(params)
        RestClient::Request.execute(method: :get, url: api_url(path),
                                               headers: headers.merge(params: request_params),
                                               timeout: timeout)
      end

      def post(path, params: {}, payload: {})
        request_params = default_params.merge(params)
        request_payload = default_payload.merge(payload)
        idempotency_key = nonce
        with_retries(:max_tries => 1, :rescue => [RestClient::BadRequest, RestClient::BadGateway, RestClient::ServiceUnavailable, RestClient::GatewayTimeout]) do
          RestClient::Request.execute(method: :post, url: api_url(path),
                                                params: request_params,
                                                headers: headers.merge({Idempotency_Key: idempotency_key}).merge(params: request_params),
                                                timeout: timeout,
                                                payload: request_payload.to_json)
        end
      end

      def put(path, params: {}, payload: {})
        request_params = default_params.merge(params).merge({'Idempotency-Key': nonce})
        request_payload = default_payload.merge(payload)
        idempotency_key = nonce
        with_retries(:max_tries => 1, :rescue => [RestClient::InternalServerError, RestClient::BadGateway, RestClient::ServiceUnavailable, RestClient::GatewayTimeout]) do
          RestClient::Request.execute(method: :put, url: api_url(path),
                                                params: request_params,
                                                headers: headers.merge({Idempotency_Key: idempotency_key}).merge(params: request_params),
                                                timeout: timeout,
                                                payload: request_payload.to_json)
        end
      end

      def delete(path, params: {})
        request_params = default_params.merge(params).merge({'Idempotency-Key': nonce})
        idempotency_key = nonce
        with_retries(:max_tries => 1, :rescue => [RestClient::InternalServerError, RestClient::BadGateway, RestClient::ServiceUnavailable, RestClient::GatewayTimeout]) do
          RestClient::Request.execute(method: :delete, url: api_url(path),
                                                params: request_params,
                                                headers: headers.merge({Idempotency_Key: idempotency_key}).merge(params: request_params),
                                                timeout: timeout)
        end
      end

      private

      def nonce 
        SecureRandom.hex
      end

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

      def default_params
        {
          'dev-lang': :ruby,
          'sdk-version': Smartpay::VERSION
        }.freeze
      end

      def default_payload
        {}.freeze
      end
    end
  end
end
