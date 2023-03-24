module Smartpay
  module Errors
    # InvalidRequestPayloadError
    class InvalidRequestPayloadError < ArgumentError
      attr_accessor :key_name

      def initialize(key_name)
        @key_name = key_name
        super
      end

      def message
        "#{key_name} can't be blank or contains invalid value."
      end
    end
  end
end
