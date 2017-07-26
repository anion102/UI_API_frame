# encoding:utf-8
# author:kanlijun
require_relative 'ios_enter_pages'

class IOSLogin < IosEnterPages
  include UiFramework::AppDriver
  def initialize
    @login ={
    }
    super
  end

  def login(user, pwd)
    enter_login
    wait_element_with_time(@login[:user_phone],30)
    clear_cookie_by_elmts(@login[:user_phone])
    input_text_by_elmts(@login[:user_phone],user)
    input_text_by_elmts(@login[:user_password],pwd)
    click_by_elmts(@login[:login_button])
    click_by_elmts(@login[:zw_alert]) if wait_element_with_time(@login[:zw_alert],10)
    wait_element_with_time(@element[:home_index_me],30)
  end


end
