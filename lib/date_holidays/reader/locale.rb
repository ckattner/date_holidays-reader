# frozen_string_literal: true

module DateHolidays
  module Reader
    # Represents specific locale which contains holidays. This is the main
    # entry point into the gem.
    class Locale
      SUPPORTED_HOLIDAY_ATTRIBUTES = %w[date start end name type substitue note].freeze

      NODE_BIN_PATH = File.expand_path('../../../node_bin', __dir__).freeze
      private_constant :NODE_BIN_PATH

      attr_reader :country

      def initialize(country:)
        @country = country || raise(ArgumentError, 'a country is required')
      end

      # Returns the holiday data as a hash exactly as returned from the
      # date-holiday node module.
      def raw_holidays(year, language: :en)
        # TODO: use Open3 instead for security reasons: https://ruby-doc.org/stdlib-2.3.0/libdoc/open3/rdoc/Open3.html#method-c-popen3
        # TODO: support Linux:
        json_string = `#{File.join(NODE_BIN_PATH, 'holidays-to-json-macos')} #{country} #{year}`
        JSON.parse(json_string)
      end

      # Returns DateHolidays::Reader::Holiday instances.
      def holidays(year, language: :en)
        raw_holidays(year, language: language).map do |raw_holiday|
          Holiday.make(transform_raw_holiday(raw_holiday))
        end
      end

      private

      # Node date-holdiays uses start and end keys. The "end" key does not play well with Ruby.
      def transform_raw_holiday(raw)
        clean_hash = raw.select { |key, _value| SUPPORTED_HOLIDAY_ATTRIBUTES.include?(key) }

        clean_hash[:start_time] = clean_hash.delete('start')
        clean_hash[:end_time] = clean_hash.delete('end')

        clean_hash
      end
    end
  end
end
