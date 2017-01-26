class HTMLLoader
  attr_reader :html
  def initialize(file_path)
    html_to_string(file_path)
  end

  def html_to_string(file_path)
    html_string = File.readlines(file_path).map do |line|
      line.strip
    end
    @html = html_string.join('')
  end
end
