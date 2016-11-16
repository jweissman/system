class CreateRemoteMounts < ActiveRecord::Migration[5.0]
  def change
    create_table :remote_mounts do |t|
      t.string :host
      t.integer :target_id
      t.string :source_path
    end
  end
end
