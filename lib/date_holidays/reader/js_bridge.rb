# frozen_string_literal: true

module DateHolidays
  module Reader
    # A communication bridge to the JavaScript process which houses the date-holidays node module.
    class JsBridge
      # TODO: initialize with a configuration object for how to run the command

      def extract(sub_cmd, *args)
        # TODO: use Open3 instead for security reasons: https://ruby-doc.org/stdlib-2.3.0/libdoc/open3/rdoc/Open3.html#method-c-popen3
        # or just IO.popen: https://ruby-doc.org/core-2.3.0/IO.html#method-c-popen
        # TODO: support Linux:
        cmd = "#{File.join(NODE_BIN_PATH, 'holidays-to-json-macos')} #{sub_cmd} #{args.join(' ')}"

        # puts "cmd: #{wcmd}"
        json_string = `#{cmd}`
        JSON.parse(json_string)
      end

      NODE_BIN_PATH = File.expand_path('../../../node_bin', __dir__).freeze
      private_constant :NODE_BIN_PATH
    end
  end
end
