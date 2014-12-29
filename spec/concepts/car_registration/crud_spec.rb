require 'spec_helper'
require 'car_registration/crud'

describe "Crud" do

  describe "Create" do

    it "persists valid" do
      car_registration = CarRegistration::Create[car_registration: { number_plate: "HH AB 100" }].model

      expect(car_registration.persisted?).to be_true
      expect(car_registration.number_plate).to eq "HH AB 100"
    end

    it "invalid" do
      res, op = CarRegistration::Create.run(car_registration: { number_plate: "" })

      expect(res).to be_false
      expect(op.model.persisted?).to be_false
      expect(op.contract.errors.to_s).to eq "{:number_plate=>[\"can't be blank\"]}"
    end


    it "invalid chassis_number" do
      res, op = CarRegistration::Create.run(car_registration: { number_plate: "HH AB 100", chassis_number: "ABC" })

      expect(res).to be_false
      expect(op.model.persisted?).to be_false
      expect(op.contract.errors.to_s).to eq "{:chassis_number=>[\"is too short (minimum is\ 4 characters)\"]}"
    end
  end

  describe "Update" do
    # TODO/29.12.14/04:53/tb this will write protocol entry, send emails etc too
    # but I only want a record to be created!?
    # Is it a bit like create an AR model and the after hook is called each time?

    let(:car_registration) {
      CarRegistration::Create[car_registration: { number_plate: "HH AB 100", chassis_number: "ABCD1234" }].model
    }

    it "persists valid, ignores chassis_number" do
      CarRegistration::Update[id: car_registration.id, car_registration: { number_plate: "HH AB 101",
                                                                           chassis_number: "ABCD5678" }]
      car_registration.reload
      expect(car_registration.number_plate).to eq "HH AB 101"
      expect(car_registration.chassis_number).to eq "ABCD1234"
    end
  end
end
