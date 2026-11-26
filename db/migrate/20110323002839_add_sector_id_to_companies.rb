class AddSectorIdToCompanies < ActiveRecord::Migration[4.2]
  def up
    add_column :companies, :sector_id, :integer, :index => true
  end

  def down
    remove_column :companies, :sector_id
  end
end
