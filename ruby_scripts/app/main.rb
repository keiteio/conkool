require "psych"
require "yaml"
require "zlib"
require "./ruby_scripts/common/option_parser.rb"
require "./ruby_scripts/common/rgss_compatibles.rb"
require "./ruby_scripts/common/conkool.rb"

puts "[Conkool] Start Conkool."

puts "[Conkool] Parsing arguments."
op = Conkool::OptionParser.new
["a", "b", "i", "o"].each{ |char| op.add_opt({ :short => char }) }
op.parse(ARGV)

if op.parsed_opts["-a"] != nil || op.parsed_opts["-o"] != nil
  if op.parsed_opts["-o"]
    exec("./Game.exe console -o " + op.arguments[0].to_s)
  end
  if op.parsed_opts["-a"]
    puts "[Conkool] Data conversion to the binary from the ascii."
    if op.arguments[0]
      Conkool.to_ascii op.arguments[0]
    else
      Conkool.to_ascii 
    end
    puts "[Conkool] Done."
  end
elsif op.parsed_opts["-b"] != nil || op.parsed_opts["-i"] != nil
  if op.parsed_opts["-b"]
    puts "[Conkool] Data conversion to the ascii from the binary."
    if op.arguments[0]
      Conkool.to_binary op.arguments[0]
    else
      Conkool.to_binary
    end
    puts "[Conkool] Done."
  end
  if op.parsed_opts["-i"]
    exec("./Game.exe console -i " + op.arguments[0].to_s)
  end
end
puts "[Conkool] End Conkool."
