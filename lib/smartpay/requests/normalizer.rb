module Smartpay
  module Requests
    module Normalizer

      LINE_ITEM_KINDS = %w[product tax discount].freeze

      private

      def normalize_customer_info(info)
          return if info.nil?

          customer = info.transform_keys(&:to_sym)
          {
            accountAge: customer[:accountAge],
            emailAddress: customer[:emailAddress] || customer[:email],
            firstName: customer[:firstName],
            lastName: customer[:lastName],
            firstNameKana: customer[:firstNameKana],
            lastNameKana: customer[:lastNameKana],
            address: customer[:address],
            phoneNumber: customer[:phoneNumber] || customer[:phone],
            dateOfBirth: customer[:dateOfBirth],
            legalGender: customer[:legalGender] || customer[:gender],
            reference: customer[:reference]
          }
        end

        def normalize_shipping(shipping, fallback_currency = nil)
          return if shipping.nil?

          shipping = shipping.transform_keys(&:to_sym)
          normalized_shipping = {
            address: shipping[:address] || {
              line1: shipping[:line1],
              line2: shipping[:line2],
              line3: shipping[:line3],
              line4: shipping[:line4],
              line5: shipping[:line5],
              subLocality: shipping[:subLocality],
              locality: shipping[:locality],
              administrativeArea: shipping[:administrativeArea],
              postalCode: shipping[:postalCode],
              country: shipping[:country]
            },
            addressType: shipping[:addressType],
            feeAmount: shipping[:feeAmount],
            feeCurrency: shipping[:feeCurrency]
          }

          if normalized_shipping && normalized_shipping[:feeCurrency].nil? && !(normalized_shipping[:feeAmount].nil?)
            normalized_shipping[:feeCurrency] = fallback_currency
          end
          normalized_shipping
        end

        def normalize_items(data)
          return [] if data.nil?

          data.map do |item|
            line_item = item.transform_keys(&:to_sym)
            {
              quantity: line_item[:quantity],
              label: line_item[:label],
              name: line_item[:name],
              amount: line_item[:amount],
              currency: line_item[:currency],
              brand: line_item[:brand],
              categories: line_item[:categories],
              gtin: line_item[:gtin],
              images: line_item[:images],
              reference: line_item[:reference],
              url: line_item[:url],
              description: line_item[:description],
              priceDescription: line_item[:priceDescription],
              productDescription: line_item[:productDescription],
              metadata: line_item[:metadata],
              productMetadata: line_item[:productMetadata],
              priceMetadata: line_item[:priceMetadata],
              kind: LINE_ITEM_KINDS.include?(line_item[:kind]) ? line_item[:kind] : nil
            }
          end
        end

        def get_total_amount(raw_payload = nil)
          total_amount = raw_payload[:amount] || raw_payload["amount"]
          return total_amount if total_amount

          items = raw_payload[:items]

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

          total_amount
        end

    end
  end
end