require 'spec_helper'

RSpec.describe Smartpay::Api do
  before do
    Smartpay.configure do |config|
      config.public_key = ENV['SMARTPAY_PUBLIC_KEY']
      config.secret_key = ENV['SMARTPAY_SECRET_KEY']
    end
  end

  describe '.create_checkout_session' do
    context 'with valid request payload' do
      it do
        session = Smartpay::Api.create_checkout_session({
          items: [
            {
              name: 'オリジナルス STAN SMITH',
              amount: 250,
              currency: 'JPY',
              quantity: 1,
            },
          ],
          customer: {
            accountAge: 20,
            email: 'merchant-support@smartpay.co',
            firstName: '田中',
            lastName: '太郎',
            firstNameKana: 'たなか',
            lastNameKana: 'たろう',
            address: {
              line1: '北青山 3-6-7',
              line2: '青山パラシオタワー 11階',
              subLocality: '',
              locality: '港区',
              administrativeArea: '東京都',
              postalCode: '107-0061',
              country: 'JP',
            },
            dateOfBirth: '1985-06-30',
            gender: 'male',
          },
          shipping: {
            line1: '北青山 3-6-7',
            line2: '青山パラシオタワー 11階',
            subLocality: '',
            locality: '港区',
            administrativeArea: '東京都',
            postalCode: '107-0061',
            country: 'JP',
          },
          reference: 'order_ref_1234567',
          successURL: 'https://docs.smartpay.co/example-pages/checkout-successful',
          cancelURL: 'https://docs.smartpay.co/example-pages/checkout-canceled',
        })
        expect(session.response).not_to be_empty
        expect(session.redirect_url).not_to be_empty
      end
    end
  end

  describe '.get_orders' do
    context 'with valid params' do
      it do
        orders = Smartpay::Api.get_orders(
          page_token: 'cjPY2pcYqrjRybZOgW7cIfpNSfp9vnJlMn21K1wET4bqn5tpFUzyhe4SG4kzQtADU2H9gCUk624crc78mJb9x0F2pZjc',
          limit: 1,
        )
        expect(orders.response).not_to be_empty
        expect(orders.response[:data].size).to be 1
      end
    end
  end
end
