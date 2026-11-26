class AddCountryIdToCompanies < ActiveRecord::Migration[4.2]
  def up
    add_column :companies, :country_id, :integer, :index => true
  end

  def down
    remove_column :companies, :country_id
  end
end

