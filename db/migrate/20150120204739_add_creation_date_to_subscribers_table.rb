class AddCreationDateToSubscribersTable < ActiveRecord::Migration
  def change
    add_column :subscribers, :post_created_at, :text
  end
end
