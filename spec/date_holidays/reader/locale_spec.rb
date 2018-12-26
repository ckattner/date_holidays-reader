# frozen_string_literal: true

RSpec.describe DateHolidays::Reader::Locale do
  let(:gb_holidays) do
    fixture_path = File.expand_path('./gb_fixture.json', __dir__)
    holidays_json = JSON.parse(File.read(fixture_path))
    DateHolidays::Reader::Holiday.array(holidays_json)
  end
  let(:gb) { described_class.new(country: :gb) }
  let(:us) { described_class.new(country: :us) }

  it 'retrieves basic UK holidays' do
    holidays2018 = gb.holidays(2018)

    expect(holidays2018.length).to eq(9)
    expect(holidays2018).to eq(gb_holidays)
  end

  it 'correctly assigns subtitute days' do
    us_2016 = us.holidays(2016)
    xmas_date = Date.parse('2016-12-25')
    day_after_xmas_date = Date.parse('2016-12-26')

    # Not a substitute
    xmas= us_2016.find { |h| h.date == xmas_date }
    expect(xmas).not_to be_nil
    expect(xmas.substitute?).to eq false

    # Monday, 2016-12-26 was a substitute as Christmas occured on a Sunday:
    xmas_substitute = us_2016.find { |h| h.date == day_after_xmas_date }
    expect(xmas_substitute).not_to be_nil
    expect(xmas_substitute.substitute?).to eq true
  end

  it 'retreives holidays for a specific state' do
    organmens_day = DateHolidays::Reader::Holiday.new(
      date: '2018-07-12 00:00:00',
      start_time: '2018-07-11T23:00:00.000Z',
      end_time: '2018-07-12T23:00:00.000Z',
      name: 'Battle of the Boyne, Orangemen’s Day',
      type: 'public'
    )
    nothern_ireland = described_class.new(country: :gb, state: :nir)
    holidays2018 = nothern_ireland.holidays(2018)

    expect(holidays2018.length).to eq(13)
    expect(holidays2018).to include(organmens_day)
  end

  it 'retreives holidays for a specific state and region' do
    mardi_gras = DateHolidays::Reader::Holiday.new(
      date: '2019-03-05 00:00:00',
      start_time: '2019-03-05T06:00:00.000Z',
      end_time: '2019-03-06T06:00:00.000Z',
      name: 'Mardi Gras',
      type: 'public'
    )

    new_orleans = described_class.new(country: :us, state: :la, region: :no)
    holidays2019 = new_orleans.holidays(2019)

    expect(holidays2019.length).to eq(21)
    expect(holidays2019).to include(mardi_gras)
  end

  it 'retreives holidays for a region for a country without states'

  it 'retreives holidays in a specific language' do
    gb = described_class.new(country: :gb)
    expect(gb.holidays(2017, language: :es).first.name).to eq 'Año Nuevo'
  end

  describe 'holiday type' do
    it 'filters by a single type' do
      found_holidays = us.holidays(2018, types: [:optional])
      found_holiday_types = Set.new(found_holidays.map(&:type))

      expect(found_holiday_types).to eq Set.new([:optional])
    end

    it 'filters by a multiple types' do
      found_holidays = us.holidays(2018, types: %i[optional public])
      found_holiday_types = Set.new(found_holidays.map(&:type))

      expect(found_holiday_types).to eq Set.new(%i[optional public])
    end

    it 'raises an ArgumentError when passed an invalid type' do
      expect do
        us.holidays(2018, types: %i[public bogus bogus2])
      end.to raise_error ArgumentError, 'invalid holiday type(s): bogus, bogus2'
    end
  end

  it 'allows a timezone to be set'

  describe 'validation' do
    it 'requires a country' do
      expect do
        described_class.new(country: nil, state: :il)
      end.to raise_error ArgumentError, 'a country is required'
    end
  end
end
