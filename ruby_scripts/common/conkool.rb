module Conkool
  TKOOL_XP="Xp"
  TKOOL_VX="Vx"
  TKOOL_VXACE="Vxace"
  DATA_FILE_EXTS={ TKOOL_XP => ".rxdata", TKOOL_VX => ".rvdata", TKOOL_VXACE => ".rvdata2" }
  VXACE_DATA_DIR="Data"
  COMPATIBLE_DATA_DIR="CompatibleData"
  ASCII_DATA_DIR="AsciiData"

  # Method for RGSS - output to compatible binaries.
  def self.output(pattern = "*" + Util.get_binbary_ext(Util.tkool))
    ext = Util.get_binbary_ext(Util.tkool)
    Util.mkdir COMPATIBLE_DATA_DIR
    Dir.glob( File.join(VXACE_DATA_DIR, pattern)) do |path|
      basename = File.basename(path, ext)
      comp_path = File.join(COMPATIBLE_DATA_DIR, basename + ext)
      puts "[Conkool] " + path + " => " + comp_path
      data = load_data(path)
      comp_data = RgssCompatible.from_rgss(data, Util.tkool)
      
      save_data(comp_data, comp_path)
    end
  end
  
  # Method for RGSS - input from compatible binaries.
  def self.input(pattern = "*" + Util.get_binbary_ext(Util.tkool))
    ext = Util.get_binbary_ext(Util.tkool)
    Util.mkdir COMPATIBLE_DATA_DIR
    Dir.glob( File.join(COMPATIBLE_DATA_DIR, pattern)) do |path|
      basename = File.basename(path, ext)
      org_path = File.join(VXACE_DATA_DIR, basename + ext)
      puts "[Conkool] " + path + " => " + org_path
      data = load_data(path)
      org_data = RgssCompatible.to_rgss(data)
      save_data(org_data, org_path)
    end
  end
  
  # Method for Ruby - Ascii-to-binary converter 
  def self.to_binary(pattern = "*.yml")
    ext = Util.get_binbary_ext(Util.tkool)
    Util.mkdir ASCII_DATA_DIR
    Dir.glob( File.join(ASCII_DATA_DIR, pattern) ) do |path|
      basename = File.basename(path,".yml")
      bin_path = File.join(COMPATIBLE_DATA_DIR , basename + ext)
      puts "[Conkool] " + path + " => " + bin_path
      loaded_data = YAML.load_file(path)
      if basename == "Scripts"
        # スクリプトの場合はdefrateする
        for i in 0...loaded_data.size
          script = Zlib::Deflate.deflate(loaded_data[i][2])
          loaded_data[i][2] = script
        end
      end
      open(bin_path, "wb") do |f|
        Marshal.dump(loaded_data, f)
      end
    end
  end
  
  # Method for Ruby - Binary-to-Ascii converter 
  def self.to_ascii(pattern = "*" + Util.get_binbary_ext(Util.tkool))
    Util.mkdir ASCII_DATA_DIR
    # Currently only supports YAML. 
    self.to_yaml(pattern)
  end
  # Ruby用 - 互換バイナリ→YAML変換メソッド
  def self.to_yaml(pattern = "*" + Util.get_binbary_ext(Util.tkool))
    ext = Util.get_binbary_ext(Util.tkool)
    Dir.glob( File.join(COMPATIBLE_DATA_DIR, pattern) ) do |path|
      basename = File.basename(path, ext)
      yml_path = File.join(ASCII_DATA_DIR , basename + ".yml")
      puts "[Conkool] " + path + " => " + yml_path
      yml_data = ""
      open(path, "rb") do |f|
        loaded_data = Marshal.load(f)
        if basename == "Scripts"
          # スクリプトの場合はinfrateする
          for i in 0...loaded_data.size
            script = Zlib::Inflate.inflate(loaded_data[i][2])
            loaded_data[i][2] = script.force_encoding("UTF-8")
          end
        end
        yml_data = YAML.dump(loaded_data)
      end
      open(yml_path, "wb") do |f|
        f.write yml_data
      end
    end
  end
  
  module Util
  
    def self.mkdir(path)
      if File.exist? path
        unless File.directory? path
          raise "At the specified path, a file already exists.\n#{path}"
        end
      else
        Dir.mkdir path
      end
    end
    
    def self.tkool
      # Currently only supports VXACE. 
      return TKOOL_VXACE
    end
    
    def self.get_binbary_ext(tkool)
      return DATA_FILE_EXTS[tkool]
    end
  
  end
  
end
