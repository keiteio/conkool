# 必要なファイルをロード
[ "./ruby_scripts/common/option_parser.rb",
  "./ruby_scripts/common/rgss_compatibles.rb",
  "./ruby_scripts/rgss/rgss_compatibles_converter.rb",
  "./ruby_scripts/common/conkool.rb"
].each{ |path| Conkool.load(path) }

op = OptionParser.new
op.parse(ARGV)

# データ出力処理
if    op.arguments[0] == "out"
  output op.arguments[1]
  exit
# データ入力処理
elsif op.arguments[0] == "in"
  input op.arguments[1]
  exit
end

=end