class AddWebsiteToEvents < ActiveRecord::Migration[4.2]
  def up
    add_column :events, :website, :string
  end

  def down
    remove_column :events, :website
  end
end
