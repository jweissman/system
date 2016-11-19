class Tag
  TAG_REGEX = /#([\S]+)/
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def nodes
    Node.all.select do |node|
      node.tags.include?(name)
    end
  end

  def self.match(content)
    return [] unless content =~ TAG_REGEX
    content.scan(TAG_REGEX).reduce(&:+).reject do |match|
      match.include?('#')
    end
  end
end
