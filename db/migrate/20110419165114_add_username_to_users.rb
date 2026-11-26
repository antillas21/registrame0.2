class AddUsernameToUsers < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :username, :string
  end

  def down
    remove_column :users, :username
  end
end
