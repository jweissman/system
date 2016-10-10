class Node < ApplicationRecord
  belongs_to :folder

  TAG_REGEX = /#([\S]+)/

  def tags
    return [] unless content =~ TAG_REGEX
    content.scan(TAG_REGEX).reduce(&:+)
  end
end
