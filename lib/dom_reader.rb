# this class builds a DOMTree
#
# it has a #build_tree method that accepts an html file
# #build_tree:
# - accepts an html file and gets HTMLLoader to stringify it
# - HTMLLoader returns an html file as a string (HTMLLoader(file).html ??)
# - calls parse_html
# - stores root in `document`
require_relative 'html_loader'
require_relative 'node'
require_relative 'dom_tree'

class DOMReader
  attr_reader :html,  :stack, :document
  def initialize
    @stack = []
  end

  def build_tree(file_path)
    raise 'File not found' unless File.exists?(file_path)
    @html = HTMLLoader.new(file_path).html
    doctype_strip
    add_root
    parse_html
    DOMTree.new(@document)

  end

  def tree
    DOMTree.new(@document)

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
    node = Node.new(snippet[1], :close, nil, [], @stack[-1], @stack[-1].depth + 1)
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

end
