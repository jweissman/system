require "#{Rails.root}/lib/system/client"

class RemoteMount < ApplicationRecord
  belongs_to :target, class_name: 'Folder'

  def children
    client.folders
  end

  def nodes
    client.files
  end

  def client
    @client ||= System.client(hostname: host)
  end
end
