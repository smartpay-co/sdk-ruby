# frozen_string_literal: true

module Smartpay
  module Responses
    class Base
      attr_reader :response

      def initialize(raw_response)
        @raw_response = raw_response
        @response = begin
          JSON.parse(@raw_response.body, symbolize_names: true)
        rescue JSON::ParserError
          { body: @raw_response.body }
        end if @raw_response
      end

      def as_hash
        @response
      end

      def as_json
        @response.to_json
      end

      def http_code
        @raw_response.code
      end
    end
  end
end
