# frozen_string_literal: true

require "rest-client"

module Smartpay
  class Configuration
    attr_accessor :public_key, :secret_key
    attr_writer :request_timeout, :api_url, :checkout_url, :retry_options

    DEFAULT_TIMEOUT_SETTING = 30
    DEFAULT_API_URL = "https://api.smartpay.co/v1"
    DEFAULT_CHECKOUT_URL = "https://checkout.smartpay.co"
    DEFAULT_RETRY_OPTIONS = {
      max_tries: 1,
      base_sleep_seconds: 0.5,
      max_sleep_seconds: 1.0,
      rescue: [RestClient::InternalServerError,RestClient::BadGateway,
               RestClient::ServiceUnavailable, RestClient::GatewayTimeout]
    }.freeze

    def initialize
      @request_timeout = DEFAULT_TIMEOUT_SETTING
      @api_url = if in_development_mode?
                   ENV["SMARTPAY_API_PREFIX"].downcase || DEFAULT_API_URL
                 else
                   DEFAULT_API_URL
                 end
      @checkout_url = if in_development_mode? && ENV["SMARTPAY_CHECKOUT_URL"].is_a?(String)
                        ENV["SMARTPAY_CHECKOUT_URL"].downcase || DEFAULT_CHECKOUT_URL
                      else
                        DEFAULT_CHECKOUT_URL
                      end
      @retry_options = DEFAULT_RETRY_OPTIONS
    end

    def request_timeout
      @request_timeout || DEFAULT_TIMEOUT_SETTING
    end

    def api_url
      if in_development_mode?
        @api_url || ENV["SMARTPAY_API_PREFIX"].downcase || DEFAULT_API_URL
      else
        @api_url || DEFAULT_API_URL
      end
    end

    def checkout_url
      @checkout_url || DEFAULT_CHECKOUT_URL
    end

    def retry_options
      @retry_options || DEFAULT_RETRY_OPTIONS
    end

    private

    def in_development_mode?
      ENV["SMARTPAY_API_PREFIX"].downcase.include?("api.smartpay") if ENV["SMARTPAY_API_PREFIX"].is_a?(String)
    end
  end
end
