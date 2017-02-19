require 'namaz/version'

require 'hashie'
require 'multi_json'
require 'faraday'

module Namaz
  DEFAULT_API_URL = 'http://api.aladhan.com'

  class << self
    # Retrieve the namaz timings for a given latitude, longitude, timezonestring and method.
    #
    # @param latitude [Float] Latitude.
    # @param longitude [Float] Longitude.
    # @param timezonestring [String]
    # @param method [Integer]
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

      namaz_response = connection.get(namaz_url, params)
      return Hashie::Mash.new(MultiJson.load(namaz_response.body)).data.timings if namaz_response.success?
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
  end
end
