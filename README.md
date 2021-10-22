# Smartpay Ruby Library

The Smartpay Ruby library offers easy access to Smartpay API from applications written in Ruby.

## Documentation

- [Payment Flow](https://docs.smartpay.co/#payment_flow)
- [API Document](https://api-doc.smartpay.co)

## Requirements

- Ruby 2.6+
- Smartpay `API keys & secrets`. You can find your credential at the `settings > credentials` page on your [dashboard](https://dashboard.smartpay.co/settings/credentials).

## Installation

If you use system built-in Ruby, you might need to be the `sudoer` to be able to `sudo` in some of the following steps. We recommend you to use either [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/) to have your own non-global Ruby to avoid potential permission issues.

Once you have your Ruby in place, add the latest version of Smartpay to your project's dependencies:

```sh
gem install smartpay
```

If you want to build the gem yourself from source:

```sh
gem build smartpay.gemspec
```

### Bundler

If you are installing via bundler, make sure that you use the `https` resource in your Gemfile to avoid the risk of gems being compromised:

```ruby
source 'https://rubygems.org'

gem 'smartpay'
```

## Usage

The package needs to be configured with your own API keys, you can find them on your [dashboard](https://dashboard.smartpay.co/settings/credentials).

```ruby
Smartpay.configure do |config|
  config.public_key = '<YOUR_PUBLIC_KEY>' # the one starts with pk_test_
  config.secret_key = '<YOUR_SECRET_KEY>' # the one starts with sk_test_
end
```

### Create Checkout session

You can find the description and requirement for request payload in [API Document](https://api-doc.smartpay.co/#8a3538b1-530c-448c-8bae-4a41cdf0b8fd).

```ruby
payloaad = {
  "customerInfo": {
    "emailAddress": "success@smartpay.co",
  },
  "orderData": {
    "amount": 250,
    "currency": "JPY",
    "shippingInfo": {
      "address": {
        "line1": "line1",
        "locality": "locality",
        "postalCode": "123",
        "country": "JP"
      },
    },
    "lineItemData": [{
      "priceData": {
        "productData": {
          "name": "レブロン 18 LOW",
        },
        "amount": 250,
        "currency": "JPY",
      },
      "quantity": 1
    }]
  },
  "reference": "order_ref_1234567",
  "successUrl": "https://docs.smartpay.co/example-pages/checkout-successful",
  "cancelUrl": "https://docs.smartpay.co/example-pages/checkout-canceled"
}
```

Create a checkout session by using `Smartpay::Api.create_checkout_session` with your request payload.

```ruby
session = Smartpay::Api.create_checkout_session(payload)
```

Then, you can redirect your customer to the session url by calling `redirect_url`:

```ruby
session.redirect_url
```

## Use with your favorite frameworks

### Ruby on Rails (RoR)

#### Install Rails

```sh
gem install rails
```

#### Create your app

```sh
rails new app-with-smartpay
```

#### Add Smartpay

```sh
cd app-with-smartpay
bundle add smartpay
```

#### Generator

```sh
bundle exec rails generate smartpay:install
```

This introduces 4 changes for a pre-built Smartpay Checkout example:

> 1. A new initializer - `config/initializers/smartpay.rb`. You will have to update the `config.public_key` and `config.secret_key` with your own credentials to make this work.
> 2. A new controller - `app/controllers/smartpays_controller.rb`. This is where you can see how a Checkout session is configured & created.
> 3. A new view - `app/views/smartpays/index.html.erb`. The minimum frontend required.
> 4. A new route in config/routes.rb.

#### Fill in your API keys

Edit the keys with your own credentials in `config/initializers/smartpay.rb`.

```ruby
  ...
  config.public_key = '<YOUR_PUBLIC_KEY>' # the one starts with pk_test_
  config.secret_key = '<YOUR_SECRET_KEY>' # the one starts with sk_test_
  ...
```

#### Start your server

```sh
bundle exec rails server
```

### Test with Checkout Session

Visit [http://localhost:3000/smartpays](http://localhost:3000/smartpays).

Click the `checkout` button on the page to be redirected to Smartpay's Checkout.

To try out different cases, you can use the following test credit cards for different cases:

- Payment succeeds: `4242 4242 4242 4242`
- Payment is declined: `4100 0000 0000 0019`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/smartpay. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/smartpay/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Smartpay project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/smartpay/blob/master/CODE_OF_CONDUCT.md).
