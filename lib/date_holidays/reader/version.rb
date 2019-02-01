# frozen_string_literal: true

module DateHolidays
  module Reader
    VERSION = '0.2.0'

    # Used to retreive futher version information such as the underlying node module version.
    class Version
      class << self
        def node_module_version
          # if configured to use the pre-compiled binaries
          from_yarn_dot_lock

          # TODO: check the locally installed date-holidays Node module version via:
          # require.resolve('date-holidays')
          # and then parsing its relative package.json
        end

        private

        DATE_HOLIDAYS_MODULE_BEGIN = /\Adate-holidays@/.freeze
        VERSION_MATCHER = /\A  version "(.*?)"/.freeze
        YARN_DOT_LOCK_ERROR_MSG = 'unable to determine date-holidays node module version from ' \
                                  'yarn.lock'
        YARN_DOT_LOCK_PATH = File.expand_path('../../../yarn.lock', __dir__).freeze
        private_constant :DATE_HOLIDAYS_MODULE_BEGIN, :YARN_DOT_LOCK_ERROR_MSG, :YARN_DOT_LOCK_PATH

        # Note that yarn.lock does not use a standard format such as YAML or
        # JSON and no native parser is currently available in Ruby. This is
        # basic but it gets the job done.
        def from_yarn_dot_lock
          look_for_version = false

          File.new(YARN_DOT_LOCK_PATH).each do |line|
            if !look_for_version && line =~ DATE_HOLIDAYS_MODULE_BEGIN
              look_for_version = true
              next
            end

            found_version = extract_version(line) if look_for_version
            return found_version if found_version
          end

          raise Caution::IllegalStateError, YARN_DOT_LOCK_ERROR_MSG
        end

        def extract_version(line)
          line =~ VERSION_MATCHER && Regexp.last_match(1)
        end
      end
    end
  end
end
