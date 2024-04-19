class City < ApplicationRecord
  validates :name, :state, :country, :latitude, :longitude, presence: true
  validates :name, uniqueness: { scope: %i[state country] }

  def self.find_or_create_by_name(name:, state:, country_code:)
    find_by(name: name, state: state, country: country_code) ||
      lookup_city_by_name(name: name, state: state, country_code: country_code)
  end

  private

  def self.lookup_city_by_name(name:, state:, country_code:)
    response = OpenWeather::GeocodingClient.new(city_name: name, state: state, country_code: country_code).get
    find_or_create_by(
      name: response.city_name,
      state: response.state,
      country: response.country_code,
      latitude: response.latitude,
      longitude: response.longitude
    )
  end
end
