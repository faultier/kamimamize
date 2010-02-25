# coding: utf-8

module Kamimamize
  CONVERTERS = []

  def self.detect_converter(name)
    case name
    when /\//
      require name
      eval(name.split('/').map{|c|c.capitalize}.join('::'))
    when Class
      name
    else
      eval("Converter::#{name.split('/').map{|c|c.capitalize}.join('::')}")
    end
  end

  def self.set_converters(list)
    list.each do |conv|
      conv_klass = self.detect_converter(conv)
      CONVERTERS.push conv_klass unless CONVERTERS.include?(conv_klass)
    end
  end

  def self.kamimamize(name, reading, opts={}, conv=nil)
    self.set_converters(%w(hachikuji repeat swap random)) if CONVERTERS.empty?
    converter = !!conv ? self.detect_converter(conv) : CONVERTERS.detect{|c|c.kamimamizable?(name, reading)}
    converter.kamimamize(name, reading, opts)
  end
end

require 'kamimamize/converter'
