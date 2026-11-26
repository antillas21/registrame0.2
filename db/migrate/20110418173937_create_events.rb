class CreateEvents < ActiveRecord::Migration[4.2]
  def up
    create_table :events do |t|
      t.string :name
      t.string :venue
      t.text :info
      t.date :date

      t.timestamps
    end
  end

  def down
    drop_table :events
  end
end
