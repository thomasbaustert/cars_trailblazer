class CarRegistration < ActiveRecord::Base

  class Create < Trailblazer::Operation
    include CRUD
    model CarRegistration, :create

    contract do
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
end