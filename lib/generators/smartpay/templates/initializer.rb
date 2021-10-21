# frozen_string_literal: true

Smartpay.configure do |config|
  config.api_url = 'https://api.smartpay.co/smartpayments'
  config.checkout_url = 'https://checkout.smartpay.co'
  config.public_api_key = 'pk_test_'
  config.private_api_key = 'sk_test_'
end
