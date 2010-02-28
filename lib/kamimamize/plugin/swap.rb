# coding: utf-8

require 'kamimamize/plugin/base'
require 'open-uri'
require 'rexml/document'

module Kamimamize
  module Plugin
    class Swap < Base
      CONV_URL = 'http://jlp.yahooapis.jp/JIMService/V1/conversion'

      def initialize(conf)
        super
        @appid = conf[:appid]
      end

      def kana_to_romans(kana)
        url = "#{CONV_URL}?appid=#{@appid}&sentence=#{URI.escape(kana)}&format=roman&response=half_alphanumeric&dictionary=normal"
        doc = nil
        open(url) {|res| doc = REXML::Document.new(res)}
        doc.get_elements('//HalfAlphanumeric').map {|elem|
          _r = elem.text
          _r.gsub!('nn','n')
          _r.gsub!('ch','t')
          _r.gsub!('sh','s')
          _r
        }
      end

      def roman_to_kana(roman)
        url = "#{CONV_URL}?appid=#{@appid}&sentence=#{roman}&format=roman&mode=roman"
        doc = nil
        open(url) {|res| doc = REXML::Document.new(res)}
        doc.elements['//SegmentText'].text
      end

      def kana_to_kanji(kana)
        res = ""
        url = "#{CONV_URL}?appid=#{@appid}&sentence=#{URI.escape(kana)}&dictionary=default,name"
        doc = nil
        open(url) {|res| doc = REXML::Document.new(res)}
        doc.each_element('//Segment') {|elem|
          c = elem.get_elements('CandidateList/Candidate')
          res << c[0,3].sort_by{rand}.first.text
        }
        res
      end

      def convert(name, reading)
        roman = kana_to_romans(reading).map {|r|
          cond = rand()
          _r   = r.dup
          if cond > 0.6
            _c = _r.split('').sort_by{rand}.detect{|c|c =~ /[^aiueon]/}
            _s = %w(k g s z t n h p b m r ry).select{|x|x != _c}.sort_by{rand}.first
            _r.gsub!(/#{_c}/,_s)
          elsif cond > 0.3
            _c = _r.split('').sort_by{rand}.detect{|c|c =~ /[aiueo]/}
            _s = %w(a i u e o).select{|x|x != _c}.sort_by{rand}.first
            _r.gsub!(/#{_c}/,_s)
          end
          _r
        }.join('')
        kana  = roman_to_kana(roman)
        kanji = kana_to_kanji(kana)
        !!kanji ? "#{kanji}さん (#{kana}さん)" : nil
      end
    end
  end
end
