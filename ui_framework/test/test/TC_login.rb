#encoding:utf-8
#author:kanlijun
require 'rspec/autorun'
require 'ui_framework'
require_relative '../source/app_pages/app_login'
require_relative '../source/app_pages/app_my_informations'
require_relative '../source/mysql'

describe 'login' do
  before(:all) do
    path ='../app/*.apk'
    @login = AppLogin.new
    @info = AppMyInformation.new
    #数据库数据处理
    UiFramework::AppDriver.android_launch('Android','huawei',path,'1')
  end

  it name0 ='test app login' do
    result = @login.app_login('123456789','1')

    UiFramework::Driver.checking(__FILE__,name0,[true],[result],['登录失败'])
  end

end


