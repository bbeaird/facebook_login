class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :facebook_access_token

      t.timestamps
    end
  end
end
