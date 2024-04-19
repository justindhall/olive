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

I wanted to allow consumers to search by city name, but weather services like OpenWeather require latitude and longitude.
I think this is unreasonable for most users to know, so I compromised by allowing lookup by city name, state, and country
code with a layer inbetween to lookup city coordinates. The advantage of this is that the product is more user friendly.
A drawback is that we need to lookup city coordinates each time a request is made. I've tried to mitigate this by writing
city coordinates to the database after the first time they are looked up and including a composite index on the city name,
state, and country code to speed up future reads.

When a weather request is made, we either retrieve the city coordinates from the DB or make an API request to find them
before storing them in the DB. Then, we use the coordinates to make a request to the weather service provider. The request
to the provider is wrapped in a cache layer that will store the response in Redis for 10 minutes. 10 minutes is the suggested
time by OpenWeather but can be adjusted according to business needs.

The cache data is stored with a key that references the city database object (ie, `"#{city_object}_weather"`). This allows us
to take advantage of a few things:
* Updating the database object essentially invalidates the cache
  * We technically don't remove the data, but Redis will automatically evict unused data if it needs to make room
* We can easily lookup the cache data by city object



I've only implemented an OpenWeather API client for the weather service, but have built in such a way that in the future
it could be easily swapped to another weather service provider. Clients are responsible for making API requests and then
the responses are passed through a translation layer to convert into a common response object. The advantage here is that
we abstract away some of the implementation details of the specific providers and can build a more extensible and flexible 
system.

***
### Product Questions

* Requirements are to search for weather and cache weather by city name, but cities in different states can have the
  same name. Can we ask for additional location information like a state or zip code? Is there any projected
  international use case? If so, we would also need to consider that asking for a country code or that other countries
  don't necessarily have states / zip codes in the same way that the US does.
    * For this exercise, I'm forcing users to include a state and country code.
