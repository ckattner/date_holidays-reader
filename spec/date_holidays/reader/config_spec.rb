# frozen_string_literal: true

RSpec.describe DateHolidays::Reader::Config do
  describe 'countries' do
    it 'returns a hash with country code values and country name keys' do
      countries = described_class.countries
      expect(countries).to be_a Hash
      expect(countries['US']).to eq 'United States of America'
    end
  end
end
