# �K�v�ȃt�@�C�������[�h
[ "./ruby_scripts/common/option_parser.rb",
  "./ruby_scripts/common/rgss_compatibles.rb",
  "./ruby_scripts/rgss/rgss_compatibles_converter.rb",
  "./ruby_scripts/common/conkool.rb"
].each{ |path| Conkool.load(path) }

op = OptionParser.new
op.parse(ARGV)

# �f�[�^�o�͏���
if    op.arguments[0] == "out"
  output op.arguments[1]
  exit
# �f�[�^���͏���
elsif op.arguments[0] == "in"
  input op.arguments[1]
  exit
end

=end