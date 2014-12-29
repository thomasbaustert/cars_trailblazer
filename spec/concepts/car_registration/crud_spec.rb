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


    it "invalid description" do
      res, op = CarRegistration::Create.run(car_registration: { number_plate: "HH AB 100", chassis_number: "ABC" })

      expect(res).to be_false
      expect(op.model.persisted?).to be_false
      expect(op.contract.errors.to_s).to eq "{:chassis_number=>[\"is too short (minimum is\ 4 characters)\"]}"
    end
  end

end
