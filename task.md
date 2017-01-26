# The Project

## Task
- Read in the full DOM and parse it into data structure  
- Write tests to make life easier

1. Look at the upcoming sections of the project so you have an idea of what needs to be done

2. Write out your strategy for parsing the DOM tree using comments atop your solutions file.

3. Walk through the supplied HTML file line by line using your strategy and verify that all edge cases are being covered (the warmups above should have helped you think through some common issues here).

## The Tree
- Start from root node called `document`
- Ignore stuff like `href` and `name` for now
- Assume tags are closed properly, and no solitary tags like `<img>` or `<hr>`
- OK to ignore or remove `<!doctype html>`
- Must handle cases where text occus in multiple places inside a tag (not just the naive case where it's always first)
- Example usage:

```ruby
reader = DOMReader.new
tree = reader.build_tree('test.html')
```

## Testing
- Happy and sad paths! 
1. Can your parse handle simple tas?
2. Can your parse handle tags with attributes?
3. Can your parser handle simple nested tags?
4. Can your parse handle text both beter and after a nested tag?
5. Does your tree hav ethe correct number of total nodes?

## Renderer
- Build a renderer class(tree)
- Outputs key statistics about its nodes and their subtrees 
- Statistics:
  - How many total nodes there are in the sub-tree below this node
  - A count of each node type in the sub-tree below this node
  - All fo the node's data attritubes
  - Passing in `nil` returns statistics for the entire document (the root node)

## Searcher
- The tree searhcer traverses the tree nodes looking for particular characteristics
- It should allow you to search for nodes that match name, text, id, class

```ruby
searcher = TreeSearcher.new(tree)
sidebars = searcher.search_by(:class, "sidebar")
sidebars.each { |node| renderer.render(node) }
# ...output for all nodes...
```

2. Search only descendents of a partiulcar node

```ruby
# Note: Yes, it should probably be called 
#   `search_descendents` instead...
searcher.search_children(some_node, :id, "key-section")
```

3. Search the direct ancestors of a particular node 

```ruby
searcher.search_ancestors(some_node, :class, "wrapper")

```

### Rebuilding the Dom
- Add functionality that allows you to rebuild the original HTML file from the tree
- Add a simple functionality that adds reasonable spacing between lines so you can scan and read the file yourself 