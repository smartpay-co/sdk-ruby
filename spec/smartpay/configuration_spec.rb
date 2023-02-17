require 'spec_helper'

RSpec.describe Smartpay::Configuration do
  describe '.request_timeout' do
    let(:config) { Smartpay::Configuration.new }

    context 'when set request_timeout to 20' do
      before { config.request_timeout = 20 }

      it 'can override the default setting' do
        expect(config.request_timeout).to eq(20)
      end
    end
  end

  describe '.api_url' do
    let(:config) { Smartpay::Configuration.new }

    context 'when environment has set SMARTPAY_API_PREFIX' do
      before do
        ENV['SMARTPAY_API_PREFIX'] = 'https://API.smartpay.co/from_env'
      end

      after { ENV['SMARTPAY_API_PREFIX'] = nil }

      it 'can override the default setting' do
        expect(config.api_url).to eq('https://api.smartpay.co/from_env')
      end
    end

    context 'when set api_url to new api url' do
      before { config.api_url = 'https://api.smartpay.co/v2' }

      it 'can override the default setting' do
        expect(config.api_url).to eq('https://api.smartpay.co/v2')
      end
    end
  end

  describe '.retry_options' do
    let(:config) { Smartpay::Configuration.new }

    context 'when set retry_options to {max_tries: 100}' do
      before { config.retry_options = { max_tries: 100 } }

      it 'can override the default setting' do
        expect(config.retry_options).to eq({ max_tries: 100 } )
      end
    end
  end

  describe '.public_key' do
    let(:config) { Smartpay::Configuration.new }

    context 'when environment has set SMARTPAY_PUBLIC_KEY' do
      before do
        ENV['SMARTPAY_PUBLIC_KEY'] = 'pub'
      end

      after { ENV['SMARTPAY_PUBLIC_KEY'] = nil }

      it 'can set the key from env' do
        expect(config.public_key).to eq('pub')
      end
    end

    context 'when set key to new key' do
      before { config.public_key = 'pub2' }

      it 'can override the setting' do
        expect(config.public_key).to eq('pub2')
      end
    end
  end

  describe '.secret_key' do
    let(:config) { Smartpay::Configuration.new }

    context 'when environment has set SMARTPAY_SECRET_KEY' do
      before do
        ENV['SMARTPAY_SECRET_KEY'] = 'sec'
      end

      after { ENV['SMARTPAY_SECRET_KEY'] = nil }

      it 'can set the key from env' do
        expect(config.secret_key).to eq('sec')
      end
    end

    context 'when set key to new key' do
      before { config.secret_key = 'sec2' }

      it 'can override the setting' do
        expect(config.secret_key).to eq('sec2')
      end
    end
  end
end
