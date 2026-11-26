class CreateSectors < ActiveRecord::Migration[4.2]
  def up
    create_table :sectors do |t|
      t.string :name

      t.timestamps
    end
    add_index :sectors, :name, :unique => true
  end

  def down
    drop_table :sectors
  end
end
