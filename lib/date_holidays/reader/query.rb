module DateHolidays
  module Reader

    # A query interface for reading holiday information
    class Query
      attr_reader :country

      NODE_BIN_PATH = File.expand_path('../../../../node_bin', __FILE__).freeze
      private_constant :NODE_BIN_PATH

      def initialize(country:)
        @country = country || raise(ArgumentError, 'a country is required')
      end

      def holidays(year, language: :en)
        # TODO: use Open3 instead for security reasons: https://ruby-doc.org/stdlib-2.3.0/libdoc/open3/rdoc/Open3.html#method-c-popen3
        # TODO: support Linux:
        json_string = `#{File.join(NODE_BIN_PATH, 'holidays-to-json-macos')} #{country} #{year}`
      end
    end
  end
end
