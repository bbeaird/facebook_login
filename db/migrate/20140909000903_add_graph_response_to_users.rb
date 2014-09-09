class AddGraphResponseToUsers < ActiveRecord::Migration
  def change
    add_column :users, :graph_response, :text
  end
end
