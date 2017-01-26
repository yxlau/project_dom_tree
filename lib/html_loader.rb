# initializes with a file path
# reads contents of file path and stores it as an html string in #html_string
# calls html_to_string


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
