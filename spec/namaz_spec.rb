require 'spec_helper'

describe Namaz do
  context 'version test' do
    it 'has a version number' do
      expect(Namaz::VERSION).not_to be nil
    end
  end

  context 'unit tests' do
    let(:latitude)  { 31.5546061 }
    let(:longitude) { 74.3571581 }
    let(:timezonestring) { 'Asia/Karachi' }
    let(:method_number) { 1 }
    let(:country_code) { 'PK' }
    let(:state) { 'Punjab' }
    let(:city_1) { 'Karachi' }
    let(:city_2) { 'Lahore' }

    let(:month) { '02' }
    let(:year) { '2017' }

    context 'timings' do
      it 'sends with altitudes request' do
        namaz_time = Namaz.timings(latitude: latitude, longitude: longitude, timezonestring: timezonestring, method: method_number)
        expect(namaz_time).to_not be_nil
      end

      it 'sends with city name request' do
        namaz_time = Namaz.timings_by_city(city: city_1, country: country_code, method: method_number)
        expect(namaz_time).to_not be_nil
      end

      it 'altitude and city name return same response' do
        namaz_time = Namaz.timings(latitude: latitude, longitude: longitude, timezonestring: timezonestring, method: method_number)
        namaz_time_city = Namaz.timings_by_city(city: city_2, country: country_code, method: method_number)
        expect(namaz_time).to eq(namaz_time_city)
      end

      it 'different altitude and city name return different response' do
        namaz_time = Namaz.timings(latitude: latitude, longitude: longitude, timezonestring: timezonestring, method: method_number)
        namaz_time_city = Namaz.timings_by_city(city: city_1, country: country_code, method: method_number)
        expect(namaz_time).to_not eq(namaz_time_city)
      end
    end

    context 'calendar' do
      it 'sends altitudes without month and year request' do
        namaz_calendar = Namaz.calendar(latitude: latitude, longitude: longitude, timezonestring: timezonestring, method: method_number)
        expect(namaz_calendar).to_not be_nil

        date = Time.parse(namaz_calendar.first.date.readable).to_date
        current_time = Time.now
        end_of_month = Date.civil(current_time.year, current_time.month, -1)

        expect(namaz_calendar.length).to be == end_of_month.day
        expect(date.month).to be Time.now.to_date.month
        expect(date.year).to be Time.now.to_date.year
      end

      it 'sends altitudes with month and year optional params request' do
        namaz_calendar = Namaz.calendar(latitude: latitude, longitude: longitude, timezonestring: timezonestring, method: method_number, options: {month: month, year: year})
        expect(namaz_calendar).to_not be_nil

        date = Time.parse(namaz_calendar.first.date.readable).to_date
        end_of_month = Date.civil(year.to_i, month.to_i, -1)

        expect(namaz_calendar.length).to be == end_of_month.day
        expect(date.month).to be month.to_i
        expect(date.year).to be year.to_i
      end

      it 'sends with city and country name without year and month params request' do
        namaz_calendar = Namaz.calendar_by_city(city: city_1, country: country_code, method: method_number)
        expect(namaz_calendar).to_not be_nil

        date = Time.parse(namaz_calendar.first.date.readable).to_date
        current_time = Time.now
        end_of_month = Date.civil(current_time.year, current_time.month, -1)

        expect(namaz_calendar.length).to be == end_of_month.day
        expect(date.month).to be Time.now.to_date.month
        expect(date.year).to be Time.now.to_date.year
      end

      it 'sends with city and country name with year and month params request' do
        namaz_calendar = Namaz.calendar_by_city(city: city_1, country: country_code, method: method_number, options: {month: month, year: year})
        expect(namaz_calendar).to_not be_nil

        date = Time.parse(namaz_calendar.first.date.readable).to_date
        end_of_month = Date.civil(year.to_i, month.to_i, -1)

        expect(namaz_calendar.length).to be == end_of_month.day
        expect(date.month).to be month.to_i
        expect(date.year).to be year.to_i
      end
    end

    context 'city geolocation information' do
      it 'varify the correct city geolocation information latitude longitude and timezone' do
        city_info = Namaz.city_info(city: 'Lahore', country: 'Pakistan')

        expect(city_info.longitude).to eq(longitude.to_s)
        expect(city_info.latitude).to eq(latitude.to_s)
        expect(city_info.timezone).to eq(timezonestring)
      end

      it 'varify the correct city geolocation information with optional parameters' do
        city_info = Namaz.city_info(city: city_2, country: country_code, options: {state: state})

        expect(city_info.longitude).to eq(longitude.to_s)
        expect(city_info.latitude).to eq(latitude.to_s)
        expect(city_info.timezone).to eq(timezonestring)
      end
    end

    context 'address geolocation information' do
      it 'varify the correct address geolocation information latitude longitude and timezone' do
        address_info = Namaz.address_info(address: 'London, Canary Wharf, London, UK')

        expect(address_info).to_not be_nil
        expect(address_info.longitude).to_not be_nil
        expect(address_info.latitude).to_not be_nil
        expect(address_info.timezone).to eq('Europe/London')
      end

      it 'varify the correct partial address geolocation information latitude longitude and timezone' do
        address_info = Namaz.address_info(address: 'London, Canary Wharf, London, UK')

        expect(address_info).to_not be_nil
        expect(address_info.longitude).to_not be_nil
        expect(address_info.latitude).to_not be_nil
        expect(address_info.timezone).to eq('Europe/London')
      end
    end
  end

end
