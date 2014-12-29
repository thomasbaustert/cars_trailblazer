# TODO/29.12.14/04:52/tb I don't like the dependency to AR here
# cause it is all about the namespace CarRegistration here.
# ActiveRecord::Base can be removed if the original model is loaded before this class.
#class CarRegistration < ActiveRecord::Base
class CarRegistration

  class Create < Trailblazer::Operation
    include CRUD
    model CarRegistration, :create

    contract do
      model CarRegistration # this will be infered in the next trb release.

      property :number_plate
      property :chassis_number

      validates :number_plate, presence: true
      validates :chassis_number, length: { in: 4..160 }, allow_blank: true
    end

    def process(params)
      validate(params[:car_registration]) do |f|
        f.save
      end
    end
  end

  class Update < Create
    action :update

    contract do
      property :chassis_number, writeable: false
    end
  end

end