class CreateMounts < ActiveRecord::Migration[5.0]
  def change
    create_table :mounts do |t|
      t.integer :source_id
      t.integer :target_id

      t.timestamps
    end
  end
end
