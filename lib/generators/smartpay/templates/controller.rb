class SmartpaysController < ApplicationController
  def new
  end

  def create
    session = Smartpay::Api.create_checkout_session({
      items: [
        {
          name: "レブロン 18 LOW",
          amount: 250,
          currency: "JPY",
          quantity: 1,
        },
      ],

      shipping: {
        line1: "line1",
        locality: "locality",
        postalCode: "123",
        country: "JP",
      },
      reference: "order_ref_1234567",
      successURL: "https://docs.smartpay.co/example-pages/checkout-successful",
      cancelURL: "https://docs.smartpay.co/example-pages/checkout-canceled",
      test: true,
    })
    redirect_to session.redirect_url
  end
end
