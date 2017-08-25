class CreateUserSource < ActiveRecord::Migration
  def change
    create_table :user_sources do |t|
      t.integer :user_id
      t.integer :source_id

      t.timestamps
    end
  end
end
