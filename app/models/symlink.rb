class Symlink < ApplicationRecord
  belongs_to :target, class_name: 'Folder'
end
