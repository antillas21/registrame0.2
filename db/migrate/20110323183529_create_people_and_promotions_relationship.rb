class CreatePeopleAndPromotionsRelationship < ActiveRecord::Migration[4.2]
  def up
    create_table :people_promotions, :id => false do |t|
      t.integer :person_id
      t.integer :promotion_id
    end
    add_index :people_promotions, :person_id
    add_index :people_promotions, :promotion_id
  end

  def down
    drop_table :people_promotions
  end
end
