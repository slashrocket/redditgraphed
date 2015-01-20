class AddAuthorAndPermalinkToSubscribersTable < ActiveRecord::Migration
  def change
    add_column :subscribers, :author, :text
    add_column :subscribers, :permalink, :text
  end
end
