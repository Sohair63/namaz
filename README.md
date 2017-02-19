# Namaz
[namaz](https://aladhan.com/prayer-times-api) API wrapper in Ruby.
Namaz is aladhan.com wrapper in ruby to use REST API that is open for public use. The API only supports the GET method and returns JSON.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'namaz'
```

For latest code:

```ruby
gem 'namaz', git: 'git@github.com:Sohair63/namaz.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install namaz

# Usage
Make sure you require the library, where you want to use it, Or require in `application.rb` to use all over the application.

```ruby
require 'namaz'
```

You can then make requests to the following method.
```ruby
## Using Altitudes:
Namaz.timings(latitude:, longitude:, timezonestring:, method:, options: {})
## Using City and Country Information:
Namaz.timings(city:, country:, method:, options: {})
```

### Examples:
```ruby
# Using Altitudes:
Namaz.timings(latitude: 31.5546, longitude: 74.3572, timezonestring: "Asia/Karachi", method: 1, options: {timestamp: Time.now.to_i})
# Using City and Country Information:
Namaz.timings(city: 'Karachi', country: 'PK', method: 1, options: {timestamp: Time.now.to_i})
```

##### Example Request Using Altitudes

```ruby
timings = Namaz.timings(latitude: 31.5546, longitude: 74.3572, timezonestring: "Asia/Karachi", method: 1, options: {timestamp: Time.now.to_i})
```
##### Example Request Using Country and City Information

```ruby
timings = Namaz.timings(city: 'Karachi', country: 'PK', method: 1, options: {state: 'Punjab', timestamp: Time.now.to_i})
```
##### Example Response

```ruby
 => #<Hashie::Mash Asr="15:27" Dhuhr="12:16" Fajr="05:19" Imsak="05:09" Isha="19:14" Maghrib="17:53" Midnight="00:17" Sunrise="06:41" Sunset="17:53">

timings.Fajr
 => "05:19"
```

### Parameters Description
* **timestamp OPTIONAL** - `DEFAULT = Time.now.to_i` a UNIX timestamp (from any time of the day) of the day for which you want the timings. If you don't specify a timestamp, the result will come back for today - today being the date in the Europe/London timezone.

* **latitude** - the decimal value for the latitude co-ordinate of the location you want the time computed for. Example: 51.75865125
* **longitude** - the decimal value for the longitude co-ordinate of the location you want the time computed for. Example: -1.25387785
* **timezonestring** - A valid timezone name as specified on http://php.net/manual/en/timezones.php. Example: Europe/London


* **city** - A city name. Example: London
* **country** - A country name or 2 character alpha ISO 3166 code. Example: GB or United Kindom
* **state** - State or province (optional). A state name or abbreviation. Example: Colorado / CO / Punjab / Bengal

* **method** - these are the different methods identifying various schools of thought about how to compute the timings. This parameter accepts values from 0-7, as signified below:
    * 0 - Shia Ithna-Ashari
    * 1 - University of Islamic Sciences, Karachi
    * 2 - Islamic Society of North America (ISNA)
    * 3 - Muslim World League (MWL)
    * 4 - Umm al-Qura, Makkah
    * 5 - Egyptian General Authority of Survey
    * 7 - Institute of Geophysics, University of Tehran

## Optional HTTP Configuration
The HTTP requests are made with [Faraday](https://github.com/lostisland/faraday), which uses `Net::HTTP` by default. Changing the adapter is easy. We will use typhoeus as an example.

Make sure to include the typhoeus gem in your `Gemfile`:

```ruby
gem 'typhoeus'
```

```ruby
require 'typhoeus/adapters/faraday'

Faraday.default_adapter = :typhoeus
```

Alternatively:

```ruby
require 'typhoeus/adapters/faraday'

Namaz.connection = Faraday.new do |builder|
  builder.adapter :typhoeus
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Copyright

Copyright (c) 2013-2016 Sohair S. Ahmad. See LICENSE.txt for further details.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/namaz. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
