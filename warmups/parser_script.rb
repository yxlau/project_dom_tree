
Node = Struct.new(:tag, :type, :attributes, :children, :parent)

def parser_script(file)
  DocumentTree.new(file)
end

class DocumentTree
  attr_reader :html
  attr_writer :html
  def initialize( html )
    @html = html
    @stack = []
    build_tree
    print_tree
  end

  def build_tree
    add_root
    until @html.length == 0
      parse_opening
      parse_text
      parse_closing
      remove_blank_line
    end
  end

  def parse_opening
    return unless snippet = @html.match(/^<([\w]+)(.*?)>\s*/)
    atts = parse_atts(snippet[2])
    node = Node.new(snippet[1], :open, atts, [], @stack[-1])
    @stack[-1].children << node
    @stack << node
    @html = snippet.post_match

  end

  def parse_closing
    return unless snippet = @html.match(/^<\/([\w]+)(.*?)\s*>/)
    node = Node.new(snippet[1], :close, nil, [], @stack[-1])
    @stack[-1].children << node
    @stack.pop
    @html = snippet.post_match
  end

  def remove_blank_line
    if snippet = @html.match(/^(\s*)/)
      @html = snippet.post_match
    end
  end

  def parse_text
    return unless snippet = @html.match(/^\s*([^<]+)\s*/)
    node = Node.new('text', :text, {'content' => snippet[1]}, [], @stack[-1])
    @stack[-1].children << node
    @html = snippet.post_match
  end

  def parse_atts(str)
    attributes = str.scan(/([\w]+)\s*=\s*['|"](.*?)['|"]/)
    atts = {}
    unless attributes.empty?
      attributes.each do |att|
        atts[att[0]] = att[1]
      end
    end
    atts
  end


  def add_root
    tag = @html.match(/^<([\w]+)(.*?)>\s*/)
    atts = parse_atts(tag[2])
    @root = Node.new(tag[1], :open, atts, [], [])
    @stack << @root
    @html = tag.post_match
  end

  def print_tree
    queue = [@root]
    until   queue.empty?
      current =   queue.shift
      print_opener(current) if current.type == :open
      print_text(current) if current.type == :text
      print_closer(current) if current.type == :close
      current.children.reverse_each do |child|
        queue.unshift(child)
      end
    end
  end

  def print_closer(current)
    puts "</#{current.tag}>"
  end

  def print_text(current)
    puts current.attributes['content']
  end

  def print_opener(current)
    if current.attributes
      atts = ''
      current.attributes.map {|k, v| atts += "#{k}=\"#{v}\""}
      puts "<#{current.tag}#{atts}>"
    else
      puts "<#{current.tag}>"
    end
  end

end

html_string = "<div>  div text before  <p>    p text  </p>  <div>    more div text  </div>  div text after</div>"


d = DocumentTree.new(html_string)
