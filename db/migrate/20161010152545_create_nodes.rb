class CreateNodes < ActiveRecord::Migration[5.0]
  def change
    create_table :nodes do |t|
      t.string :title
      t.text :content
      t.integer :folder_id

      t.timestamps
    end
  end
end
