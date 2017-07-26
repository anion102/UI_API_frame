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

  it name0 ='正常请求' do
    begin
      url ='http://baidu.com'
      #期望值:可以是报文正则表达式（参数格式严格如下：使用ruby对象，以及双引号），可以是某一个参数值
    rescue Exception=>ex
    ensure
      expect = {"data"=>[]}
      InterfaceFrame::FrameDriver.executing(url,'111',name0,expect,ex,1,'11','get')
    end
  end

  
end
