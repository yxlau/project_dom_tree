
class DOMTree
  attr_reader :document, :html, :stack

  def initialize(file_path)
    raise 'File not found' unless File.exists?(file_path)
    @html = HTMLLoader.new(file_path).html
    @stack = []
    doctype_strip
    add_root
    parse_html
  end

  def parse_html
    until @html.length == 0
      parse_opening
      parse_text
      parse_closing
    end
  end

  def parse_closing
    return unless snippet = @html.match(/^<\/([\w]+)(.*?)\s*>/)
    node = Node.new(snippet[1], :close, nil, [], @stack[-1], @stack[-1].depth)
    @stack[-1].children << node
    @stack.pop
    @html = snippet.post_match
    node
  end

  def parse_text
    return unless snippet = @html.match(/^\s*([^<]+)\s*/)
    node = Node.new('text', :text, {'content' => snippet[1]}, [], @stack[-1], @stack[-1].depth + 1)
    @stack[-1].children << node
    @html = snippet.post_match
    node
  end

  def parse_opening
    return unless snippet = @html.match(/^<([\w]+)(.*?)>\s*/)
    atts = parse_atts(snippet[2])
    node = Node.new(snippet[1], :open, atts, [], @stack[-1], @stack[-1].depth + 1)
    @stack[-1].children << node
    @stack << node
    @html = snippet.post_match
    node
  end

  def doctype_strip
    if m = @html.match(/<!doctype html>/)
      @html = m.post_match
    end
  end

  def add_root
    tag = @html.match(/^<([\w]+)(.*?)>\s*/)
    atts = parse_atts(tag[2])
    @document = Node.new(tag[1], :open, atts, [], [], 0)
    @stack << @document
    @html = tag.post_match
  end

  def parse_atts(tag)
    attributes = tag.scan(/([\w]+)\s*=\s*['|"](.*?)['|"]/)
    atts = {}
    unless attributes.empty?
      attributes.each do |att|
        atts[att[0]] = att[1]
      end
    end
    atts = atts.empty? ? nil : atts
  end


  def print_tree
    puts "<!doctype html>"
    queue = [@document]
    until   queue.empty?
      current = queue.shift
      print_opener(current) if current.type == :open
      print_text(current) if current.type == :text
      print_closer(current) if current.type == :close
      current.children.reverse_each do |child|
        queue.unshift(child)
      end
    end
    puts
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
