# frozen_string_literal: true

RSpec.describe DateHolidays::Reader::Config do
  describe 'countries' do
    it 'returns a hash with country code keys and country name values' do
      countries = described_class.countries
      expect(countries).to be_a Hash
      expect(countries['US']).to eq 'United States of America'
    end
  end

  describe 'os detection' do
    describe 'native Mac OS' do
      it 'detects Mac OS' do
        expect(OS).to receive(:osx?).and_return true
        expect(OS).to receive(:linux?).and_return false

        expect(subject.native_mac?).to eq true
        expect(subject.native_linux?).to eq false
      end

      it 'only supports 64 bit Mac OS'
    end

    describe 'native Linux' do
      it 'detects Linux' do
        expect(OS).to receive(:linux?).and_return true
        expect(OS).to receive(:osx?).and_return false

        expect(subject.native_linux?).to eq true
        expect(subject.native_mac?).to eq false
      end

      it 'only supports 64 bit Linux'
    end
  end

  it 'allows the user to specify the location of his or her node binary'
end
