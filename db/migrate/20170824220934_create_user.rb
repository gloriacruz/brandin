class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :title
      t.string :email
      t.string :linkedin_token
      t.string :industry
      t.string :sharing_frequency
      t.string :email_frequency

      t.timestamps
    end

  end
end
