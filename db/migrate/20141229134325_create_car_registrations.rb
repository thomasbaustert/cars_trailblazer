class CreateCarRegistrations < ActiveRecord::Migration
  def change
    create_table :car_registrations do |t|
      t.integer   :policy_id
      t.string    :number_plate
      t.string    :vehicle_type
      t.string    :chassis_number
      t.date      :registration_date
      t.date      :deregistration_date
    end
  end
end
