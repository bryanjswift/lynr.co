require 'rack'

require './lib/sly/exceptions'
require './lib/sly/node'
require './lib/sly/route'
require './lib/sly/router'
require './lib/sly/urlmap'

# # `Sly`
#
# Top level for the Sly framework. It provides direct access to the `Sly::Router`
# instance to which `Sly::Route` instances are added. Additionally it exposes the
# `Director` via the `Sly.core` method which allows it to be run directly as a
# Rack application.
#
module Sly

  # ## `Sly::DynaMap`
  #
  # Alternative mapping of `Sly::Route` instances to URI patterns.
  #
  DynaMap = Sly::URLMap.new

  # ## `Sly::Director`
  #
  # Responsible for doing the initial handling of a request and then handing the
  # request off to an appropriate `Sly::Route` for processing.
  #
  Director = Sly::Router.new

  # ## `Sly.add(route)`
  #
  # Adds a `Sly::Route` instance to `Director` and `DynaMap`.
  #
  def self.add(route)
    Sly::DynaMap.map(route.path, route)
    Sly::Director.add(route)
  end

  # ## `Sly.core`
  #
  # Expose `Sly::Director` to the world for running it as a standalone Rack
  # application.
  #
  def self.core
    Sly::Director
  end

  # # `Sly::App`
  #
  # Entry point for running a `Sly` application as middleware. `Sly::App#call`
  # is the Rack entry point for a web application. `Sly::App` uses `Innate::Optioned`
  # to setup options for the Sly web application.
  #
  # If an error traces back to here it is likely coming out of `#call` and from
  # a `Sly::Route` defined elsewhere and added to the `Sly::Router`.
  #
  # ## Options
  #
  # * `cascade`, whether or not to pass un-matched requests on to downstream apps.
  #   Defaults to false but should be set to true if `Sly::App` is used as middleware.
  # * `root`, directory the root resides in. Used as the basis for template path
  #   generation. Defaults to directory of the script being executed.
  # * `views`, path -- from root -- to the location of views. Defaults to 'views'.
  # * `layouts`, path -- from root -- to the location of layouts. Defaults to 'layouts'.
  # * `partials`, path -- from root -- to the location of partials. Defaults to 'partials'.
  #
  class App

    def self.add(route)
      Sly::DynaMap.map(route.path, route)
      Sly::Director.add(route)
    end

    def initialize(app, opts={})
      @app = app
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

  end

end
