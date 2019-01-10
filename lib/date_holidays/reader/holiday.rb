# frozen_string_literal: true

# Use time from the standard library (instead of core) which has .strptime:
require 'time'

module DateHolidays
  module Reader
    # A holiday which includes a date, start and end times, name, and type.
    # Based on https://github.com/commenthol/date-holidays#holiday-object .
    #
    # The date is represented as a Ruby Date instance as it is the
    # holiday start date in the local time zone.
    #
    # Start and end times are represented as Time instances in UTC. Note that
    # New Year's day in the US has a start time of January 1st at 5 AM UTC as
    # Eastern Standard Time is five hours after UTC.
    class Holiday
      acts_as_hashable

      attr_reader :date, :start_time, :end_time, :name, :type, :note

      def initialize(date:, start_time:, end_time:, name:, type:, substitute: false, note: nil)
        @date = date.is_a?(Date) ? date : Date.strptime(date, '%Y-%m-%d')
        @start_time = parse_time(start_time)
        @end_time = parse_time(end_time)
        @name = name
        @type = type.to_sym
        @substitute = substitute
        @note = note

        freeze
      end

      def substitute?
        @substitute
      end

      def ==(other)
        other.is_a?(self.class) &&
          other.date == date &&
          other.start_time == start_time &&
          other.end_time == end_time &&
          other.name == name &&
          other.type == type &&
          other.substitute? == substitute? &&
          other.note == note
      end

      private

      def parse_time(time)
        # Example time string: "2018-01-01T05:00:00.000Z"
        time.is_a?(Time) ? time : Time.xmlschema(time)
      end
    end
  end
end

# For reference:
# Core Time: https://ruby-doc.org/core-2.3.6/Time.html
# Stdlib Time: https://ruby-doc.org/stdlib-2.3.8/libdoc/time/rdoc/Time.html
# Stdlib Date: http://ruby-doc.org/stdlib-2.3.8/libdoc/date/rdoc/Date.html
