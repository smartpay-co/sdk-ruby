module Smartpay
  module Requests
    module Validator

      private

      def check_requirement!(requirement_keys = [])
        requirement_keys.each do |key_name|
          raise Errors::InvalidRequestPayloadError, key_name unless payload.include?(key_name)
        end
      end

    end
  end
end