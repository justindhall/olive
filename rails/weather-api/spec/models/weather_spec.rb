require 'rails_helper'

describe Weather do
  describe '.get_weather_by_city' do
    let(:faraday_double) { double(get: api_response) }
    let(:city) { create(:city) }

    subject { Weather.get_weather_by_city(city_name: city.name, state: city.state, country_code: city.country) }

    before do
      allow(::Faraday).to receive(:new).and_return(faraday_double)
    end

    context 'when the response is successful' do
      let(:api_response) do
        double(
          body: {
            current: {
              temp: 75.2,
              humidity: 50,
              wind_speed: 5.0,
              weather: [{ description: 'clear sky' }]
            }
          }.to_json
        )
      end

      it 'returns the weather information' do
        result = subject
        expect(result.temperature).to eq(75.2)
        expect(result.humidity).to eq(50)
        expect(result.wind_speed).to eq(5.0)
        expect(result.conditions).to eq('clear sky')
      end
    end

    context 'when the response is unsuccessful' do
      let(:api_response) do
        double(
          body: {
            cod: error_code,
            message: error_message
          }.to_json
        )
      end
      let(:error_code) { nil }
      let(:error_message) { nil }

      context 'when the error code is 400' do
        let(:error_code) { '400' }
        let(:error_message) { 'that is a bad request' }

        it 'returns an object with the correct error code and message' do
          expect(subject.error_code).to eq('400')
          expect(subject.error_message).to eq('that is a bad request')
        end
      end

      context 'when the error code is 401' do
        let(:error_code) { '401' }
        let(:error_message) { 'unauthorized' }

        it 'returns an object with the correct error code and message' do
          expect(subject.error_code).to eq('401')
          expect(subject.error_message).to eq('unauthorized')
        end
      end

      context 'when the error code is 404' do
        let(:error_code) { '404' }
        let(:error_message) { 'not found' }

        it 'returns an object with the correct error code and message' do
          expect(subject.error_code).to eq('404')
          expect(subject.error_message).to eq('not found')
        end
      end

      context 'when the error code is 429' do
        let(:error_code) { '429' }
        let(:error_message) { 'rate limit exceeded' }

        it 'returns an object with the correct error code and message' do
          expect(subject.error_code).to eq('429')
          expect(subject.error_message).to eq('rate limit exceeded')
        end
      end

      context 'when the error code is 500' do
        let(:error_code) { '500' }
        let(:error_message) { 'server error' }

        it 'returns an object with the correct error code and message' do
          expect(subject.error_code).to eq('500')
          expect(subject.error_message).to eq('server error')
        end
      end
    end
  end
end
