# frozen_string_literal: true

module DateHolidays
  module Reader
    # Represents specific locale which contains holidays. This is the main
    # entry point into the gem.
    class Locale
      attr_reader :country, :state, :region

      def initialize(country:, state: nil, region: nil)
        @country = country || raise(ArgumentError, 'a country is required')
        @state = state
        @region = region
      end

      # Returns the holiday data as a hash exactly as returned from the
      # date-holiday node module.
      def raw_holidays(year, language: :en, types: Set.new)
        types = validate_and_convert_types_to_set(types)
        # TODO: use Open3 instead for security reasons: https://ruby-doc.org/stdlib-2.3.0/libdoc/open3/rdoc/Open3.html#method-c-popen3
        # TODO: support Linux:
        lang_opt = language ? "--lang #{language}" : ''

        command = "#{File.join(NODE_BIN_PATH, 'holidays-to-json-macos')} #{locale_selector} #{year} #{lang_opt}"

        #puts "command: #{command}"
        json_string = `#{command}`
        type_filter(JSON.parse(json_string), types)
      end

      # Returns DateHolidays::Reader::Holiday instances.
      def holidays(year, language: :en, types: Set.new)
        raw_holidays(year, language: language, types: types).map do |raw_holiday|
          Holiday.make(transform_raw_holiday(raw_holiday))
        end
      end

      private

      # More inforamtion about holiday types is available at
      # https://github.com/commenthol/date-holidays#types-of-holidays .
      HOLIDAY_TYPES = Set.new(%i[bank observance optional public school]).freeze
      NODE_BIN_PATH = File.expand_path('../../../node_bin', __dir__).freeze
      SUPPORTED_HOLIDAY_ATTRIBUTES = Set.new(%w[date start end name type substitute note]).freeze
      private_constant :NODE_BIN_PATH, :HOLIDAY_TYPES, :SUPPORTED_HOLIDAY_ATTRIBUTES

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
        [country, state, region].compact.join('.')
      end

      # Needed because of https://github.com/commenthol/date-holidays/issues/56
      def type_filter(raw_holidays, types)
        return raw_holidays if types.empty?

        raw_holidays.select { |hol| types.include?(hol['type'].to_sym) }
      end

      def validate_and_convert_types_to_set(types)
        types = types.is_a?(Set) ? types : Set.new(types)
        invalid_types = types.difference(HOLIDAY_TYPES)

        if invalid_types.any?
          error_msg = "invalid holiday type(s): #{invalid_types.to_a.join(', ')}"
          raise ArgumentError, error_msg
        end

        types
      end
    end
  end
end
