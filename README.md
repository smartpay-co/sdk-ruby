# Smartpay

The Smartpay Ruby library offers easy access to Smartpay API from applications written in Ruby.

## Requirements

- Ruby 2.6+
- Smartpay `API keys & secrets`. You can find your credential at the `settings > credentials` page on your [dashboard](https://dashboard.smartpay.co/settings/credentials).

## Installation

Add the latest version of Smartpay to your project's dependencies:

```sh
gem install Smartpay
```

If you want to build the gem yourself from source:

```sh
gem build smartpay.gemspec
```

### Bundler

If you are installing via bundler, make sure that you use the `https` resource in your Gemfile to avoid the risk of gems being compromised:

```
source 'https://rubygems.org'

gem 'smartpay'
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

1. A new initializer - `config/initializers/smartpay.rb`. You will have to update the `config.public_key` and `config.api_secret` with your own credentials to make this work.
2. A new controller - `app/controllers/smartpays_controller.rb`. This is where you can see how a Checkout session is configured & created.
3. A new view - `app/views/smartpays/index.html.erb`. The minimum frontend required.
4. A new route in config/routes.rb.

#### Start your server

```sh
bundle exec rails server
```

### Test with Checkout Session

Visit [http://localhost:3000/smartpays](http://localhost:3000/smartpays).

Click the `checkout` button on the page to be redirected to Smartpay's Checkout.

To try out different cases, all you need to do is to update the `customerInfo.emailAddress` in `app/controllers/smartpays_controller.rb` with the following test emails:

- Payment succeeds: `success@smartpay.co`
- Payment requires authentication: `auth.required@smartpay.co`
- Payment is declined: `declined@smartpay.co`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/smartpay. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/smartpay/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Smartpay project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/smartpay/blob/master/CODE_OF_CONDUCT.md).
