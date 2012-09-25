# RgssCompatibleで変換可能なようにデータ構造クラスのコンストラクタを再定義する

class RPG::Map
  alias initialize_old initialize
  def initialize(width=5,height=5)
    initialize_old(width, height)
  end
end

class RPG::Event
  alias initialize_old initialize
  def initialize(x=0,y=0)
    initialize_old(x, y)
  end
end

# ※一部のメソッドはRGSS内専用です。

# Table変換メソッド(RGSS用)
def Conkool.init_array_3d(x,y,z)
  xd = Array.new(x)
  for i in 0...x
    yd = Array.new(y)
    for j in 0...y
      yd[j] = Array.new(z)
    end
    xd[i] = yd
  end
  
  return xd
end

def Conkool.table_to_array_3d(table)
  ary = init_array_3d(table.xsize, table.ysize, table.zsize)
  for x in 0...table.xsize
    for y in 0...table.ysize
      for z in 0...table.zsize
        begin
          ary[x][y][z] = table[x,y,z]
        rescue => e
          begin
            ary[x][y][0] = table[x,y]
          rescue
            ary[x][0][0] = table[x]
          end
        end
      end
    end
  end
  return ary
end

def Conkool.array_3d_to_table(ary)
  # 何次元配列化を調べる
  ary_dim = 1
  if ary[0].class == Array
    ary_dim += 1
    if ary[0][0].class == Array
      ary_dim += 1
    end
  end
  table = nil
  case ary_dim
  when 1
    table = Table.new(ary.size)
    for x in 0...table.xsize
      table[x] = ary[x]
    end
  when 2
    table = Table.new(ary.size, ary[0].size)
    for x in 0...table.xsize
      for y in 0...table.ysize
        table[x,y] = ary[x][y]
      end
    end
  when 3
    table = Table.new(ary.size, ary[0].size, ary[0][0].size)
    for x in 0...table.xsize
      for y in 0...table.ysize
        for z in 0...table.zsize
          table[x,y,z] = ary[x][y][z]
        end
      end
    end
  end
  
  return table
end

# Color変換メソッド(RGSS用)
def Conkool.color_to_array(color)
  [color.red, color.green, color.blue, color.alpha]
end
def Conkool.array_to_color(ary)
  Color.new(ary[0], ary[1], ary[2], ary[3])
end

# Tone変換メソッド(RGSS用)
def Conkool.tone_to_array(tone)
  [tone.red, tone.green, tone.blue, tone.gray]
end
def Conkool.array_to_tone(ary)
  Tone.new(ary[0], ary[1], ary[2], ary[3])
end

