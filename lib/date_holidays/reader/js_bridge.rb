# frozen_string_literal: true

module DateHolidays
  module Reader
    # A communication bridge to the JavaScript process which houses the date-holidays node module.
    class JsBridge
      # TODO: initialize with a configuration object for how to run the command

      def extract(sub_cmd, *args)
        # TODO: use Open3 for error handling?: https://ruby-doc.org/stdlib-2.3.0/libdoc/open3/rdoc/Open3.html#method-c-popen3
        cmd = File.join(NODE_BIN_PATH, 'holidays-to-json-macos')
        cmd_tokens_as_strings = [cmd, sub_cmd.to_s, *args].map(&:to_s)

        json_string = ''
        IO.popen(cmd_tokens_as_strings, err: %i[child out]) { |cmd_io| json_string = cmd_io.read }
        JSON.parse(json_string)
      end

      NODE_BIN_PATH = File.expand_path('../../../node_bin', __dir__).freeze
      private_constant :NODE_BIN_PATH
    end
  end
end
