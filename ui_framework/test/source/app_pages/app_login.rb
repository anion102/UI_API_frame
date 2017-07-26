# encoding:utf-8
# author:kanlijun
require_relative 'enter_page'

class AppLogin < EnterPage
  include UiFramework::AppDriver
  def initialize
    @login ={
        user_phone: {:id => ''}, #登录页面的账号输入框
        user_password: {:id => ''}, #登录页面的密码输入文本框
        login_button: {:id => ''}, #登录页面的"登录"按钮
    }
    super
  end

  def app_login(user, pwd)
    enter_login
    wait_element_with_time(@login[:user_phone],20)
    clear_cookie_by_elmts(@login[:user_phone])
    input_text_by_elmts(@login[:user_phone],user)
    input_text_by_elmts(@login[:user_password],pwd)
    click_by_elmts(@login[:login_button])
    wait_element_with_time(@element[:home_index_me],20)
  end

end
