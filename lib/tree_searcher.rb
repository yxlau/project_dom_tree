class TreeSearcher
  attr_reader :results
  def initialize(tree)
    @tree = tree.tree
  end

  def search_by(att, val)
    @results = []
    #search entire tree
    queue = [@tree]
    search_loop(queue, att, val)
    @results
  end

  def search_descendants(node, att, val)
    @results = []
    queue = []
    add_children(node, queue)
    search_loop(queue, att, val)
  end

  def search_loop(queue, att, val)
    until queue.empty?
      current = queue.shift
      add_match(current, att, val)
      add_children(current, queue)
    end
  end

  def add_match(current, att, val)
    if attributes = current.attributes
      attributes.each do |key, v|
        if key == att
          if val.class == Regexp
            @results << current if v.match(/#{val}/)
          else
            @results << current if v == val
          end
        end
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
