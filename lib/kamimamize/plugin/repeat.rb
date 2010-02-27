# coding: utf-8

require 'kamimamize/plugin/base'

module Kamimamize
  module Plugin
    class Repeat < Base
      def convert(name, reading)
        count = rand(4) until count && count != 1

        res = if name =~ /々/
                name.sub(/々/,'々'*count)
              elsif (1..name.length-2).any? {|i|name[i] == name[i-1]}
                c = name[(1..name.length-2).detect{|i|name[i]==name[i-1]}]
                name.sub(/#{c}/, c*count)
              end
        !!res ? "#{res}さん" : @next.kamimamize(name, reading)
      end
    end
  end
end
