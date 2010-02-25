# coding: utf-8

require 'kamimamize/converter/base'

module Kamimamize
  module Converter
    class Repeat < Base
      def self._k?(name, reading)
        rand() > 0.4 ? (name =~ /々/ || (1..name.length-2).any? {|i|name[i] == name[i-1]}) : false
      end

      def kamimamize(name, reading)
        count = rand(4) until count && count != 1

        res = if name =~ /々/
                name.sub(/々/,'々'*count)
              else
                c = name[(1..name.length-2).detect{|i|name[i]==name[i-1]}]
                name.sub(/#{c}/, c*count)
              end
        "#{res}さん"
      end
    end
  end
end
