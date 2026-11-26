class AddCompaniesPeopleRelationship < ActiveRecord::Migration[4.2]
  def up
    add_column :people, :company_id, :integer, :index => true
  end

  def down
    remove_column :people, :company_id
  end
end
