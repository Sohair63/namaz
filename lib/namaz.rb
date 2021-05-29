require 'namaz/version'

require 'hashie'
require 'multi_json'
require 'faraday'
require 'time'
require 'active_support/core_ext/time/zones'

module Namaz
  DEFAULT_API_URL = 'http://api.aladhan.com/v1'

  class << self
    # Retrieve the remaining time to next namaz for a given latitude, longitude, timezonestring and method.
    #
    # @param [Float] latitude.
    # @param [Float] longitude.
    # @param [String] timezonestring
    # @param [Integer] method
    # @param options [Hash], Have optional values like timestamp, that is default to Current timestamp
    # @return [Hash] namaz_name, and time remain in seconds
    def upcoming_namaz(latitude:, longitude:, timezonestring:, method:, options: {})
      namaz_time_response = timings(
        latitude: latitude,
        longitude: longitude,
        timezonestring: timezonestring,
        method: method,
        options: options
      )

      prayer_and_time_remain(namaz_time_response, timezonestring)
    end

    # Retrieve the remaining time to next namaz for a given city, country, method and timezonestring
    #
    # @param [String] city
    # @param [String] country
    # @param [Integer] method
    # @param [Hash] options, Have optional values like timestamp, that is default to Current timestamp
    # @return [Hash] namaz_name, and time remain in seconds
    def upcoming_namaz_by_city(city:, country:, method:, timezonestring:, options: {})
      namaz_time_response = timings_by_city(
        city: city,
        country: country,
        method: method,
        options: options)

      prayer_and_time_remain(namaz_time_response, timezonestring)
    end

    # Retrieve the latitude, longitude and timezone for a given city
    # @param [String] city
    # @param [String] country
    # @param [Hash] options state is OPTIONAL
    # @return [Hashie::Mash] having latitude longitude and timezone
    def city_info(city:, country:, options: {})
      url = [DEFAULT_API_URL, 'cityInfo'].join('/')

      params = {
        city: city,
        country: country,
        state: options[:state]
      }

      response = connection.get(url, params)
      return Hashie::Mash.new(MultiJson.load(response.body)).data if response.success?
    end

    # Retrieve the latitude, longitude and timezone for given address
    # @param [address] A complete address string
    # @return [Hashie::Mash] having latitude longitude and timezone
    def address_info(address:)
      url = [DEFAULT_API_URL, 'addressInfo'].join('/')

      params = { address: address }
      response = connection.get(url, params)
      return Hashie::Mash.new(MultiJson.load(response.body)).data if response.success?
    end

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

    def prayer_and_time_remain(times, timezonestring)
      times.delete('Sunset')
      times.delete('Sunrise')
      times.delete('Midnight')
      times.delete('Imsak')

      Time.zone = timezonestring
      current_time = Time.now
      current_time_hms = current_time.strftime('%H:%M:%S')
      current_time_hm = current_time.strftime('%H:%M')

      times.select { |key, value| times[key] = Time.strptime(value, '%H:%M').strftime('%H:%M') }
      namaz_name, namaz_time = times.select { |_, value| current_time_hm <= value }.first
      namaz_name, namaz_time = times.first if namaz_time.blank?
      time_diff = Time.parse(namaz_time) - Time.parse(current_time_hms)
      [namaz_name, time_diff.abs]

      Time.zone = nil

      Hashie::Mash.new(namaz_name: namaz_name, time_remaining_in_seconds: time_diff.abs)
    end

  end
end
