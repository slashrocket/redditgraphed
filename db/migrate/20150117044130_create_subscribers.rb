class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.integer :count
      t.text :subreddit

      t.timestamps null: false
    end
  end
end
