# frozen_string_literal: true

RSpec.describe DateHolidays::Reader::JsBridge do
  it 'can be configured to use node directly' do
    node_config = DateHolidays::Reader::Config.new(node_path: 'node')
    subject = described_class.new(node_config)

    first_arg = nil

    io_stub = OpenStruct.new(read: '[]')
    expect(IO).to receive(:popen) { |arg| first_arg = arg.shift }.and_yield(io_stub)

    subject.extract('foo')

    expect(first_arg).to eq 'node'
  end
end
