# TODO/29.12.14/05:27/tb otherwise I get 'uninitialized constant CarRegistration::Create'...
require 'car_registration/crud'

class CarRegistrationsController < ApplicationController
  # TODO/29.12.14/05:21/tb otherwise I get 'unknown method form'!?
  include Trailblazer::Operation::Controller

  def index
    @car_registrations = CarRegistration.all
  end

  def new
    form CarRegistration::Create
  end

  def create
    run CarRegistration::Create do
      redirect_to car_registrations_url
    end
  end

  def edit
    form CarRegistration::Update
    #render action: :new
  end

  def update
    run CarRegistration::Update do
      redirect_to car_registrations_url
    end
  end

  private

    # TODO/29.12.14/05:44/tb I prefer 'process_params' which returns a copy of params and modifies
    # the original params
    def process_params!(params)
      #params.dup.update(user: current_user)
      params.merge!(user: current_user)
    end

    def current_user
      User.new(firstname: "John", lastname: "Doe", email: "john.doe@example.org")
    end

end