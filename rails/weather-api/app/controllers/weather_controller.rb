class WeatherController < ApplicationController
  def get
    response = Weather.get_weather_by_city(
      city_name: get_params[:city_name],
      state: get_params[:state],
      country_code: get_params[:country_code]
    )
    if response.error_code.present?
      render json: { error: response.error_message }, status: response.error_code
    else
      render json: response
    end
  end

  private

  def get_params
    params.require([:city_name, :state, :country_code])
    params.permit(:city_name, :state, :country_code)
  end
end
