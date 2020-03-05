# frozen_string_literal: true

module Formatter
  module PhoneNumber
    module UK
      PREFIX = '+447'
      DIGIT_LENGTH = 9
      PREFIX_REGEXP = /^(?<prefix>\+44|44|0)(?<fixed_digit>7)/.freeze
      DIGIT_REGEXP  = /(?<digits>\d{#{DIGIT_LENGTH}})$/.freeze
      FORMAT_REGEXP = Regexp.new(PREFIX_REGEXP.source + DIGIT_REGEXP.source)

      class InvalidPhoneNumber < StandardError; end
      class InvalidPrefix < InvalidPhoneNumber; end
      class InvalidDigitLength < InvalidPhoneNumber; end

      class << self
        def format(number)
          trim_number = number.to_s.gsub(/\s/, '')
          match_data = trim_number.match(FORMAT_REGEXP)
          raise_error(trim_number) unless match_data

          digits = match_data.named_captures['digits']
          "#{PREFIX}#{digits}"
        end

        private

        def raise_error(number)
          raise InvalidPrefix unless number.start_with?(PREFIX_REGEXP)
          raise InvalidDigitLength unless number.sub(PREFIX_REGEXP, '').length == DIGIT_LENGTH

          raise InvalidPhoneNumber
        end
      end
    end
  end
end
