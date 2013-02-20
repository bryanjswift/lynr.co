require './lib/quicklist/model/base'

module Quicklist; module Model;

  class Image

    include Base

    attr_reader :width, :height, :url

    def initialize(width, height, url)
      @width = width.to_i
      @height = height.to_i
      @url = url
    end

    def view
      { width: @width, height: @height, url: @url }
    end

    def self.inflate(record)
      Quicklist::Model::Image.new(record[:width], record[:height], record[:url])
    end

  end

end; end;
