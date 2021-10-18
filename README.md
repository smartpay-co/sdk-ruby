# Smartpay

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/smartpay`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add the latest version of Smartpay to your project's dependencies:

    $ bundle add smartpay

Or, you can add this line to your application's Gemfile and specify the version restriction:

```ruby
gem 'smartpay', "~> 0.1.0"
```

And then execute:

    $ bundle install

## Usage for Ruby on Rails

After installed the gem package, you can generate relevant files with:

    $ bundle exec rails generate smartpay:install

This will introduce 4 changes, including a simple example for checkout session flow:

1. Add new initializer in `config/initializers/smartpay.rb`
2. Add controller to `app/controllers/smartpays_controller.rb`
3. Add view to `app/views/smartpays/index.html.erb`
4. Add routes to `config/routes.rb` for checkout session

### Setup Server Credentials

Make sure you have the credentials (API key & secret) from Smartpay before you can have a working integration.
You can find your credentials at the `settings > credentials` page on your [dashboard](https://merchant.smartpay.co/settings/credentials).

Update your API key and secret to the fields `public_key` and `api_secret` in `config/initializers/smartpay.rb`.

### Test with Checkout Session

Start your server and navigate to `http://localhost:3000/smartpays`.

Click the `checkout` button to be redirected to the Checkout page.

Replace any of these test accounts to the field `customerInfo.emailAddress` of request payload in `app/controllers/smartpays_controller.rb` to simulate a payment.

1. Payment succeeds: `success@smartpay.co`
2. Payment requires authentication: `auth.required@smartpay.co`
3. Payment is declined: `declined@smartpay.co`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/smartpay. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/smartpay/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Smartpay project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/smartpay/blob/master/CODE_OF_CONDUCT.md).
