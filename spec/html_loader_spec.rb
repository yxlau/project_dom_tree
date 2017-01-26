require 'html_loader'

describe HTMLLoader do
  let(:l){ HTMLLoader.new('test.html') }
  describe '#initialize' do
    it 'calls html_to_string' do
      expect_any_instance_of(HTMLLoader).to receive(:html_to_string).with('test.html')
      l
    end
    it 'allows access to the html string' do
      expect{l.html}.not_to raise_error
    end
  end

  describe '#html_to_string' do
    it 'returns a string' do
      expect(l.html_to_string('test.html')).to be_a(String)
    end
  end
end
