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

      def native_mac?
        OS.osx?
      end

      def native_linux?
        OS.linux?
      end

      # The path to where the `node` command lives.
      def node_path
        nil
      end
    end
  end
end
