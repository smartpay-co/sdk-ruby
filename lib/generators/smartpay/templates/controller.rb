class SmartpaysController < ApplicationController
  def new
  end

  def create
    session = Smartpay::Api.create_checkout_session(
      {
        "customerInfo": {
          "emailAddress": "success@smartpay.co",
          "firstName": nil,
          "lastName": nil,
          "firstNameKana": nil,
          "lastNameKana": nil,
          "address": nil,
          "phoneNumber": nil,
          "dateOfBirth": nil,
          "legalGender": nil,
          "reference": nil
        },
        "orderData": {
          "amount": 250,
          "currency": "JPY",
          "captureMethod": nil,
          "confirmationMethod": nil,
          "coupons": nil,
          "shippingInfo": {
            "address": {
              "line1": "line1",
              "line2": nil,
              "line3": nil,
              "line4": nil,
              "line5": nil,
              "subLocality": nil,
             "locality": "locality",
              "administrativeArea": nil,
              "postalCode": "123",
              "country": "JP"},
              "addressType": nil},
              "lineItemData": [{
                "price": nil,
                "priceData": {
                  "productData": {
                    "name": "レブロン 18 LOW",
                    "brand": nil,
                    "categories": nil,
                    "description": nil,
                    "gtin": nil,
                    "images": nil,
                    "reference": nil,
                    "url": nil,
                    "metadata": nil},
                    "amount": 250,
                    "currency": "JPY",
                    "metadata": nil},
                    "quantity": 1,
                    "description": nil,
                    "metadata": nil
              }]
        },
        "reference": "order_ref_1234567",
        "metadata": nil,
        "successUrl": "https://docs.smartpay.co/example-pages/checkout-successful",
        "cancelUrl": "https://docs.smartpay.co/example-pages/checkout-canceled",
        "test": true
      })
    redirect_to session.redirect_url
  end
end
