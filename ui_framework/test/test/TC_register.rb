#encoding:utf-8
#author:kanlijun
require 'rspec/autorun'
require_relative '../../lib/ui_framework'
require_relative '../source/pages/login_page'
require_relative '../source/yaml_config/yaml_init'

# UiFramework::Driver.yaml_config
describe 'test' do
  it '1' do
    sleep 1
    desc='注册1'
    assert_desc=['密码错误']
    act=['1']
    ex =['1']
    exception =nil
    login =LoginPage.new
    data = login.test($params['configure']['screenshots']['switch'])
    p $params
    p data
    UiFramework::Driver.checking(__FILE__,desc,ex,act,assert_desc,exception)
  end

  it '2' do
    sleep 1
    desc='注册2_用户名不对'
    assert_desc=['注册失败','用户名不匹配']
    act=['12','anion']
    ex =['123','anion']
    exception =nil
    UiFramework::Driver.checking(__FILE__,desc,ex,act,assert_desc,exception)
  end
end


