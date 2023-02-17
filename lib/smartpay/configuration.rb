# frozen_string_literal: true

require "rest-client"

module Smartpay
  # Smartpay configuration
  class Configuration
    attr_accessor :public_key, :secret_key, :request_timeout, :api_url, :retry_options

    DEFAULT_TIMEOUT_SETTING = 30
    DEFAULT_API_URL = "https://api.smartpay.co/v1"
    DEFAULT_RETRY_OPTIONS = {
      max_tries: 1,
      base_sleep_seconds: 0.5,
      max_sleep_seconds: 1.0,
      rescue: [RestClient::InternalServerError,RestClient::BadGateway,
               RestClient::ServiceUnavailable, RestClient::GatewayTimeout]
    }.freeze

    def initialize
      reset
    end

    def reset
      @request_timeout = DEFAULT_TIMEOUT_SETTING
      @api_url = ENV.fetch("SMARTPAY_API_PREFIX", DEFAULT_API_URL).downcase
      @retry_options = DEFAULT_RETRY_OPTIONS
      @request_timeout = DEFAULT_TIMEOUT_SETTING
      @public_key = ENV.fetch("SMARTPAY_PUBLIC_KEY", nil)
      @secret_key = ENV.fetch("SMARTPAY_SECRET_KEY", nil)
    end
  end
end
