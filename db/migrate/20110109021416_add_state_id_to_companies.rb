class AddStateIdToCompanies < ActiveRecord::Migration[4.2]
  def up
    add_column :companies, :state_id, :integer, :index => true
  end

  def down
    remove_column :companies, :state_id
  end
end

