# coding: utf-8

module Kamimamize
  class Coverter
    def initialize(conf)
      @plugins = []
      keys = conf.keys.sort_by{|k| conf[k][:priority] || 1}
      keys.delete  :default
      keys.unshift :default
      conf[:default] ||= { :class => 'Kamimamize::Plugin::Random' }
      conf[:default][:through] = 0.0
      keys.each do |k|
        c     = conf[k]
        klass = eval( c.delete(:class) || "::Kamimamize::Plugin::#{k.to_s.split('_').map{|x|x.capitalize}.join('')}" )
        @plugins.unshift klass.new(c)
      end
    end

    def kamimamize(name, reading)
      @plugins.inject(nil) {|res, plugin|
        res = plugin.kamimamize(name, reading) unless res
        res
      }
    end
  end
end
