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
      # TODO/29.12.14/06:04/tb record is build or loaded here already. Where to put my keep_copy_record?
      # Overwrite model!(params)?

      validate(params[:car_registration]) do |f|
        f.save

        write_protocol
        send_mail
      end
    end

    private
      def write_protocol
      end

      def send_mail
      end
  end

  class Update < Create
    action :update

    builds do |params|
      if params[:current_user].master_role?
        Master
      else
        User
      end
    end

    class Master < self
      # permission to update everything
    end

    class User < self
      contract do
        property :chassis_number, writeable: false
      end
    end
  end

end