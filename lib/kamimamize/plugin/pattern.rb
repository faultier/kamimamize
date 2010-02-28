# coding: utf-8

require 'yaml'
require 'kamimamize/plugin/base'

module Kamimamize
  module Plugin
    class Pattern < Base
      @@default_patterns = {
        '八九寺' => [
          '%sさんですかー！！良いお名前ですね！名前からしてもう、可愛いらしさが伝わって来そうな感じですぅー！',
          '%sさんだなんて、もう形成の美女って感じのお名前ですね。あれ、傾城でしたっけ？',
          '%sさんですか。あまりにキュート過ぎて全世界100億人のロリカッケェー皆さんが犯罪すれすれな感じのお名前ですね。罪な女、ってやつです。'
        ]
      }

      def initialize(conf)
        super
        @patterns = @@default_patterns.merge(conf[:patterns] || {})
        if conf[:pattern_file]
          yaml = YAML.load_file(conf[:pattern_file])
          @patterns = @patterns.merge(yaml)
        end
      end

      def convert(name, reading)
        fs = @patterns[name]
        return nil if fs.nil? || fs.empty?
        fs[rand(fs.size)] % name
      end
    end
  end
end
