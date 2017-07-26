# encoding:utf-8
# author:kanlijun
require 'rspec/autorun'
require 'ui_framework'
require_relative '../source/ios_pages/iOS_login'
require_relative '../source/mysql'

describe 'login' do
  before(:all) do
    path ='../app/*.ipa'
    @login = IOSLogin.new
    #数据库数据处理
    UiFramework::AppDriver.ios_launch('iOS','iphone6s',path,'9.3','1')
  end

  it name0 ='test app login' do
    result = @login.login(')

    UiFramework::Driver.checking(__FILE__,name0,[true],[result],['登录失败'])
  end

end


