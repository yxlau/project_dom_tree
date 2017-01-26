require 'node_renderer'
require 'dom_tree'
require 'dom_reader'
require 'node'

describe 'NodeRenderer' do
  let(:tree){DOMTree.new('spec/test.html')}
  describe '#initialize' do
    it 'raises an error if argument is not a tree' do
      expect{NodeRenderer.new('jk')}.to raise_error('Please pass in a tree!')
    end
  end

  describe '#renderer' do
    it 'defaults to the entire dom if no argument passed' do
      r = NodeRenderer.new(tree)
      r.render
      allow(r).to receive(:set_up_stack).and_return(nil)
      expect(r.node).to eq(r.tree)
    end
  end

  describe '#get_stats' do

    it 'should count the right number of nodes' do
      n = NodeRenderer.new(tree)
      n.render
      allow(n).to receive(:print_attributes).and_return(nil)
      expect(n.node_count).to eq(46)
    end

    it 'should count the right number of tags' do
      n = NodeRenderer.new(tree)
      n.render
      expect(n.node_types['li']).to eq(13)
    end
  end


  describe '#set_up_stack' do
    let(:tree){DOMTree.new('spec/test4.html')}
    it 'returns nil if node has no children' do
      n = NodeRenderer.new(tree)
      n.instance_variable_set(:@node, Node.new('div', :open, '', [], nil, 0))
      n.render
      expect(STDOUT).to receive(:puts)
    end
  end

end
