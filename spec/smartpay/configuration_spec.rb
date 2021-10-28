require 'spec_helper'

RSpec.describe Smartpay::Configuration do
  describe '.post_timeout' do
    let(:config) { Smartpay::Configuration.new }

    context 'when set post_timeout to nil' do
      before { config.post_timeout = nil }

      it 'fallbacks to default setting' do
        expect(config.post_timeout).to eq(Smartpay::Configuration::DEFAULT_TIMEOUT_SETTING)
      end
    end

    context 'when set post_timeout to 20' do
      before { config.post_timeout = 20 }

      it 'can override the default setting' do
        expect(config.post_timeout).to eq(20)
      end
    end
  end

  describe '.api_url' do
    let(:config) { Smartpay::Configuration.new }

    context 'when set api_url to nil' do
      before { config.api_url = nil }

      it 'fallbacks to default setting' do
        expect(config.api_url).to eq(Smartpay::Configuration::DEFAULT_API_URL)
      end
    end

    context 'when environment has set SMARTPAY_API_PREFIX' do
      context 'when variable include the string `api.smartpay`' do
        before do
          config.api_url = nil
          ENV['SMARTPAY_API_PREFIX'] = 'https://API.smartpay.co/from_env'
        end

        after { ENV['SMARTPAY_API_PREFIX'] = nil }

        it 'can override the default setting' do
          expect(config.api_url).to eq('https://api.smartpay.co/from_env')
        end
      end

      context 'when variable does not include the string `api.smartpay`' do
        before do
          config.api_url = nil
          ENV['SMARTPAY_API_PREFIX'] = 'https://somewhere.co/from_env'
        end

        after { ENV['SMARTPAY_API_PREFIX'] = nil }

        it 'should fallback to the default setting' do
          expect(config.api_url).to eq('https://api.smartpay.co/v1')
        end
      end
    end

    context 'when set api_url to new api url' do
      before { config.api_url = 'https://api.smartpay.co/v2' }

      it 'can override the default setting' do
        expect(config.api_url).to eq('https://api.smartpay.co/v2')
      end
    end
  end

  describe '.checkout_url' do
    let(:config) { Smartpay::Configuration.new }

    context 'when set checkout_url to nil' do
      before { config.checkout_url = nil }

      it 'fallbacks to default setting' do
        expect(config.checkout_url).to eq(Smartpay::Configuration::DEFAULT_CHECKOUT_URL)
      end
    end

    context 'when set checkout_url to new api url' do
      before { config.checkout_url = 'https://checkout.smartpay.co/v2' }

      it 'can override the default setting' do
        expect(config.checkout_url).to eq('https://checkout.smartpay.co/v2')
      end
    end
  end
end