module Conkool
  class RgssCompatible
    def self.get_original_class
      name_list = klass.to_s.split("::")
      name_list.delete "RgssCompatible"
      return eval "RPG::" + name_list.last(name_list.size - 1).join("::")
    end
    
    def self.get_compatible_class(klass, tkool)
      name_list = klass.to_s.split("::")
      return eval "Conkool::RgssCompatible::" + tkool + "::" + name_list.last(name_list.size - 1).join("::")
    end
    
    def self.get_original_class(klass)
      name_list = klass.to_s.split("::")
      return eval "RPG::" + name_list.last(name_list.size - 3).join("::")
    end
    
    def data_convert_from_rgss(accessor, original, tkool)
      value = eval("original.#{accessor.to_s}")
      # 値のクラスによって分岐
      if value.class.to_s.split("::").include? "RPG"
        # RGSSデータ構造クラスならば
        # 変換用クラスを取得して、値を詰め替える。
        klass = self.class.get_compatible_class(value.class, tkool)
        compatible_value = klass.from_rgss(value, tkool)
        eval "self.#{accessor.to_s} = compatible_value"
      elsif value.class == Table
        # Table なら、3次元配列に変換する
        compatible_value = Conkool.table_to_array_3d(value)
        eval "self.#{accessor.to_s} = compatible_value"
      elsif value.class == Color
        # Color なら、配列に変換する
        compatible_value = Conkool.color_to_array(value)
        eval "self.#{accessor.to_s} = compatible_value"
      elsif value.class == Tone
        # Tone なら、配列に変換する
        compatible_value = Conkool.tone_to_array(value)
        eval "self.#{accessor.to_s} = compatible_value"
      elsif value.class == Array || value.class == Hash
        # ArrayかHashならクラスメソッドに渡す
        compatible_value = self.class.from_rgss(value, tkool)
        eval "self.#{accessor.to_s} = compatible_value"
      elsif value.class == String
        eval("self.#{accessor.to_s} = value")#.encode("UTF-8")
      else
        # それ以外ならそのまま入れる
        eval "self.#{accessor.to_s} = value"
      end
    end
    
    def self.from_rgss(original, tkool)
      # 型によって処理を分岐
      if original.class == Array
        compatible = []
        for i in 0...original.size
          # 格要素に対して再帰的に実行する
          compatible.push self.from_rgss(original[i], tkool)
        end
        return compatible
      elsif original.class == Hash
        compatible = {}
        original.each_key do |k|
          # 格要素に対して再帰的に実行する
          compatible[k] = self.from_rgss(original[k], tkool)
        end
        return compatible
      else
        if original != nil
          if original.class.to_s.split("::").include? "RPG"
            compatible = self.get_compatible_class(original.class, tkool).new
            compatible.class.accessors.each do |acs|
              compatible.data_convert_from_rgss(acs, original, tkool)
            end
            return compatible
          else
            return original
          end
        else
          return nil
        end
      end
    end
    
    def data_convert_to_rgss(accessor, original)
      value = eval("self.#{accessor.to_s}")
      original_value = eval("original.#{accessor.to_s}")
      if value.class.to_s.split("::").include? "RgssCompatible"
        # 変換用データ構造クラスならば
        # RGSSデータ構造クラスを取得して、値を詰め替える。
        klass = self.class.get_original_class(value.class)
        original_value = self.class.to_rgss(value)
        eval "original.#{accessor.to_s} = original_value"
      elsif original_value.class == Table
        # オリジナルがTableなら、3次元配列からTableに変換する
        original_value = Conkool.array_3d_to_table(value)
        eval "original.#{accessor.to_s} = original_value"
      elsif original_value.class == Color
        # オリジナルがColorなら、配列からColorに変換する
        original_value = Conkool.array_to_color(value)
        eval "original.#{accessor.to_s} = original_value"
      elsif original_value.class == Tone
        # オリジナルがToneなら、配列からToneに変換する
        original_value = Conkool.array_to_tone(value)
        eval "original.#{accessor.to_s} = original_value"
      elsif value.class == Array || value.class == Hash
        # ArrayかHashならクラスメソッドに渡す
        original_value = self.class.to_rgss(value)
        eval "original.#{accessor.to_s} = original_value"
      else
        # それ以外ならそのまま入れる
        eval "original.#{accessor.to_s} = value"
      end
      return original
    end
    
    def self.to_rgss(compatible)
      # 型によって処理を分岐
      if compatible.class == Array
        original = []
        for i in 0...compatible.size
          # 格要素に対して再帰的に実行する
          original.push self.to_rgss(compatible[i])
        end
        return original
      elsif compatible.class == Hash
        original = {}
        compatible.each_key do |k|
          # 格要素に対して再帰的に実行する
          original[k] = self.to_rgss(compatible[k])
        end
        return original
      else
        if compatible != nil
          if compatible.class.to_s.split("::").include? "RgssCompatible"
            original = self.get_original_class(compatible.class).new
            compatible.class.accessors.each do |acs|
              original = compatible.data_convert_to_rgss(acs, original)
            end
            return original
          else
            return compatible
          end
        else
          return nil
        end
      end
    end
  end
end