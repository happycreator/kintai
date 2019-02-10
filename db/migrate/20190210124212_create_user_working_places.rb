class CreateUserWorkingPlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :user_working_places do |t|
      t.integer :user_id
      t.integer :working_place_id

      t.timestamps
    end
  end
end
