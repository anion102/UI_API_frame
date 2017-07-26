# encoding:utf-8
# author:kanlijun
require 'yaml'
require 'rspec/autorun'

require_relative '../config/mysql'
require_relative '../../lib/interface_frame'

describe 'TEST' do
  before(:all) do
    config = YAML.load(File.open('../config/param_config.yml'))
    @url=config['Host']+config['test']

    #可能公用的数据准备
    @request = {
        :data1=>'kw',
        :data2=>'password', }
  end

  it name0 ='test2正常请求' do
    begin
      #期望值:可以是报文正则表达式（参数格式严格如下：使用ruby对象，以及双引号），可以是某一个参数值
    rescue Exception=>ex
    ensure
      expect = /{.*"data"=>{"key"=>".*?", "key2"=>"\d{1,}"}.*}/
      result =InterfaceFrame::FrameDriver.executing(@url,@request,name0,expect,ex,0)

      if result
        a='q'
        actual=['0',a]
        expect_sql=['1','q']
        InterfaceFrame::FrameDriver.extra(actual,expect_sql)
      end
    end
  end

 
end
