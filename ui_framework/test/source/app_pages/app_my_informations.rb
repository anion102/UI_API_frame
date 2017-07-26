# encoding:utf-8
# author:kanlijun
require_relative 'enter_page'

class AppMyInformation < EnterPage
  include UiFramework::AppDriver
  def initialize
    @info ={
    }
    super
  end

  #身份认证页面填写
  def info_sfxx(name, card, address)
    enter_information
    enter_sfxx
    width,height = get_window_size
    wait_element_by_elmts(@info[:title_sfxx])
    location_select(width*0.89, height*0.79) #选择完成
    click_by_elmts(@info[:sfxx_marriage])
    location_select(width*0.89, height*0.79) #选择完成
    click_by_elmts(@info[:sfxx_submit])
    wait_element_by_elmts(@element[:icon_gz])
  end


end
