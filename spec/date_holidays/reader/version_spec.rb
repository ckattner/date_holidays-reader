# frozen_string_literal: true

RSpec.describe DateHolidays::Reader::Version do
  it 'reports the node module version from yarn.lock' do
    expect(described_class.node_module_version).to eq('1.3.6')
  end
end
