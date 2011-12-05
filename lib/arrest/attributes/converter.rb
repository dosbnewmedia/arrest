class Boolean
  # to have a boolean type for attributes
end

module Arrest

  class Attribute
    attr_accessor :name, :read_only, :clazz
    def initialize name, read_only, clazz
      @name = name
      @read_only = read_only
      @clazz = clazz
    end

    def convert value
      return if value == nil
      converter = CONVERTER[@clazz]
      if converter == nil
        puts "No converter for: #{@clazz.name}"
        converter = IdentConv
      end
      converter.convert value
    end
  end

  class NestedAttribute < Attribute
    def initialize name, read_only, clazz
      super name, read_only, clazz
    end

    def convert value
      return unless value
      @clazz.new value
    end
  end

  class NestedCollection < Attribute
    def initialize name, read_only, clazz
      super name, read_only, clazz
    end

    def convert value
      return unless value
      raise "Expected an array but got #{value.class.name}" unless value.is_a?(Array)
      value.map do |v|
        @clazz.new v
      end
    end

  end

  CONVERTER = {}

  def add_converter key, converter
    CONVERTER[key] = converter
  end

  class Converter
    class << self
      attr_reader :clazz

      def convert value
        if value.is_a?(self.clazz)
          value
        else
          self.parse value
        end
      end

      def target clazz
        @clazz = clazz
        CONVERTER[clazz] = self
      end
    end
  end
  
  class IdentConv < Converter
    def self.convert value
      value
    end
  end

  class StringConv < IdentConv
    target String
  end

  class BooleanConv < IdentConv
    target Boolean
  end

  class IntegerConv < IdentConv
    target Integer
  end

  class TimeConv < Converter
    target Time

    def self.parse value
      Time.parse(value)
    end
  end
end