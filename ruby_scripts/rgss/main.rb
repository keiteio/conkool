cl = Win32API.new('kernel32', 'GetCommandLine', nil, 'p').call.split(" ")
cl = cl[1, cl.length - 1]
cl.delete("console")
cl.delete("test")
ARGV.concat(cl)


puts "[Conkool] Loading scripts."
# 必要なファイルをロード
[ "./ruby_scripts/common/option_parser.rb",
  "./ruby_scripts/common/rgss_compatibles.rb",
  "./ruby_scripts/rgss/rgss_compatibles_converter.rb",
  "./ruby_scripts/common/conkool.rb"
].each{ |path| Conkool.load(path) }
puts "[Conkool] Complete."

puts "[Conkool] Parsing arguments."
op = Conkool::OptionParser.new
["i", "o"].each{ |char| op.add_opt({ :short => char }) }
op.parse(ARGV)

if op.parsed_opts["-o"]
  puts "[Conkool] Data conversion to the compatible from the original. "
  puts "[Conkool] ( FROM ) => ( TO )"
  if op.arguments[0]
    Conkool.output op.arguments[0]
  else
    Conkool.output
  end
  puts "[Conkool] Done."
  exit
elsif op.parsed_opts["-i"]
  puts "[Conkool] Data conversion to the original from the compatible. "
  puts "[Conkool] ( FROM ) => ( TO )"
  if op.arguments[0]
    Conkool.input op.arguments[0]
  else
    Conkool.input
  end
  puts "[Conkool] Done."
  exit
else
  puts "[Conkool] Nothing to do in this time."
end
