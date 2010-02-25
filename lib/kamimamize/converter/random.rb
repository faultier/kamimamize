# coding: utf-8

require 'kamimamize/converter/base'

module Kamimamize
  module Converter
    class Random < Base
      COMMENTS = [
        'はぁ、なんだか読みにくいお名前ですねぇ…。面倒くさいので人畜さんとお呼びしても良いですよね？',
        '話かけないで下さい、あなたのことが嫌いです。迅速にどっか行っちゃって下さいー！'
      ]

      def self._k?(*args)
        true
      end

      def kamimamize(name, reading)
        COMMENTS[rand(COMMENTS.size)]
      end
    end
  end
end
