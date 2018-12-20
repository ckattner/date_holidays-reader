# frozen_string_literal: true

RSpec.describe DateHolidays::Reader::Locale do
  let(:gb_holidays) do
    fixture_path = File.expand_path('./gb_fixture.json', __dir__)
    holidays_json = JSON.parse(File.read(fixture_path))
    DateHolidays::Reader::Holiday.array(holidays_json)
  end

  it 'retrieves basic UK holidays' do
    gb = described_class.new(country: :gb)
    holidays2018 = gb.holidays(2018)

    expect(holidays2018.length).to eq(9)
    expect(holidays2018).to eq(gb_holidays)
  end

  it 'retreives holidays for a specific state' do
    organmens_day = DateHolidays::Reader::Holiday.new(
      date: '2018-07-12 00:00:00',
      start_time: '2018-07-11T23:00:00.000Z',
      end_time: '2018-07-12T23:00:00.000Z',
      name: 'Battle of the Boyne, Orangemen’s Day',
      type: 'public',
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
      type: 'public',
    )

    new_orleans = described_class.new(country: :us, state: :la, region: :no)
    holidays2019 = new_orleans.holidays(2019)

    expect(holidays2019.length).to eq(21)
    expect(holidays2019).to include(mardi_gras)
  end

  it 'retreives holidays for a specific year'

  it 'retreives holidays in a specific language'

  it 'filters by holiday type'

  specify 'getHolidays is an alias for holidays'

  describe 'validation' do
    it 'requires a country'
  end
end
