class AddPrintedToPeople < ActiveRecord::Migration[4.2]
  def up
    add_column :people, :printed, :boolean, :default => false
    add_index :people, :printed
  end

  def down
    remove_column :people, :printed
  end
end
