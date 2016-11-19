class AddThemeToFolders < ActiveRecord::Migration[5.0]
  def change
    add_column :folders, :theme, :string
  end
end
