require_relative 'html_loader'
require_relative 'node'
require_relative 'dom_tree'
require_relative 'node_renderer'
require_relative 'tree_searcher'

class DOMReader
  attr_reader :tree, :renderer, :searcher
  def initialize(file_path=nil)
    if file_path
      raise "File not found" unless File.exists?(file_path)
      build_tree(file_path)
      build_renderer(@tree)
      build_searcher(@tree)
    end
  end

  def build_tree(file_path)
    @tree = DOMTree.new(file_path)
  end

  def build_renderer(tree)
    @renderer = NodeRenderer.new(tree)
  end

  def build_searcher(tree)
    @searcher = TreeSearcher.new(tree)
  end

end
