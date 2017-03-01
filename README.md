# Namaz
[namaz](https://aladhan.com/prayer-times-api) ruby gem is an API wrapper.
Namaz is aladhan.com wrapper in ruby to use REST API that is open for public use.

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

## Timings
Returns all prayer times for a specific date and for a specific date in a city. You can then make requests to the following method.
```ruby
## Using Altitudes:
Namaz.timings(latitude:, longitude:, timezonestring:, method:, options: {})
## Using City and Country Information:
Namaz.timings_by_city(city:, country:, method:, options: {})
```

### Examples:

##### Example Request and response Using Altitudes

```ruby
timings = Namaz.timings(latitude: 31.5546, longitude: 74.3572, timezonestring: "Asia/Karachi", method: 1, options: {timestamp: Time.now.to_i})

#=> #<Hashie::Mash Asr="15:27" Dhuhr="12:16" Fajr="05:19" Imsak="05:09" Isha="19:14" Maghrib="17:53" Midnight="00:17" Sunrise="06:41" Sunset="17:53">

timings.Fajr
#=> "05:19"
```
##### Example Request Using Country and City Information

```ruby
timings = Namaz.timings_by_city(city: 'Karachi', country: 'PK', method: 1, options: {state: 'Punjab', timestamp: Time.now.to_i})

#<Hashie::Mash Asr="15:27" Dhuhr="12:16" Fajr="05:19" Imsak="05:09" Isha="19:14" Maghrib="17:53" Midnight="00:17" Sunrise="06:41" Sunset="17:53">

timings.Fajr
#=> "05:19"
```

## Calender
Returns prayer times for a specific month (in a given year) and for a specific month in a city
```ruby
## Using City and Country Information:
Namaz.calender_by_city(city:, country:, method:, options: {})
## Using City and Country Information:
Namaz.calendar(latitude:, longitude:, timezonestring:, method:, options: {})
```

#### Optional Params
`(options: {month: '8', year: '2017', state: 'Punjab' })`
- **month** - 1 or 2 digit month. Example: '08' or '8' for August, **DEFAULT is current month**, if not given
- **year** - 4 digit year. Example: 2017, **DEFAULT is current year**, if not given


### Examples:

##### Example Request and response Using Altitudes
```ruby
calendar = Namaz.calendar(latitude: 31.5546, longitude: 74.3572, timezonestring: "Asia/Karachi", method: 1, options: {month: '02', year: '2017'})

calendar.first
#<Hashie::Mash date=#<Hashie::Mash readable="01 Feb 2017" timestamp="1485921661"> timings=#<Hashie::Mash Asr="15:15 (PKT)" Dhuhr="12:16 (PKT)" Fajr="05:32 (PKT)" Imsak="05:22 (PKT)" Isha="19:00 (PKT)" Maghrib="17:37 (PKT)" Midnight="00:16 (PKT)" Sunrise="06:55 (PKT)" Sunset="17:37 (PKT)">>

calendar.first.timings
#=> #<Hashie::Mash Asr="15:15 (PKT)" Dhuhr="12:16 (PKT)" Fajr="05:32 (PKT)" Imsak="05:22 (PKT)" Isha="19:00 (PKT)" Maghrib="17:37 (PKT)" Midnight="00:16 (PKT)" Sunrise="06:55 (PKT)" Sunset="17:37 (PKT)">

calendar.first.timings.Asr
#=> "15:15 (PKT)"

calendar.first.date
#<Hashie::Mash readable="01 Feb 2017" timestamp="1485921661">
```

##### Example Request Using Country and City Information

```ruby
calendar = Namaz.calender_by_city(city: 'Lahore', country: 'PK', method: 2, options: {month: '02', year: '2017'})

calendar.first
#<Hashie::Mash date=#<Hashie::Mash readable="01 Feb 2017" timestamp="1485921661"> timings=#<Hashie::Mash Asr="15:54 (PKT)" Dhuhr="12:46 (PKT)" Fajr="05:56 (PKT)" Imsak="05:46 (PKT)" Isha="19:35 (PKT)" Maghrib="18:17 (PKT)" Midnight="00:46 (PKT)" Sunrise="07:14 (PKT)" Sunset="18:17 (PKT)">>

calendar.first.timings
#=> #<Hashie::Mash Asr="15:31 (PKT)" Dhuhr="12:15 (PKT)" Fajr="05:23 (PKT)" Imsak="05:13 (PKT)" Isha="19:07 (PKT)" Maghrib="18:01 (PKT)" Midnight="00:15 (PKT)" Sunrise="06:30 (PKT)" Sunset="18:01 (PKT)">

calendar.first.timings.Asr
#=> "15:31 (PKT)"

calendar.first.date
#<Hashie::Mash readable="01 Feb 2017" timestamp="1485921661">
```

## City Information
Returns City Geolocation Info of latitude, longitude and timezone for a given city
### Example:
```ruby
city_info = Namaz.city_info(city: 'Lahore', country: 'PK', options: {state: 'Punjab'})
#<Hashie::Mash latitude="31.5546061" longitude="74.3571581" timezone="Asia/Karachi">
city_info.longitude
# => "74.3571581"
city_info.timezone
# => "Asia/Karachi"
```

## Address Information
Returns Address Geolocation Info of latitude, longitude and timezone for a given city

### Additional Parameter

**address** - A complete address string. Example: 10 Upper Bank Street, London, Canary Wharf, London, UK

### Examples:
```ruby
address_info = address_info(address: '10 Upper Bank Street, London, Canary Wharf, London, UK')
#<Hashie::Mash latitude="51.5026562" longitude="-0.0171995" timezone="Europe/London">
                                -- OR --
address_info = address_info(address: 'Upper Bank Street, London, Canary Wharf, London, UK')
#<Hashie::Mash latitude=51.5045201 longitude=-0.0171009 timezone="Europe/London">
                                -- OR --
address_info = address_info(address: 'Bank Street, London, Canary Wharf, London, UK')
#<Hashie::Mash latitude=51.5035329 longitude=-0.0213304 timezone="Europe/London">
```

## General Parameters Description
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

## CHANGE LOG:

* **0.1.3:** Added methods `calendar` and `calendar_by_city`
* **0.1.2:** Updated method name for Timings information for city from `timings` to `timings_by_city`
* **0.1.1:** Added new request Using Country and City Information
* **0.1.0:** Request Using Altitudes

## TODO:
Follow the link https://aladhan.com/prayer-times-api and add patch by creating a Pull Rquest, I will merge and publish new version

* Timings by Address
* Calendar by Address

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Copyright

Copyright (c) 2013-2016 Sohair S. Ahmad. See LICENSE.txt for further details.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Sohair63/namaz. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.
