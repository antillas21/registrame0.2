class CreateInterestsAndPeopleRelationship < ActiveRecord::Migration[4.2]
  def up
    create_table :interests_people, :id => false do |t|
      t.integer :person_id
      t.integer :interest_id
      t.timestamps
    end
    add_index :interests_people, :person_id
    add_index :interests_people, :interest_id
  end

  def down
    drop_table :interests_people
  end
end
