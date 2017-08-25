class CreateSource < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name
      t.string :code_name
      t.string :category
    end
  end
end
