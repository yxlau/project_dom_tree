describe 'DOMReader' do
  let(:reader){ DOMReader.new('spec/test.html')}
  describe '#initialize' do
    it 'raises an error if file not found' do
      expect{DOMReader.new('nofile.html')}.to raise_error('File not found')
    end
  end
end
