class DOMTree
  attr_reader :tree
  def initialize(tree)
    @tree = tree
  end

  def print_tree
    queue = [@tree]
    until   queue.empty?
      current = queue.shift
      print_opener(current) if current.type == :open
      print_text(current) if current.type == :text
      print_closer(current) if current.type == :close
      current.children.reverse_each do |child|
        queue.unshift(child)
      end
    end
  end

  def print_closer(current)
    puts "#{' ' * current.depth }</#{current.tag}>"
  end

  def print_text(current)
    puts "#{' ' * current.depth } #{current.attributes['content']}"
  end

  def print_opener(current)
    if current.attributes
      atts = ''
      current.attributes.map {|k, v| atts += "#{k}=\"#{v}\""}
      puts "#{' ' * current.depth }<#{current.tag} #{atts}>"
    else
      puts "#{' ' * current.depth }<#{current.tag}>"
    end
  end
end
