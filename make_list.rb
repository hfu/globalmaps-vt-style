require 'json'
list = {:list => []}
Dir.glob('../*vt') {|path|
  next unless /^gm(.*?)(\d\d)vt$/.match File.basename(path)
  metadata =
    JSON::parse(File.read("../gm#{$1}#{$2}vt/metadata.json"))
  center = metadata['center']

  list[:list] << {
    :id => "gm#{$1}#{$2}vt",
    :country => $1,
    :version => $2.to_f / 10,
    :ngia => 'TBD',
    :center => center
  }
}
print JSON.pretty_generate(list, {:indent => '  '})
