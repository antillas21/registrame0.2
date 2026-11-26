class AddRegistrationsToPeople < ActiveRecord::Migration[4.2]
  def up
    add_column :people, :registration_id, :integer, :index => true
  end

  def down
    remove_column :people, :registration_id
  end
end
