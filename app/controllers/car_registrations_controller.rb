class CarRegistrationsController < ApplicationController

  def index
    @car_registrations = CarRegistration.all
  end

  def new
    form CarRegistration::Create
  end

  def create
    run CarRegistration::Create
  end

  def edit
    @car_registration = CarRegistration.find(params[:id])
  end

  def update
    @car_registration = CarRegistration.find(params[:id])
    @car_registration.attributes = params[:car_registration]
    if @car_registration.valid?
      @car_registration.save!
      redirect_to car_registrations_url
    else
      render action: :edit
    end
  end

end