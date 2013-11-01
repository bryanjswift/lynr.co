require 'lynr/controller/admin'
require 'lynr/model/vehicle'
require 'lynr/model/sized_image'
require 'lynr/view/menu'

module Lynr; module Controller;

  class AdminVehicle < Lynr::Controller::Admin

   def self.create_route(path, method_name, verb)
     method = method_name.to_sym
     Sly::Route.new(verb, path, lambda { |req|
       controller = self.new
       controller.before_each(req) || controller.send(method, req)
     })
   end

    get  '/admin/:slug/:vehicle',        :get_vehicle
    get  '/admin/:slug/vehicle/add',     :get_add
    post '/admin/:slug/vehicle/add',     :post_add
    get  '/admin/:slug/:vehicle/edit',   :get_edit_vehicle
    post '/admin/:slug/:vehicle/edit',   :post_edit_vehicle
    get  '/admin/:slug/:vehicle/menu',   :get_vehicle_menu
    get  '/admin/:slug/:vehicle/photos', :get_edit_vehicle_photos
    post '/admin/:slug/:vehicle/photos', :post_edit_vehicle_photos
    get  '/admin/:slug/:vehicle/delete', :get_delete_vehicle
    post '/admin/:slug/:vehicle/delete', :post_delete_vehicle

    def initialize
      super
      @base_menu = Lynr::View::Menu.new('Vehicle Menu', "", :menu_vehicle)
    end

    # BEFORE HANDLING
    def before_each(req)
      response = nil
      response = unauthorized unless authorized?(req)
      @dealership = dealer_dao.get(BSON::ObjectId.from_string(req['slug']))
      @vehicle = vehicle_dao.get(BSON::ObjectId.from_string(req['vehicle'])) if !req['vehicle'].nil?
      response = not_found if @dealership.nil? or (!req['vehicle'].nil? and @vehicle.nil?)
      case req.request_method
        when 'GET'  then before_GET(req)
        when 'POST' then before_POST(req)
      end
      response
    end

    def before_GET(req)
      @menu_secondary = @base_menu.set_href("/admin/#{@dealership.slug}/#{@vehicle.slug}/menu") if !@vehicle.nil?
      @posted = @vehicle.view if !@vehicle.nil?
    end

    def before_POST(req)
      @posted = req.POST.dup
      posted['dealership'] = @dealership
    end

    # Handle view vehicle
    def get_vehicle(req)
      @subsection = 'vehicle-view'
      @title = "#{@vehicle.name}"
      render 'admin/vehicle/view.erb'
    end

    def get_vehicle_menu(req)
      @menu_vis = 'menu-visible-secondary'
      get_vehicle(req)
    end

    # Handle add vehicle
    def get_add(req)
      @subsection = 'vehicle-add'
      @title = 'Add Vehicle'
      render 'admin/vehicle/add.erb'
    end

    def post_add(req)
      vehicle = vehicle_dao.save(Lynr::Model::Vehicle.inflate(@posted))
      redirect "/admin/#{@dealership.slug}/#{vehicle.slug}/edit"
    end

    # Handle edit vehicle
    def get_edit_vehicle(req)
      @subsection = 'vehicle-edit'
      @title = "Edit #{@vehicle.name}"
      render 'admin/vehicle/edit.erb'
    end

    def post_edit_vehicle(req)
      # Need to inflate the Mpg and Vin views that come from posted data
      posted['mpg'] = Lynr::Model::Mpg.inflate(posted['mpg'])
      posted['vin'] = Lynr::Model::Vin.inflate(posted['vin'])
      vehicle_dao.save(@vehicle.set(posted))
      redirect "/admin/#{@dealership.slug}/#{@vehicle.slug}/edit"
    end

    # Handle edit photos
    def get_edit_vehicle_photos(req)
      @subsection = 'vehicle-photos'
      @title = "Photos for #{@vehicle.name}"
      @transloadit_params = transloadit_params('vehicle_template_id').to_json
      render 'admin/vehicle/photos.erb'
    end

    def post_edit_vehicle_photos(req)
      posted['images'] = JSON.parse(posted['images']).map { |image| Lynr::Model::SizedImage.inflate(image) }
      vehicle_dao.save(@vehicle.set(posted))
      redirect "/admin/#{@dealership.slug}/#{@vehicle.slug}/edit"
    end

    # Handle delete vehicle
    def get_delete_vehicle(req)
      @subsection = 'vehicle-delete'
      @title = "Delete #{@vehicle.name}"
      render 'admin/vehicle/delete.erb'
    end

    def post_delete_vehicle(req)
      posted['deleted_at'] = Time.now
      vehicle_dao.save(@vehicle.set(posted))
      redirect "/admin/#{@dealership.slug}"
    end

  end

end; end;
