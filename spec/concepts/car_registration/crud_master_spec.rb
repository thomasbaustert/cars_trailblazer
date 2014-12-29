require 'spec_helper'

describe "Crud by master role" do
  let(:master) { build_master_user }

  describe "Update" do

    let(:car_registration) {
      CarRegistration::Create[car_registration: { number_plate: "HH AB 100", chassis_number: "ABCD1234" }].model
    }

    it "persists valid" do
      CarRegistration::Update[id: car_registration.id, current_user: master,
                              car_registration: { number_plate: "HH AB 101", chassis_number: "WXYZ5678" }]
      car_registration.reload
      expect(car_registration.number_plate).to eq "HH AB 101"
      expect(car_registration.chassis_number).to eq "WXYZ5678"
    end
  end
end
