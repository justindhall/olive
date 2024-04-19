# README

### Getting Started

**Pre-requisites:**

* Have docker installed on your machine and have the ability to run docker-compose

**Setup:**

* Clone the repository
* CD into the directory
* Add your OpenWeather API key to the .env file in `olive/rails/weather-api/.env`. One should be provided in an email to
  contributors or you can sign up for an account at [OpenWeather](https://openweathermap.org/api)
  * `OPEN_WEATHER_API_KEY=your_api_key`
* Run `docker compose up`
* JSON responses are served at `localhost:3000/weather`
  * `curl -XGET 'localhost:3000/weather?city_name=Arlington&state=Virginia&country_code=US'` 


***
### Architecture

![Architecture Diagram](./olive_architecture.png)

The application has one endpoint `/weather` that takes in a city name, state, and country code. The endpoint will
return a JSON response with either the current weather for the city or an error object with a message and status.




***
### Product Questions

* Requirements are to search for weather and cache weather by city name, but cities in different states can have the
  same name. Can we ask for additional location information like a state or zip code? Is there any projected
  international use case? If so, we would also need to consider that asking for a country code or that other countries
  don't necessarily have states / zip codes in the same way that the US does.
    * For this exercise, I'm forcing users to include a state and country code.
