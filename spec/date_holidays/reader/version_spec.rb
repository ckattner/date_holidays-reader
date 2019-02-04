# frozen_string_literal: true

RSpec.describe DateHolidays::Reader::Version do
  describe 'node module version' do
    it 'comes from yarn.lock run running from binaries' do
      expect(described_class.node_module_version).to eq('1.3.6')
    end

    it 'comes from the installed date-holidays module when running from Node' do
      node_config = DateHolidays::Reader::Config.new(node_path: 'node')
      expect(described_class.node_module_version(node_config)).to eq('1.3.6')
    end
  end
end
