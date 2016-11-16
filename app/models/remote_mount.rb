require "#{Rails.root}/lib/system/client"

class RemoteMount < ApplicationRecord
  belongs_to :target, class_name: 'Folder'

  def children
    client.folders
  end

  def client
    @client ||= System.client(hostname: host)
  end

  # def path
  #   target_path + title + '/'
  # end
end