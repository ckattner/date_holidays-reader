# frozen_string_literal: true

module DateHolidays
  module Reader
    # Represents specific locale which contains holidays. This is the main
    # entry point into the gem.
    class Locale
      SUPPORTED_HOLIDAY_ATTRIBUTES = %w[date start end name type substitue note].freeze

      NODE_BIN_PATH = File.expand_path('../../../node_bin', __dir__).freeze
      private_constant :NODE_BIN_PATH

      attr_reader :country, :state, :region

      def initialize(country:, state: nil, region: nil)
        @country = country || raise(ArgumentError, 'a country is required')
        @state = state
        @region = region
      end

      # Returns the holiday data as a hash exactly as returned from the
      # date-holiday node module.
      def raw_holidays(year, language: :en)
        # TODO: use Open3 instead for security reasons: https://ruby-doc.org/stdlib-2.3.0/libdoc/open3/rdoc/Open3.html#method-c-popen3
        # TODO: support Linux:
        json_string = `#{File.join(NODE_BIN_PATH, 'holidays-to-json-macos')} #{locale_selector} #{year}`
        JSON.parse(json_string)
      end

      # Returns DateHolidays::Reader::Holiday instances.
      def holidays(year, language: :en)
        raw_holidays(year, language: language).map do |raw_holiday|
          Holiday.make(transform_raw_holiday(raw_holiday))
        end
      end

      private

      def transform_raw_holiday(raw)
        # Note that this could instead be .slice under Ruby >= 2.5 or with Rails:
        clean_hash = raw.select { |key, _value| SUPPORTED_HOLIDAY_ATTRIBUTES.include?(key) }

        # Node date-holdiays uses start and end keys. The "end" key does not play well with Ruby.
        # Also, the "_time" suffix adds clarity.
        clean_hash[:start_time] = clean_hash.delete('start')
        clean_hash[:end_time] = clean_hash.delete('end')

        clean_hash
      end

      def locale_selector
        [country, state, region].join('.')
      end
    end
  end
end
