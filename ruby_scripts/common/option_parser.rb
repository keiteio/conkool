module Conkool
  class OptionParser
    
    # 例外クラス
    class ParseOptException < Exception; end
    class InitializeOptException < Exception; end
    
    # 個々のオプションを表すクラス
    class Option
      
      attr_accessor :short
      attr_accessor :long
      attr_accessor :value_count
      attr_accessor :duplicate
      
      def initialize(option = {})
        unless option[:short] || option[:long]
          err_str = ""
          err_str += "Failed to initialize a option.\n"
          err_str += "  short option = " + (option[:short] ? option[:short] : "nil") + "\n"
          err_str += "   long option = " + (option[:long] ? option[:long] : "nil") + "\n"
          err_str += "\n"
          raise Exception.new(err_str)
        end
        @short = option[:short] ? option[:short].sub(/-*?([^\-])/,'\1') : nil
        @long = option[:long] ? option[:long].sub(/-*?([^\-])/,'\1') : nil
        @value_count = option[:value_count] ? option[:value_count] : 0
        @duplicate = option[:duplicate] ? option[:duplicate] : false
      end
      
      def short
        return @short ? ("-" + @short) : nil
      end
      
      def long
        return @long ? ("--" + @long) : nil
      end
      
      def is_this?(opt_string)
        opt_string == @short || opt_string == @long
      end
      
      def has_value
        return value_count != 0
      end
      
      def ==(other)
        if other.class == String
          return self.short == other || self.long == other
        else
          return @short == other.short &&
                 @long == other.long &&
                 @value_count == other.value_count &&
                 @duplicate == other.duplicate
        end
      end
      
    end
    
    class OptionCollection < Hash
      
      def [](key)
        if key.class == String
          return self.find{ |item| item[0] == key }
        else
          return super(key)
        end
      end
      
    end
    
    
    attr_accessor :options
    attr_reader   :parsed_opts
    attr_reader   :arguments
    
    def initialize()
      @options = []
      @arguments = nil
      @parsed_opts = nil
    end
    
    def parse(argv)
      @arguments = []
      @parsed_opts = OptionCollection.new
      # Define the temporary method that will be undefined at the end of this method.
      def @parsed_opts.add_opts(opt, values)
        self[opt] ||= []
        self[opt].push values
      end
      
      i = 0
      while i < argv.size
        opt_str = argv[i]
        # ショートオプションの分解
        if is_short_opt?(opt_str) && opt_str.size > 2
          splitted = opt_str[1, opt_str.size - 1].split(//).map{|i| "-" + i }
          argv[i,1] = splitted
          opt_str = argv[i]
        end
        
        if is_opt?(opt_str)
          opt = is_defined?(opt_str)
          if opt
            if opt.has_value
              values = []
              if opt.value_count > 0
                opt.value_count.times do |n|
                  i += 1
                  if i >= argv.size || is_opt?(argv[i])
                    raise ParseOptException.new("Argument error.\n   #{opt_str} : #{opt.value_count} of #{n}")
                  end
                  values.push argv[i]
                end
              else
                values = argv[i+1,argv.size-(i+1)]
                i = argv.size
              end
              
              @parsed_opts.add_opts(opt, values)
            else
              # Don't take arguments.
              @parsed_opts.add_opts(opt, values)
            end
          else
            # An undefined option
            raise ParseOptException.new("Undefined option. '#{argv[i]}'")
          end
        else
          # Not a option
          @arguments.push argv[i]
        end
        i += 1
      end
      
      @parsed_opts.instance_eval{ undef add_opts }
    end
    
    def add_opt(param)
      if param.class.ancestors.include? Option
        @options.push option
      elsif param.class.ancestors.include? Hash
        @options.push Option.new(param)
      else
        raise "Unsupported type for arguments : #{option}"
      end
    end
    
    def find(arg)
      @options.each do |opt|
        return opt if ("-" + arg == opt.short_opt) || ("--" + arg == opt.long_opt)
      end
    end
    
    def is_short_opt?(arg)
      (arg =~ /^-[a-zA-Z]/) != nil
    end
    
    def is_long_opt?(arg)
      (arg =~ /^--[a-zA-Z][\S]/) != nil
    end
    
    def is_opt?(arg)
      is_short_opt?(arg) || is_long_opt?(arg)
    end
    
    def is_defined?(arg)
      return nil unless is_opt?(arg)
      @options.each do |opt|
        if opt.class.ancestors.include? Option
          return opt if opt == arg
        else
          if is_short_opt?(arg)
            return opt if opt.short == arg.to_s
          elsif is_long_opt?(arg)
            return opt if opt.long == arg.to_s
          end
        end
      end
      return nil
    end
  end
end