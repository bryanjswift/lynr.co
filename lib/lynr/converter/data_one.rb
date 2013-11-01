require 'libxml'

require './lib/lynr/model/vin'

module Lynr; module Converter;

  class XmlConverter

    def self.contents(context, xpath)
      enum = context.find(xpath) if context
      (enum || []).map { |node| node.content }
    end

    def self.values(context, xpath)
      enum = context.find(xpath) if context
      (enum || []).map { |node| node.value }
    end

  end

  class DataOne < XmlConverter

    def self.xml_to_vin(query_response)
      return Lynr::Model::Vin.inflate(nil) if query_response.nil?
      us_data = query_response.find('.//us_market_data/common_us_data').first
      ext_colors = (contents(us_data, './/exterior_colors//generic_color_name')) || []
      int_colors = (contents(us_data, './/interior_colors//generic_color_name')) || []
      Lynr::Model::Vin.new(
        values(us_data, './/transmission/@name').first,
        contents(us_data, './/fuel_type').first,
        contents(us_data, './/doors').first,
        contents(us_data, './/drive_type').first,
        (ext_colors.length >= 1 && ext_colors.join(', ')) || ext_colors.first,
        (int_colors.length >= 1 && int_colors.join(', ')) || int_colors.first,
        query_response['identifier'],
        query_response.to_s
      )
    end

  end

end; end;

module LibXML; module XML;

  class Node

    def to_vin
      raise Exception.new if self.name != 'query_response'
      Lynr::Converter::DataOne.xml_to_vin(self)
    end

  end

end; end;
