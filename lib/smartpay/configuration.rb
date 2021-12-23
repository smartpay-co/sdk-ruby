# frozen_string_literal: true

module Smartpay
  class Configuration
    attr_accessor :public_key, :secret_key
    attr_writer :post_timeout, :api_url, :checkout_url

    DEFAULT_TIMEOUT_SETTING = 30
    DEFAULT_API_URL = "https://api.smartpay.co/v1"
    DEFAULT_CHECKOUT_URL = "https://checkout.smartpay.co"

    def initialize
      @post_timeout = DEFAULT_TIMEOUT_SETTING
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
    end

    def post_timeout
      @post_timeout || DEFAULT_TIMEOUT_SETTING
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

    private

    def in_development_mode?
      ENV["SMARTPAY_API_PREFIX"].downcase.include?("api.smartpay") if ENV["SMARTPAY_API_PREFIX"].is_a?(String)
    end
  end
end
