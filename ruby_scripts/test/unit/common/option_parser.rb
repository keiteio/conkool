require 'test/unit'
require './common/option_parser.rb'

class UT_OptionParser < Test::Unit::TestCase
  include Conkool
  
  def setup
  end

  # OptionParser::Otionのテスト
  def test_Option_001
    short = "t"
    long = "test"
    value_count = 2
    
    opt = OptionParser::Option.new(
      :short => short,
      :long => long,
      :value_count => value_count
    )
    
    opt2 = OptionParser::Option.new({
      :short => short,
      :long => long,
      :value_count => value_count,
      :duplicate => true
    })
    
    assert_equal opt.short, "-"+short
    assert_equal opt.long, "--"+long
    assert opt.has_value
    assert opt.is_this?(short)
    assert opt.is_this?(long)
    assert opt != opt2
    assert opt == "-"+short
    assert opt == "--"+long
  end
  
end