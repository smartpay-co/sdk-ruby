# frozen_string_literal: true

module Smartpay
  module Responses
    class Base
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def as_hash
        @response
      end

      def as_json
        @response.to_json
      end

      def http_code
        @response.code
      end
    end
  end
end
