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

      def convert(name, reading)
        doc = REXML::Document.new(open("#{CONV_URL}?appid=#{@appid}&sentence=#{URI.escape(reading)}&format=roman&response=half_alphanumeric&dictionary=normal"))
        romans   = doc.get_elements('//HalfAlphanumeric').map{|e|
          _r = e.text
          _r.gsub!('nn','n')
          _r.gsub!('ch','t')
          _r.gsub!('sh','s')
          _r
        }
        r        = romans.join('').dup
        yomigana = ""
        kanji    = ""
        i        = 0
        while yomigana == kanji && i < 5 do
          r = romans.map {|roman|
            cond = rand()
            _r = roman.dup
            case
            when cond > 0.6
              _c = _r.split('').sort_by{rand}.detect{|c|c =~ /[^aiueon]/}
              _s = %w(k g s z t n h p b m y r w).select{|x|x != _c}.sort_by{rand}.first
              _r.gsub!(/#{_c}/,_s)
            when cond > 0.3
              _c = _r.split('').sort_by{rand}.detect{|c|c =~ /[aiueo]/}
              _s = %w(a i u e o).select{|x|x != _c}.sort_by{rand}.first
              _r.gsub!(/#{_c}/,_s)
            end
            _r
          }.join('')
          next if romans.join('') == r
          res = REXML::Document.new(open("#{CONV_URL}?appid=#{@appid}&sentence=#{r}&format=roman&mode=roman")).elements['//SegmentText']
          yomigana = res.text if !!res && !!res.text
          if yomigana == reading
            yomigana = ""
            next
          end
          kanji = ""
          body = open("#{CONV_URL}?appid=#{@appid}&sentence=#{URI.escape(yomigana)}&dictionary=default,name")
          res = REXML::Document.new(body).each_element('//Segment') {|elem|
            c = elem.get_elements('CandidateList/Candidate')
            kanji << c[0, 10].sort_by{rand}.first.text
          }
          i += 1
        end
        !!kanji ? "#{kanji}(#{yomigana})さん" : "#{yomigana}さん"
      end
    end
  end
end
