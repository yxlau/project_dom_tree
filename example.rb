require_relative 'lib/dom_reader'
require_relative 'lib/html_loader'
require_relative 'lib/node_renderer'
require_relative 'lib/tree_searcher'
require_relative 'lib/node'

reader = DOMReader.new.build_tree('test.html')
renderer = NodeRenderer.new(reader)
searcher = TreeSearcher.new(reader)
reader.print_tree
list = searcher.search_by('class', 'emphasized')
list.each { |node| renderer.render(node)}
