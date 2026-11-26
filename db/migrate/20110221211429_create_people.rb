class CreatePeople < ActiveRecord::Migration[4.2]
  def up
    create_table :people do |t|
      t.string :fname
      t.string :lname
      t.string :email
      t.string :job

      t.timestamps
    end
    add_index :people, :email, :unique => true
  end

  def down
    drop_table :people
  end
end
