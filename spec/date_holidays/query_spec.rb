# frozen_string_literal: true

RSpec.describe DateHolidays::Reader::Query do
  it 'retrieves basic UK holidays' do
    subject = described_class.new(country: :gb)

    holidays2018 = subject.holidays(2018)
    expect(holidays2018.length).to eq(9)

    # TODO: validate each holiday
  end

  it 'retreives holidays for a specific state'

  it 'retreives holidays for a specific state and region'

  it 'retreives holidays for a specific year'

  it 'retreives holidays in a specific language'

  it 'filters by holiday type'

  specify 'getHolidays is an alias for holidays'
end
