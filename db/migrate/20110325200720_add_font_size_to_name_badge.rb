class AddFontSizeToNameBadge < ActiveRecord::Migration[4.2]
  def up
    add_column :name_badges, :font_size, :integer
  end

  def down
    remove_column :name_badges, :font_size
  end
end
