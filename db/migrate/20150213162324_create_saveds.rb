class CreateSaveds < ActiveRecord::Migration
  def change
    create_table :saveds do |t|
      t.references :user, index: true
      t.references :subscriber, index: true

      t.timestamps null: false
    end
    add_foreign_key :saveds, :users
    add_foreign_key :saveds, :subscribers
  end
end
