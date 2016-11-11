class AddUserToFolders < ActiveRecord::Migration[5.0]
  def change
    add_reference :folders, :user, foreign_key: true
  end
end
