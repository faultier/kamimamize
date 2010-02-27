# coding: utf-8

module Kamimamize
  class Coverter
    def initialize(conf)
      @plugin = nil
      keys = conf.keys.sort_by{|k| conf[k][:priority] || 1}
      keys.delete  :default
      keys.unshift :default
      conf[:default] ||= { :class => 'Kamimamize::Plugin::Random' }
      conf[:default][:through] = 0.0
      keys.each do |k|
        c = conf[k]
        klass = eval(c.delete(:class) || "::Kamimamize::Plugin::#{k.to_s.split('_').map{|x|x.capitalize}.join('')}")
        obj = klass.new(c)
        obj.next = @plugin
        @plugin = obj
      end
    end

    def kamimamize(name, reading)
      @plugin.kamimamize(name, reading)
    end
  end
end
