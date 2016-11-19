class CreateSymlinks < ActiveRecord::Migration[5.0]
  def change
    create_table :symlinks do |t|
      t.string :source_path
      t.integer :target_id
    end
  end
end
