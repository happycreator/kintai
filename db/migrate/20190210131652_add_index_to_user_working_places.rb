class AddIndexToUserWorkingPlaces < ActiveRecord::Migration[5.0]
  def change
    add_index :user_working_places, :user_id
    add_index :user_working_places, :working_place_id
    add_index :user_working_places, [:user_id, :working_place_id], unique: true
  end
end