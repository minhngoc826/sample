class CreateMics < ActiveRecord::Migration[5.0]
  def change
    create_table :mics do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
  end
end
