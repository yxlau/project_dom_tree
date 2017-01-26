require 'tree_searcher'

describe 'TreeSearcher' do
  let(:d){DOMReader.new.build_tree('spec/test3.html')}

  describe '#search_by' do

    it 'populates the @results' do
      t = TreeSearcher.new(d)
      t.search_by('class', 'top-div')
      expect(t.results.size).to eq(2)
    end

  end

  describe '#search_descendants' do
    it 'populates the @results' do
      t = TreeSearcher.new(d)
      t.search_by('class', 'main-body')
      t.search_descendants(t.results[0], 'class', 'top-div' )
      expect(t.results.size).to eq(2)
    end
  end

end
