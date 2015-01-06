require 'spec_helper'

describe "Crud by user role" do
  let(:user) { build_user }

  describe "Create" do

    it "persists valid" do
      car_registration = CarRegistration::Create[current_user: user, car_registration: { number_plate: "HH AB 100" }].model

      expect(car_registration.persisted?).to be_true
      expect(car_registration.number_plate).to eq "HH AB 100"
    end

    it "invalid" do
      res, op = CarRegistration::Create.run(current_user: user, car_registration: { number_plate: "" })

      expect(res).to be_false
      expect(op.model.persisted?).to be_false
      expect(op.contract.errors.to_s).to eq "{:number_plate=>[\"can't be blank\"]}"
    end


    it "invalid chassis_number" do
      res, op = CarRegistration::Create.run(current_user: user,
                                            car_registration: { number_plate: "HH AB 100", chassis_number: "ABC" })

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
      CarRegistration::Create[current_user: user,
                              car_registration: { number_plate: "HH AB 100", chassis_number: "ABCD1234" }].model
    }

    it "persists valid, ignores chassis_number" do
      CarRegistration::Update[id: car_registration.id, current_user: user,
                              car_registration: { number_plate: "HH AB 101", chassis_number: "WXYZ5678" }]
      car_registration.reload
      expect(car_registration.number_plate).to eq "HH AB 101"
      expect(car_registration.chassis_number).to eq "ABCD1234"
    end
  end

  # DISCUSS/06.01.15/07:57/tb
  # This is a way of using validations running the whole operation including "after save actions",
  # like write_protocol, send_email, ...
  describe "Update using contract only" do
    let(:operation) { CarRegistration::Create.new.present({}) }

    it "works" do
      # We have to pass the model params here not the full params.
      # Q: How can we pass current_user cause we need it during validation?
      # A: We don't have to pass it cause we have a own contract per role!
      # operation.validate(current_user: user, car_registration: { number_plate: "HH AB 100", chassis_number: "ABCD1234" })
      result = operation.validate(number_plate: "HH AB 100", chassis_number: "ABCD1234")
      expect(result).to be_true
    end
  end

end
