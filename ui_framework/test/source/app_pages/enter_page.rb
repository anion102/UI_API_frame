#encoding:utf-8
#author:kanlijun

#各个页面 入口封装
class EnterPage
  include UiFramework::AppDriver

  def initialize
    @element ={
    }
  end

  def enter_login
    result =wait_element_with_time(@element[:home_index_me],20)
    click_by_elmts(@element[:home_index_me]) if result
    wait_element_with_time(@element[:my_login_or_register],20)
    click_by_elmts(@element[:my_login_or_register])
  end

  def enter_information
    wait_element_with_time(@element[:home_index_me],20)
    click_by_elmts(@element[:my_list_my_infromation])
  end

  def enter_sfxx
    wait_element_with_time(@element[:icon_sf],20)
    click_by_elmts(@element[:icon_sf])
    click_by_elmts(@element[:info_sfxx])
  end

end
