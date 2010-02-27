# coding: utf-8

require 'kamimamize/plugin/base'

module Kamimamize
  module Plugin
    class Random < Base
      @@default_patterns = [
          'はぁ、なんだか読みにくいお名前ですねぇ…。面倒くさいので人畜さんとお呼びしても良いですよね？',
          '話かけないで下さい、あなたのことが嫌いです。迅速にどっか行っちゃって下さいー！'
      ]

      def initialize(conf)
        super
        @patterns = conf[:patterns] || @@default_patterns
      end

      def convert(name, reading)
        @patterns[rand(@patterns.size)]
      end
    end
  end
end
