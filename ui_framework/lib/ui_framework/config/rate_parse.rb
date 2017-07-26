=begin
  encoding:utf-8
  author:kanlijun
  date:2016/11/23
=end
require 'yaml'
module RateParse
  class << self
    def add_attribute(klass, symbol)
        codes = %Q{
        def #{symbol}
        return @#{symbol}
        end

        def #{symbol}=(value)
        @#{symbol} = value
        end
        }
        klass.instance_eval(codes)
    end

    def expand_configs(configs = {})
      configs.each do |key, value|
        expand_sub_configs(key, value)
      end
    end

    def expand_sub_configs(prefix, configs)
      if configs.class != Hash
        add_attribute(Configs, prefix)
        eval("Configs.#{prefix} = configs")
      else
        configs.each do |key, value|
          expand_sub_configs(prefix + '_' + key, value)
        end
      end
    end
  end
end

Configs = Class.new
# RateParse.expand_configs(YAML.load(File.open('./screen_rate.yml')))
#
# p Configs.I320_568_width

