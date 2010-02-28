# coding: utf-8

module Kamimamize
  module Plugin
    class Base
      attr_accessor :through

      def initialize(conf)
        @through = conf[:through].to_f || 0.0
      end

      def kamimamize(name, reading)
        rand <= 1.0 - @through ? convert(name, reading) : nil
      end

      def convert(name, reading)
        raise ::NotImplementedError
      end
    end
  end
end
