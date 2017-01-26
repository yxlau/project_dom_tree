Tag = Struct.new(:tag, :type, :classes, :name, :id)

def parse_tag(str)
  tag = str.match(/<([\w]+).*?>/) ? str.match(/<([\w]+).*?>/)[1]  : 'text'
  type = str.match(/<[^\/](.*?)>/) ? 'open' : str.match(/<\/(.*?)>/) ? 'close' : 'text'
  classes = str.match(/class\s*=\s*["|'](.*?)["|']/)? str.match(/class\s*=\s*["|'](.*?)["|']/)[1].split(' ') : nil
  name = str.match(/name\s*=\s*["|'](.*?)["|']/)? str.match(/name\s*=\s*["|'](.*?)["|']/)[1] : nil
  id = str.match(/id\s*=\s*["|'](.*?)["|']/)? str.match(/id\s*=\s*["|'](.*?)["|']/)[1] : nil
  Tag.new(tag, type, classes, name, id)
end
