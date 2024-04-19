require 'rails_helper'

describe City, type: :model do

  subject do
    described_class.new(
      name: 'San Francisco',
      state: 'CA',
      country: 'US',
      latitude: 37.7749,
      longitude: -122.4194
    )
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it { should validate_uniqueness_of(:name).scoped_to(:state, :country) }
  end

  describe '.find_or_create_by_name' do
    context 'when the city already exists' do
      let(:city) { create(:city, name: 'foo', state: 'foo', country: 'foo') }

      context 'when the city can be found by name, state, and country' do

        it 'should return the city without making an API call' do
          expect(OpenWeather::GeocodingClient).not_to receive(:new)
          expect(City.find_or_create_by_name(name: city.name, state: city.state, country_code: city.country)).
            to eq(city)
        end
      end

      context 'when the local city cannot be found by name, state, and country' do
        let(:api_response) do
          double(
            body: [{
              name: city.name,
              state: city.state,
              country: city.country,
              lat: city.latitude,
              lon: city.longitude
            }].to_json
          )
        end
        let(:faraday_double) { double(get: api_response) }

        subject { City.find_or_create_by_name(name: city.name, state: 'abbr foo', country_code: 'full foo') }

        before do
          allow(::Faraday).to receive(:new).and_return(faraday_double)
        end

        it 'should return the existing city instead of making a new one' do
          expect(subject).to eq(city)
          expect { subject }.not_to change { City.count }
        end
      end
    end

    context 'when the city does not exist' do
      let(:api_response) do
        double(
          body: [{
            name: 'foo',
            state: 'foo',
            country: 'foo',
            lat: 37.7749,
            lon: -122.4194
          }].to_json
        )
      end
      let(:faraday_double) { double(get: api_response) }

      before do
        allow(::Faraday).to receive(:new).and_return(faraday_double)
      end

      it 'should create a new city' do
        expect { City.find_or_create_by_name(name: 'foo', state: 'foo', country_code: 'foo') }.
          to change { City.count }.by(1)
      end
    end
  end
end
