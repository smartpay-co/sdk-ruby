# frozen_string_literal: true

module Smartpay
  class Configuration
    attr_accessor :post_timeout
    attr_accessor :public_key, :secret_key, :api_url, :checkout_url

    DEFAULT_TIMEOUT_SETTING = 30
    DEFAULT_API_URL = 'https://api.smartpay.co'
    DEFAULT_CHECKOUT_URL = 'https://checkout.smartpay.co'

    def initialize
      @post_timeout = DEFAULT_TIMEOUT_SETTING
      @api_url = DEFAULT_API_URL
      @checkout_url = DEFAULT_CHECKOUT_URL
    end
  end
end
