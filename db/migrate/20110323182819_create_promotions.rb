class CreatePromotions < ActiveRecord::Migration[4.2]
  def up
    create_table :promotions do |t|
      t.string :name

      t.timestamps
    end
  end

  def down
    drop_table :promotions
  end
end
