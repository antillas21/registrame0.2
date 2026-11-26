class CreateCountries < ActiveRecord::Migration[4.2]
  def up
    create_table :countries do |t|
      t.string :name, :index => true

      t.timestamps
    end
  end

  def down
    drop_table :countries
  end
end

