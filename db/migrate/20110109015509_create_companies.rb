class CreateCompanies < ActiveRecord::Migration[4.2]
  def up
    create_table :companies do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city

      t.timestamps
    end
    add_index :companies, :name
    add_index :companies, :city
  end

  def down
    drop_table :companies
  end
end

