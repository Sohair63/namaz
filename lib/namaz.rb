require 'namaz/version'

require 'hashie'
require 'multi_json'
require 'faraday'

module Namaz
  DEFAULT_API_URL = 'http://api.aladhan.com'

  class << self
    # Retrieve the namaz timings for a given latitude, longitude, timezonestring and method.
    #
    # @param [Float] latitude.
    # @param [Float] longitude.
    # @param [String] timezonestring
    # @param [Integer] method
    # @param options [Hash], Have optional values like timestamp, that is default to Current timestamp
    def timings(latitude:, longitude:, timezonestring:, method:, options: {})
      timestamp = options[:timestamp] ? options[:timestamp] : Time.now.to_i
      namaz_url = [DEFAULT_API_URL, 'timings', timestamp].join('/')

      params = {
        latitude: latitude,
        longitude: longitude,
        timezonestring: timezonestring,
        method: method
      }

      namaz_time_response(namaz_url, params)
    end

    # Retrieve the namaz timings for a given city, country, method.
    #
    # @param [String] city
    # @param [String] country
    # @param [String] timezonestring
    # @param [Integer] method
    # @param [Hash] options, Have optional values like timestamp, that is default to Current timestamp
    def timings_by_city(city:, country:, method:, options: {})
      timestamp = options[:timestamp] ? options[:timestamp] : Time.now.to_i
      namaz_url = [DEFAULT_API_URL, 'timingsByCity', timestamp].join('/')

      params = {
        city: city,
        country: country,
        state: options[:state],
        method: method
      }

      namaz_time_response(namaz_url, params)
    end

    # Retrieve the namaz timings for a given latitude, longitude, timezonestring and method.
    #
    # @param [Float] latitude.
    # @param [Float] longitude.
    # @param [String] timezonestring
    # @param [Integer] method
    # @param [Hash] options, year, month, and state are OPTIONAL
    # year is default to current year, and month is default to current month if not sent in OPTIONAL params
    def calendar(latitude:, longitude:, timezonestring:, method:, options: {})
      namaz_url = [DEFAULT_API_URL, 'calendar'].join('/')

      params = {
        latitude: latitude,
        longitude: longitude,
        timezonestring: timezonestring,
        month: options[:month],
        year: options[:year],
        method: method
      }

      namaz_calender_response(namaz_url, params)
    end


    # Retrieve the calender for a given city, country, method.
    # By default Retrieve current year, month
    #
    # @param [String] city
    # @param [String] country
    # @param [Integer] method
    # @param [Hash] options, year, month, and state are OPTIONAL
    # year is default to current year, and month is default to current month if not sent in OPTIONAL params
    def calendar_by_city(city:, country:, method:, options: {})
      namaz_url = [DEFAULT_API_URL, 'calendarByCity'].join('/')

      params = {
        city: city,
        country: country,
        month: options[:month],
        year: options[:year],
        state: options[:state],
        method: method
      }

      namaz_calender_response(namaz_url, params)
    end


    # Build or get an HTTP connection object.
    def connection
      @connection ||= Faraday.new
    end

    # Set an HTTP connection object.
    #
    # @param connection Connection object to be used.
    def connection=(connection)
      @connection = connection
    end

    private

    def get(path, params = {})
      connection.get(path, params)
    end

    def namaz_time_response(namaz_url, params)
      response = connection.get(namaz_url, params)
      return Hashie::Mash.new(MultiJson.load(response.body)).data.timings if response.success?
    end

    def namaz_calender_response(namaz_url, params)
      response = connection.get(namaz_url, params)
      return Hashie::Mash.new(MultiJson.load(response.body)).data if response.success?
    end

  end
end
