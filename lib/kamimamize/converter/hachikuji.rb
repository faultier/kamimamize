# coding: utf-8

require 'kamimamize/converter/base'

module Kamimamize
  module Converter
    class Hachikuji < Base
      FORMATS = [
        '%sさんですかー！！良いお名前ですね！名前からしてもう、可愛いらしさが伝わって来そうな感じですぅー！',
        '%sさんだなんて、もう形成の美女って感じのお名前ですね。あれ、傾城でしたっけ？',
        '%sさんですか。あまりにキュート過ぎて全世界100億人のロリカッケェー皆さんが犯罪すれすれな感じのお名前ですね！罪な女ですね。'
      ]

      def self._k?(name, reading)
        name =~ /\A(?:八九寺|はちくじ|真宵|まよい)\z/
      end

      def kamimamize(name, reading)
        FORMATS[rand(FORMATS.size)] % name
      end
    end
  end
end
