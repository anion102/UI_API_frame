#encoding:utf-8
#author:kanlijun

require 'rspec/autorun'
require 'ui_framework'
require_relative '../source/pages/login_page'
require_relative '../source/pages/borrow_list_page'
require_relative '../source/yaml_config/yaml_init'

describe 'login' do
  before(:all) do
    @xs = $params['configure']['xspt']
    UiFramework::BrowserDriver.open_url(@xs['url'])
    puts 'open url successfully！'
    @login = LoginPage.new
    @list =BorrowListPage.new
  end

  it name = 'test name query ("花花")' do
    begin
      @login.login(@xs['username'],@xs['pwd'])
      result = @list.search_borrow('花花')
      p result
    rescue Exception=>ex
      puts ex.backtrace
    ensure
      assert_desc=['登录失败']
      expect=['花花']*2
      UiFramework::Driver.checking(__FILE__,name,expect,result,assert_desc,ex)
    end

  end

end

