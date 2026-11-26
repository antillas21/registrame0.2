class CreateRegistrations < ActiveRecord::Migration[4.2]
  def up
    create_table :registrations do |t|
      t.string :name

      t.timestamps
    end
  end

  def down
    drop_table :registrations
  end
end
