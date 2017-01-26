class TreeSearcher
  attr_reader :results
  def initialize(tree)
    @tree = tree.tree
  end

  def search_by(att, val)
    @results = []
    #search entire tree
    queue = [@tree]
    until queue.empty?
      current = queue.shift
      add_match(current, att, val)
      if current.children
        current.children.each { |child| queue << child }
      end
    end
    @results
  end

  def add_match(current, att, val)
    if attributes = current.attributes
      attributes.each do |key, v|
        @results << current if v == val && key == att
      end
    end
  end

  def search_descendants(node, att, val)
    @results = []
    queue = []
    add_children(node, queue)
    until queue.empty?
      current = queue.shift
      add_match(current, att, val)
      if current.children
        current.children.each { |child| queue << child}
      end
    end

  end

  def add_children(node, queue)
    if node.children
      node.children.each do |child|
        queue << child
      end
    end
  end


end
