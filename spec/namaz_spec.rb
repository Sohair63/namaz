require 'spec_helper'

describe Namaz do
  context 'version test' do
    it 'has a version number' do
      expect(Namaz::VERSION).not_to be nil
    end
  end

  context 'unit tests' do
    let(:latitude)  { 31.5546 }
    let(:longitude) { 74.3572 }
    let(:timezonestring) { 'Asia/Karachi' }
    let(:method_number) { 1 }
    let(:country_code) { 'PK' }
    let(:city_1) { 'Karachi' }
    let(:city_2) { 'Lahore' }

    context 'without default parameters' do
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
  end

end
