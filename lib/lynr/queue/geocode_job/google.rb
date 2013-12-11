require 'geocoder'
require 'georuby'

require './lib/lynr'
require './lib/lynr/model/address'
require './lib/lynr/model/dealership'
require './lib/lynr/persist/dealership_dao'
require './lib/lynr/queue/job'

module Lynr; class Queue;

  module GeocodeJob

    class Google < Job

      def initialize(dealership)
        @dealership = dealership
        @address = dealership.address
      end

      def perform
        description = "Geocode for #{@dealership.id} -- #{@address.line_one}, #{@address.postcode} --"
        if (!geocodable?) then return failure("#{description} line_one and zip not specified", :no_requeue) end
        results = Geocoder.search("#{@address.line_one}, #{@address.postcode}")
        if (results.length == 0) then return failure("#{description} returned no results", :no_requeue) end
        addresses = results.map do |result|
          lnglat = result.coordinates.reverse
          Lynr::Model::Address.new(
            'line_one' => result.street_address,
            'city' => result.city,
            'state' => result.state_code,
            'zip' => result.postal_code,
            'geo' => GeoRuby::SimpleFeatures::Point.from_lon_lat(*lnglat)
          )
        end
        dao = Lynr::Persist::DealershipDao.new
        dao.save(@dealership.set(address: addresses.first) if addresses.first != @dealership.address
        Success
      rescue Geocoder::OverQueryLimitError
        failure("#{description} after limit reached. Retrying later.")
      rescue Geocoder::Error => ge
        failure("#{description} errored. #{ge.class.name} -- #{ge.message}", :no_requeue)
      end

      protected

      def geocodable?
        line_one = @address.line_one
        postcode = @address.postcode
        !(@address.nil? || line_one.nil? || line_one.empty? || postcode.nil? || postcode.empty?)
      end

    end

  end

end; end;
