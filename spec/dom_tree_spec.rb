require 'dom_reader'
require 'html_loader'
require 'node'

describe 'DOMTree' do
  let(:tree){ DOMTree.new('spec/test.html') }
  before do
    allow(tree).to receive(:parse_html).and_return(nil)
  end
  describe '#initialize' do
    it 'stores an empty array in @stack' do
      expect(tree.instance_variable_get(:@stack)).to eq([])
    end
    it 'raises an error if file not found' do
      expect{DOMTree.new('fjke.html')}.to raise_error('File not found')
    end
    it 'does not raise an error if file found' do
      expect{DOMTree.new('spec/test.html')}.not_to raise_error
    end

    it '@html should be a string' do
      expect(tree.instance_variable_get(:@html)).to be_a(String)
    end

  end

  describe '#parse_closing' do
    let(:node){instance_double(Node, depth: 2, children: [])}
    let(:node2){ instance_double(Node, depth:1, children:[])}
    before(:each) do
      tree.instance_variable_set(:@stack, [node, node2])
    end
    it 'returns if snippet is not a closing tag' do
      tree.instance_variable_set(:@html, '<div>')
      expect(tree.parse_closing).to eq(nil)
    end

    it 'does not return if snippet is a closing tag' do
      tree.instance_variable_set(:@html, '</div>')
      expect(tree.parse_closing).not_to be_nil
    end

    it 'trims the html string' do
      tree.instance_variable_set(:@html, '</div>hello, world</div>')
      tree.parse_closing
      expect(tree.html).to eq('hello, world</div>')
    end

    # it 'updates its parent\'s children attribute' do
    #   tree.instance_variable_set(:@html, '</div>hk')
    #   current = tree.stack[0]
    #   tree.instance_variable_set(:@stack, [current, current])
    #   tree.parse_closing
    #   expect(tree.stack[-1].children.size).not_to eq(0)
    # end

    it 'removes the last element in the stack' do
      tree.instance_variable_set(:@html, '</div>hk')
      old = tree.stack[-1]
      tree.parse_closing
      expect(tree.stack[-1]).not_to eq(old)
    end

    context 'it creates a node with the proper attributes' do
      before do
        tree.instance_variable_set(:@html, '</div>hk')
      end
      it 'has the proper type' do
        a = tree.parse_closing
        expect(a.type).to eq(:close)
      end
      it 'has the proper tag' do
        a = tree.parse_closing
        expect(a.tag).to eq('div')
      end
    end
  end


  describe '#parse_opening' do
    let(:node){instance_double(Node, depth: 2, children: [])}
    let(:node2){ instance_double(Node, depth:1, children:[])}
    before(:each) do
      tree.instance_variable_set(:@stack, [node, node2])
    end
    it 'returns if snippet is not an opening tag' do
      tree.instance_variable_set(:@html, '</div>')
      expect(tree.parse_opening).to eq(nil)
    end

    it 'does not return if snippet is an opening tag' do
      tree.instance_variable_set(:@html, '<div class="some-class">')
      expect(tree.parse_opening).not_to be_nil
    end

    it 'trims the html string' do
      tree.instance_variable_set(:@html, '<div>text </div>')
      tree.parse_opening
      expect(tree.html).to eq('text </div>')
    end

    # it 'updates its parent\'s children attribute' do
    #   tree.parse_opening
    #   expect(tree.stack[0].children.size).not_to eq(0)
    # end

    context 'it creates a node with the proper attributes' do
      before do
        tree.instance_variable_set(:@html, '<div class="abc 12-b" id="my-id">hk')
      end
      it 'has the proper type' do
        a = tree.parse_opening
        expect(a.type).to eq(:open)
      end
      it 'has the proper tag' do
        a = tree.parse_opening
        expect(a.tag).to eq('div')
      end
      it 'has the proper tag attributes' do
        a = tree.parse_opening
        expect(a.attributes['class']).to eq('abc 12-b')
        expect(a.attributes['id']).to eq('my-id')
      end
    end
  end

  describe '#parse_text' do
    let(:node){instance_double(Node, depth: 2, children: [], type: 'div')}
    let(:node2){ instance_double(Node, depth:1, children:[], type:'div')}
    before(:each) do
      tree.instance_variable_set(:@stack, [node, node2])

    end
    it 'returns if snippet is not plain text' do
      tree.instance_variable_set(:@html, '</div>')
      expect(tree.parse_text).to eq(nil)
    end

    it 'does not return if snippet is plain text' do
      tree.instance_variable_set(:@html, 'hello, i\'m plain text')
      expect(tree.parse_text).not_to be_nil
    end

    it 'trims the html string' do
      tree.instance_variable_set(:@html, 'some plain text   </div>')
      tree.parse_text
      expect(tree.html).to eq('</div>')
    end

    it 'updates its parent\'s children attribute' do
      tree.instance_variable_set(:@html, 'some plain text   </div>')
      tree.parse_text
      expect(tree.stack[-1].children).not_to eq([])
    end

    it 'does not add self to stack' do
      expect(tree.stack[-1].type).not_to eq(:text)
    end

    context 'it creates a node with the proper attributes' do
      before do
        tree.instance_variable_set(:@html, 'a fine day to be out')
      end
      it 'has the proper type' do
        a = tree.parse_text
        expect(a.type).to eq(:text)
      end
      it 'has the proper tag' do
        a = tree.parse_text
        expect(a.tag).to eq('text')
      end
      it 'has the proper tag attributes' do
        a = tree.parse_text
        expect(a.attributes['content']).to eq('a fine day to be out')
      end
    end
  end

  describe '#doctype_strip' do
    it 'removes <!doctype html>' do
      tree.doctype_strip
      expect(tree.html.match(/<!doctype html>/)).to be_nil
    end
  end

  describe '#add_root' do
    it 'creates a root node called @document' do
      expect(tree.document).to be_a(Node)
    end
  end

end
