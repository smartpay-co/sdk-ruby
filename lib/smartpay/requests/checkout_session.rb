# frozen_string_literal: true

module Smartpay
  module Requests
    class CheckoutSession
      attr_accessor :payload

      REQUIREMENT_KEY_NAME = [:successUrl, :cancelUrl, :customer, :currency, :items].freeze
      LINE_ITEM_KINDS = %w[product tax discount].freeze
      CAN_FALLBACK_KEYS = [:customer].freeze

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
        shipping_info = payload.dig(:shippingInfo) || normalize_shipping(payload.dig(:shipping))
        if shipping_info && shipping_info[:feeCurrency].nil? && !(shipping_info[:feeAmount].nil?)
          shipping_info[:feeCurrency] = payload.dig(:currency)
        end

        normalized = {
          customerInfo: normalize_customer_info(payload.dig(:customerInfo) || payload.dig(:customer) || {}),
          captureMethod: payload.dig(:captureMethod),
          currency: payload.dig(:currency),
          description: payload.dig(:description),
          shippingInfo: shipping_info,
          items: normalize_items(payload.dig(:items)),
          metadata: payload.dig(:metadata) || {},
          reference: payload.dig(:reference),
          successUrl: payload.dig(:successUrl),
          cancelUrl: payload.dig(:cancelUrl),
        }

        normalized[:amount] = get_total_amount(normalized)

        return normalized
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

      def normalize_items(data)
        return [] if data.nil?

        data.map do |item|
          line_item = item.transform_keys(&:to_sym)
          {
            quantity: line_item.dig(:quantity),
            label: line_item.dig(:label),
            name: line_item.dig(:name),
            amount: line_item.dig(:amount),
            currency: line_item.dig(:currency),
            brand: line_item.dig(:brand),
            categories: line_item.dig(:categories),
            gtin: line_item.dig(:gtin),
            images: line_item.dig(:images),
            reference: line_item.dig(:reference),
            url: line_item.dig(:url),
            description: line_item.dig(:description),
            priceDescription: line_item.dig(:priceDescription),
            productDescription: line_item.dig(:productDescription),
            metadata: line_item.dig(:metadata),
            productMetadata: line_item.dig(:productMetadata),
            priceMetadata: line_item.dig(:priceMetadata),
            kind: LINE_ITEM_KINDS.include?(line_item.dig(:kind)) ? line_item.dig(:kind) : nil
          }
        end
      end

      def get_total_amount(raw_payload = nil)
        total_amount = raw_payload.dig(:amount) || raw_payload.dig("amount")
        return total_amount if total_amount

        items = raw_payload.dig(:items)

        if !items.nil? && items.count.positive?
          total_amount = items.inject(0) { |sum, item|
            amount = item[:amount] || item["amount"] || 0
            amount = -amount if item[:kind] == "discount"
            sum + amount
          }
        end

        shipping_fee = raw_payload.dig(:shippingInfo, :feeAmount) ||
                       raw_payload.dig(:shippingInfo, "feeAmount") ||
                       0
        total_amount += shipping_fee

        return total_amount
      end
    end
  end
end
