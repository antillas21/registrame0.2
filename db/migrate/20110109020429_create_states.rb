class CreateStates < ActiveRecord::Migration[4.2]
  def up
    create_table :states do |t|
      t.string :name

      t.timestamps
    end
    add_index :states, :name
  end

  def down
    drop_table :states
  end
end

