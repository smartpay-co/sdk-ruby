# frozen_string_literal: true

Smartpay.configure do |config|
  config.api_url = 'https://api.smartpay.re/smartpayments'
  config.checkout_url = 'https://checkout.smartpay.re'
  config.public_key = 'pk_test_'
  config.api_secret = 'sk_test_'
end
