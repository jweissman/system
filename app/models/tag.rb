class Tag
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def nodes
    Node.all.select do |node|
      node.tags.include?(name)
    end
  end
end
