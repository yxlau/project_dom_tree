require_relative 'lib/dom_reader'
require_relative 'lib/html_loader'
require_relative 'lib/node_renderer'
require_relative 'lib/tree_searcher'
require_relative 'lib/node'

# usage:
# reader = DOMReader.new('...')
reader = DOMReader.new('spec/test3.html')
tree = reader.tree
tree.print_tree
renderer = reader.renderer
searcher = reader.searcher
list = searcher.search_by('class', /top-div/)
list.each { |node| renderer.render(node)}
