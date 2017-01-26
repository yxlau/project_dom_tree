require 'dom_reader'
require 'html_loader'
require 'node'

describe 'DOMReader' do
  let(:reader){ DOMReader.new }
  before do
    allow(reader).to receive(:parse_html).and_return(nil)
  end
  describe '#initialize' do
    it 'stores an empty array in @stack' do
      stack = reader.instance_variable_get(:@stack)
      expect(stack).to eq([])
    end
  end

  describe '#build_tree' do

    it 'raises an error if file not found' do


      expect{reader.build_tree('text.html')}.to raise_error('File not found')
    end

    it 'does not raise an error if file found' do
      expect{reader.build_tree('spec/test.html')}.not_to raise_error
    end

    it '@html should be a string' do
      reader.build_tree('spec/test.html')
      expect(reader.html).to be_a(String)
    end

    it 'calls parse_html' do
      expect(reader).to receive(:parse_html)
      reader.build_tree('spec/test.html')
    end

  end

  # describe '#parse_html' do
  # end

  describe '#parse_closing' do
    before do
      reader.build_tree('spec/test.html')
    end
    it 'returns if snippet is not a closing tag' do
      reader.instance_variable_set(:@html, '<div>')
      expect(reader.parse_closing).to eq(nil)
    end

    it 'does not return if snippet is a closing tag' do
      reader.instance_variable_set(:@html, '</div class="some-class">')
      expect(reader.parse_closing).not_to be_nil
    end

    it 'trims the html string' do
      reader.instance_variable_set(:@html, '</div>hello, world</div>')
      reader.parse_closing
      expect(reader.html).to eq('hello, world</div>')
    end

    # it 'updates its parent\'s children attribute' do
    #   reader.instance_variable_set(:@html, '</div>hk')
    #   current = reader.stack[0]
    #   reader.instance_variable_set(:@stack, [current, current])
    #   reader.parse_closing
    #   expect(reader.stack[-1].children.size).not_to eq(0)
    # end

    it 'removes the last element in the stack' do
      reader.instance_variable_set(:@html, '</div>hk')
      old = reader.stack[-1]
      reader.parse_closing
      expect(reader.stack[-1]).not_to eq(old)
    end

    context 'it creates a node with the proper attributes' do
      before do
        reader.instance_variable_set(:@html, '</div>hk')
      end
      it 'has the proper type' do
        a = reader.parse_closing
        expect(a.type).to eq(:close)
      end
      it 'has the proper tag' do
        a = reader.parse_closing
        expect(a.tag).to eq('div')
      end
    end
  end


  describe '#parse_opening' do
    before do
      reader.build_tree('spec/test.html')
    end

    it 'returns if snippet is not an opening tag' do
      reader.instance_variable_set(:@html, '</div>')
      expect(reader.parse_opening).to eq(nil)
    end

    it 'does not return if snippet is an opening tag' do
      reader.instance_variable_set(:@html, '<div class="some-class">')
      expect(reader.parse_opening).not_to be_nil
    end

    it 'trims the html string' do
      reader.instance_variable_set(:@html, '<div>text </div>')
      reader.parse_opening
      expect(reader.html).to eq('text </div>')
    end

    # it 'updates its parent\'s children attribute' do
    #   reader.parse_opening
    #   expect(reader.stack[0].children.size).not_to eq(0)
    # end

    context 'it creates a node with the proper attributes' do
      before do
        reader.instance_variable_set(:@html, '<div class="abc 12-b" id="my-id">hk')
      end
      it 'has the proper type' do
        a = reader.parse_opening
        expect(a.type).to eq(:open)
      end
      it 'has the proper tag' do
        a = reader.parse_opening
        expect(a.tag).to eq('div')
      end
      it 'has the proper tag attributes' do
        a = reader.parse_opening
        expect(a.attributes['class']).to eq('abc 12-b')
        expect(a.attributes['id']).to eq('my-id')
      end
    end
  end

  describe '#parse_text' do
    before do
      reader.build_tree('spec/test.html')
    end
    it 'returns if snippet is not plain text' do
      reader.instance_variable_set(:@html, '</div>')
      expect(reader.parse_text).to eq(nil)
    end

    it 'does not return if snippet is plain text' do
      reader.instance_variable_set(:@html, 'hello, i\'m plain text')
      expect(reader.parse_text).not_to be_nil
    end

    it 'trims the html string' do
      reader.instance_variable_set(:@html, 'some plain text   </div>')
      reader.parse_text
      expect(reader.html).to eq('</div>')
    end

    it 'updates its parent\'s children attribute' do
      reader.instance_variable_set(:@html, 'some plain text   </div>')
      reader.parse_text
      expect(reader.stack[-1].children).not_to eq([])
    end

    it 'does not add self to stack' do
      expect(reader.stack[-1].type).not_to eq(:text)
    end

    context 'it creates a node with the proper attributes' do
      before do
        reader.instance_variable_set(:@html, 'a fine day to be out')
      end
      it 'has the proper type' do
        a = reader.parse_text
        expect(a.type).to eq(:text)
      end
      it 'has the proper tag' do
        a = reader.parse_text
        expect(a.tag).to eq('text')
      end
      it 'has the proper tag attributes' do
        a = reader.parse_text
        expect(a.attributes['content']).to eq('a fine day to be out')
      end
    end
  end

  describe '#parse_closing' do
  end

  describe '#doctype_strip' do
    it 'removes <!doctype html>' do
      reader.build_tree('spec/test.html')
      reader.doctype_strip
      expect(reader.html.match(/<!doctype html>/)).to be_nil
    end
  end

  describe '#add_root' do
    before do
      reader.build_tree('spec/test.html')
    end
    it 'creates a root node called @document' do
      expect(reader.document).to be_a(Node)
    end
    it 'adds the root node to the stack' do
      expect(reader.stack.size).to eq(1)
      expect(reader.stack[0]).to eq(reader.document)
    end
  end

end
