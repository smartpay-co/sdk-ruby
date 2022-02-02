# frozen_string_literal: true

module Smartpay
  module Requests
    class CheckoutSession
      attr_accessor :payload

      REQUIREMENT_KEY_NAME = [:successURL, :cancelURL, :customerInfo, :orderData].freeze
      CAN_FALLBACK_KEYS = [:customerInfo, :orderData].freeze

      def initialize(raw_payload)
        @payload = raw_payload.transform_keys(&:to_sym)
      end

      def as_hash
        check_requirement!
        normalize_payload
      end

      private

      def check_requirement!
        REQUIREMENT_KEY_NAME.each do |key_name|
          next if CAN_FALLBACK_KEYS.include?(key_name)
          raise Errors::InvalidRequestPayloadError, key_name unless payload.include?(key_name)
        end
      end

      def normalize_payload
        currency = get_currency
        total_amount = get_total_amount
        shippingInfo = payload.dig(:shippingInfo) || normalize_shipping(payload.dig(:shipping))
        shippingInfo[:feeCurrency] = currency if shippingInfo && shippingInfo[:feeCurrency].nil? && !(shippingInfo[:feeAmount].nil?)

        {
          customerInfo: normalize_customer_info(payload.dig(:customerInfo) || payload.dig(:customer) || {}),
          orderData: normalize_order_data(payload.dig(:orderData) || {
            amount: total_amount,
            currency: currency,
            captureMethod: payload.dig(:captureMethod),
            confirmationMethod: payload.dig(:confirmationMethod),
            coupons: payload.dig(:coupons),
            shippingInfo: shippingInfo,
            lineItemData: payload.dig(:orderData, :lineItemData) || payload.dig(:items),
            description: payload.dig(:orderDescription),
            metadata: payload.dig(:orderMetadata),
            reference: payload.dig(:reference),
          }),
          successUrl: payload.dig(:successURL),
          cancelUrl: payload.dig(:cancelURL),
          test: payload.dig(:test) || false
        }
      end

      def normalize_customer_info(info)
        return if info.nil?
        customer = info.transform_keys(&:to_sym)
        {
          accountAge: customer.dig(:accountAge),
          emailAddress: customer.dig(:emailAddress) || customer.dig(:email),
          firstName: customer.dig(:firstName),
          lastName: customer.dig(:lastName),
          firstNameKana: customer.dig(:firstNameKana),
          lastNameKana: customer.dig(:lastNameKana),
          address: customer.dig(:address),
          phoneNumber: customer.dig(:phoneNumber) || customer.dig(:phone),
          dateOfBirth: customer.dig(:dateOfBirth),
          legalGender: customer.dig(:legalGender) || customer.dig(:gender),
          reference: customer.dig(:reference)
        }
      end

      def normalize_shipping(shipping)
        return if shipping.nil?
        shipping= shipping.transform_keys(&:to_sym)
        {
          address: shipping.dig(:address) || {
            line1: shipping.dig(:line1),
            line2: shipping.dig(:line2),
            line3: shipping.dig(:line3),
            line4: shipping.dig(:line4),
            line5: shipping.dig(:line5),
            subLocality: shipping.dig(:subLocality),
            locality: shipping.dig(:locality),
            administrativeArea: shipping.dig(:administrativeArea),
            postalCode: shipping.dig(:postalCode),
            country: shipping.dig(:country),
          },
          addressType: shipping.dig(:addressType),
          feeAmount: shipping.dig(:feeAmount),
          feeCurrency: shipping.dig(:feeCurrency),
        }
      end

      def normalize_order_data(order)
        return if order.nil?
        order = order.transform_keys(&:to_sym)
        {
          amount: order.dig(:amount),
          currency: order.dig(:currency),
          captureMethod: order.dig(:captureMethod),
          confirmationMethod: order.dig(:confirmationMethod),
          coupons: order.dig(:coupons),
          shippingInfo: order.dig(:shippingInfo),
          lineItemData: normalize_line_items(order.dig(:lineItemData) || order.dig(:items)),
          metadata: order.dig(:metadata) || {},
          reference: order.dig(:reference)
        }
      end

      def normalize_line_items(data)
        return [] if data.nil?

        data.map do |item|
          line_item = item.transform_keys(&:to_sym)
          {
            price: line_item.dig(:price),
            priceData: normalize_price_data(line_item.dig(:priceData) || {
              productData: {
                name: line_item.dig(:name),
                brand: line_item.dig(:brand),
                categories: line_item.dig(:categories),
                gtin: line_item.dig(:gtin),
                images: line_item.dig(:images),
                reference: line_item.dig(:reference),
                url: line_item.dig(:url),
                description: line_item.dig(:productDescription),
                metadata: line_item.dig(:productMetadata)
              },
              amount: line_item.dig(:amount),
              currency: line_item.dig(:currency),
              label: line_item.dig(:label),
              description: line_item.dig(:priceDescription),
              metadata: line_item.dig(:priceMetadata)
            }),
            quantity: line_item.dig(:quantity),
            description: line_item.dig(:description),
            metadata: line_item.dig(:metadata)
          }
        end
      end

      def normalize_price_data(data)
        return if data.nil?
        data = data.transform_keys(&:to_sym)
        {
          productData: normalize_product_data(data.dig(:productData) || {}),
          amount: data.dig(:amount),
          currency: data.dig(:currency),
          metadata: data.dig(:metadata)
        }
      end

      def normalize_product_data(product)
        return if product.nil?
        product = product.transform_keys(&:to_sym)
        {
          name: product.dig(:name),
          brand: product.dig(:brand),
          categories: product.dig(:categories),
          description: product.dig(:description),
          gtin: product.dig(:gtin),
          images: product.dig(:images),
          reference: product.dig(:reference),
          url: product.dig(:url),
          metadata: product.dig(:metadata)
        }
      end

      def get_currency
        currency = payload.dig(:orderData, :currency) || payload.dig(:orderData, 'currency')
        if currency.nil?
          items = get_items
          if !items.nil? && items.count > 0
            currency = items.first.dig(:currency) || items.first.dig('currency')
          end
        end
        currency
      end

      def get_total_amount
        total_amount = payload.dig(:orderData, :amount) || payload.dig(:orderData, 'amount')
        
        if total_amount.nil?
          items = get_items
          
          if !items.nil? && items.count > 0
            total_amount = items.inject(0) { |sum, item| sum + (item[:amount] || item['amount'] || 0) }
          end

          shipping_fee = payload.dig(:orderData, :shippingInfo, :feeAmount) ||
                          payload.dig(:orderData, :shippingInfo, 'feeAmount') ||
                          payload.dig(:shipping, :feeAmount) ||
                          payload.dig(:shipping, 'feeAmount') ||
                          0
          total_amount = shipping_fee + (total_amount || 0)
        end

        total_amount
      end

      def get_items
        @items ||= payload.dig(:orderData, :lineItemData, :priceData) ||
          payload.dig(:orderData, 'lineItemData', 'priceData') ||
          payload.dig(:items)
      end
    end
  end
end
