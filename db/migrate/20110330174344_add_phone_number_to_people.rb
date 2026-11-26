class AddPhoneNumberToPeople < ActiveRecord::Migration[4.2]
  def up
    add_column :people, :phone, :string
  end

  def down
    remove_column :people, :phone
  end
end
