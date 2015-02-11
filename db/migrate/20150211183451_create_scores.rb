class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :score
      t.references :subscriber, index: true

      t.timestamps null: false
    end
    add_foreign_key :scores, :subscribers
  end
end
