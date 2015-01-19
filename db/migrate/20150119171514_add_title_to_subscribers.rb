class AddTitleToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :title, :text
  end
end
