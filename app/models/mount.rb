class Mount < ApplicationRecord
  belongs_to :source, class_name: 'Folder'
  belongs_to :target, class_name: 'Folder'
end
