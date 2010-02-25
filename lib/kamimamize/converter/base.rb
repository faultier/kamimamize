# coding: utf-8

module Kamimamize
  module Converter
    class Base
      def self.kamimamizable?(name, reading)
        self.respond_to?(:_k?) ? self.__send__(:_k?, name, reading) : false
      end

      def self.kamimamize(name, reading, opts)
        self.new(opts).kamimamize(name, reading)
      end

      def initialize(opts)
      end

      def Kamimamize(name, reading)
        raise ::NotImplementedError
      end
    end
  end
end
