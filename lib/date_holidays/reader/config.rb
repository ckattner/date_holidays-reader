# frozen_string_literal: true

module DateHolidays
  module Reader
    # Tells the gem how to interact with Node and provides a list of countries.
    class Config
      class << self
        def countries
          JsBridge.new.extract(:countries)
        end
      end

      attr_reader :node_path

      def initialize(node_path: nil)
        @node_path = node_path

        freeze
      end

      def native_mac?
        OS.osx?
      end

      def native_linux?
        OS.linux?
      end
    end
  end
end
