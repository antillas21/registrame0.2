class CreateInterests < ActiveRecord::Migration[4.2]
  def up
    create_table :interests do |t|
      t.string :name

      t.timestamps
    end
  end

  def down
    drop_table :interests
  end
end
