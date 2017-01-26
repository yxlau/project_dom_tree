require_relative 'dom_tree'
require_relative 'dom_reader'
require_relative 'node'

class NodeRenderer
  attr_reader :node, :tree, :node_count, :node_types
  def initialize(tree)
    raise 'Please pass in a tree!' unless tree.is_a?(DOMTree)
    @tree = tree.tree
  end

  def render(node=nil)
    @node = node ? node : @tree
    # total nodes in the sub-tree below this node
    set_up_stack
    get_stats
    print_stats
    print_attributes
    # no. of each type of node in the sub-tree below this node
    # all of the node's data attributes
  end

  def set_up_stack
    if @node.children.empty?
      puts "Sorry! This node has no sub-nodes!"
      exit
    end
    @stack = []
    @node.children.each do |child|
      @stack << child
    end
  end

  def print_stats
    puts "There are #{@node_count} node(s) in the sub-tree beneath the node <#{@node.tag} #{print_attributes}>:"
    @node_types.each do |k, v|
      puts "- #{k}: #{v}"
    end
    puts

  end

  def print_attributes
    str = ''
    if @node.attributes
      @node.attributes.each do |key, val|
        str << "#{key}=\"#{val}\""
      end
    end
    str
  end

  def get_stats
    @node_count = 0
    @node_types = {}
    until @stack.empty?
      current = @stack.shift
      add_node_types(current)
      add_nodes(current)
      if current.children
        current.children.each { |child| @stack << child }
      end
    end
  end

  def add_node_types(node)
    return if node.type == :close
    @node_types[node.tag] ? @node_types[node.tag] += 1 : @node_types[node.tag] = 1
  end

  def add_nodes(node)
    return if node.type == :close
    @node_count += 1
  end



end
