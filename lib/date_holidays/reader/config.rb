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
    end
  end
end
