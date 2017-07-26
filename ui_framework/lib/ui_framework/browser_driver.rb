#encoding:utf-8
#author:kanlijun
require_relative './web/browser_operation'
require_relative './web/tag_types'
module UiFramework

  module BrowserDriver
    include UiFramework::TagTypes

    # 打开url
    def self.open_url(url)
      UiFramework::BrowserOperation.new.open_url(url)
    end


    # 等待页面中的text文档信息
    def wait_until_to_text(wait_text)
      $driver.wait_until_to_text(wait_text)
    end

    # 等待元素操作
    def wait_element_elmts(key,args)
      $driver.wait_element_elmts(key,args)
    end

    # 切换为iframe
    # （这个可以直接通过标签进行操作：send(:iframe,{:id=>'iframe'})）
    def switch_frame(*args)
      $driver.switch_frame(*args)
    end

    #接口 切换为默认页面
    def switch_to_default_content
      $driver.switch_to_default_content
    end

    # alert弹框操作：exists?  ok  close  text
    def alert_operate(status)
      $driver.alert_operate(status)
    end

    # 动态方法：让标签和操作自由组合方法进行元素操作
    # 2017/03/31
    # kanlijun
    def method_missing(method,*args)
      tag,*action = method.id2name.split('_')
      if TAG.include?(tag.to_sym)
        $driver.operation(tag,action,args)
      else
        super
      end
    end

  end
end