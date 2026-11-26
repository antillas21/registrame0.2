class CreateNameBadges < ActiveRecord::Migration[4.2]
  def up
    create_table :name_badges do |t|
      t.string :name
      t.float :width
      t.float :height
      t.float :left
      t.float :right
      t.float :top
      t.float :bottom

      t.timestamps
    end
    add_index :name_badges, :name
  end

  def down
    drop_table :name_badges
  end
end
