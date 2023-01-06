# frozen_string_literal: true

require "json"

require_relative "smartpay/version"
require_relative "smartpay/configuration"
require_relative "smartpay/client"
require_relative "smartpay/api"
require_relative "smartpay/errors/invalid_request_payload_error"
require_relative "smartpay/requests/checkout_session"
require_relative "smartpay/requests/checkout_session_for_token"
require_relative "smartpay/requests/payment"
require_relative "smartpay/requests/refund"
require_relative "smartpay/responses/base"
require_relative "smartpay/responses/checkout_session"

module Smartpay
  REJECT_REQUEST_BY_CUSTOMER = 'requested_by_customer'
  REJECT_FRAUDULENT = 'fraudulent'

  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Smartpay::Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
