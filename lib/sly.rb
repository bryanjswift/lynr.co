require 'rack'
require 'innate'

require './lib/sly/node'
require './lib/sly/route'
require './lib/sly/router'
require './lib/sly/urlmap'

module Sly

  DynaMap = Sly::URLMap.new
  Director = Sly::Router.new([])

  class App

    include Innate::Optioned

    options.dsl do

      o "Whether or not to Cascade to downstream apps",
        :cascade, false

      o "The directory this application resides in",
        :root, File.dirname($0)

      o "Directory containing the view templates",
        :views, 'views'

      o "Directory containing the layout templates",
        :layouts, 'layouts'

      o "The directory containing partial views",
        :partials, 'partials'

    end

    def self.add(route)
      Sly::DynaMap.map(route.path, route)
      Sly::Director.add(route)
    end

    def self.setup(opts={})
      options.merge! opts
    end

    def initialize(app, opts={})
      @app = app
      Sly::App.setup opts
    end

    def call(env)
      status, headers, body = Sly::Director.call(env)
      # Behave like a cascade
      if (Sly::App.options.cascade && headers.include?("X-Cascade"))
        @app.call(env)
      else
        [status, headers, body]
      end
    end

    def self.core
      Sly::Director
    end

  end

end
