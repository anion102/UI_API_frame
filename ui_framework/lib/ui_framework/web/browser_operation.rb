#encoding: utf-8
#author: kanlijun

require 'watir-webdriver'
require 'selenium-webdriver'
require_relative '../log/AppLogging'
require 'watir-scroll'

module UiFramework

  class BrowserOperation
    attr_reader :url, :frame, :element
    attr_accessor :width, :height

    # 初始化
    def initialize
      @browser
      @frame = false
      $driver = self
      $driver
    end

    # 打开url地址；
    # 并指定对应宽高为传入的值；
    # 如果有nil则窗口最大化
    def open_url(url,width=nil,height=nil)
      @url =url
      @width = width
      @height = height

      @browser = Watir::Browser.new :firefox
      @browser.goto "#{url}"
      if width == nil||height == nil
        @browser.window.maximize
      else
        @browser.window.resize_to(width, height)
      end

      @browser
    end


    # 等待页面出现text文本值时返回结果，
    # 出现异常返回false
    def wait_until_to_text(wait_text)
      wait = Selenium::WebDriver::Wait.new(:timeout => 30)
      res = wait.until { @browser.text.include?"#{wait_text}" }
      return res
    rescue Exception=>e
      puts e.message
      puts e.backtrace
      return false
    end


    # 通过标签元素定位当前页面是否出现过，超时时间30s
    # 如果是frame定位frame上的
    def wait_element_elmts(key,args)
      wait = Selenium::WebDriver::Wait.new(:timeout => 30)
      res=wait.until {
        ele =select_tag_list(key,args)
        ele.exists?
      }
      return res
    rescue Exception=>e
      puts e.message
      puts e.backtrace
      return false
    end

    ###切换至iframe中
    def switch_to_iframe
      @frame = @browser.switch_to.iframe(@element)
    end

    def switch_frame(*args)
      @frame = @browser.iframe(*args)
    end

    # 切换回到默认主页面
    def switch_to_default_content
      @browser.switch_to.default_content
      @frame = false
    end


    # 紧紧查找元素
    def find_element(key,args)
      @element = select_tag_list(key,args)
      @element
    end
    #多元素定位输入
    # key 元素标签名
    # args 为传入的定位元素的属性散列，
    # text 为输入内容
    def input_text(key,args,text)         #9/13新加
      ele =select_tag_list(key,args)
      ele.set(text)
    end

    #点击
    def click_elmts(key,args)               #9/13新加
      ele=select_tag_list(key,args)
      ele.click
    end

    #悬浮
    def hover_elmts(key,args)
      ele=select_tag_list(key,args)
      ele.hover
    end

    #右键
    def right_click_elmts(key,args)
      ele=select_tag_list(key,args)
      ele.right_click
    end

    #双击
    def double_click_elmts(key,args)
      ele=select_tag_list(key,args)
      ele.double_click
    end

    #获取text
    def get_text(key,args)               #9/13新加
      ele=select_tag_list(key,args)
      ele.text
    end

    #获取value
    def get_value(key,args)               #9/13新加
      ele=select_tag_list(key,args)
      ele.value
    end

    #获取checked
    def get_check(key,args)               #9/13新加
      ele=select_tag_list(key,args)
      ele.checked
    end

    #获取元素属性值
    def get_attribute(key,args,attribute_name)
      ele=select_tag_list(key,args)
      ele.attribute_value(attribute_name)
    end

    #选择
    def select_text(key,args,text)
      ele=select_tag_list(key,args)
      ele.select(text)
    end


    #清空
    def clear_data(key,args)
      ele=select_tag_list(key,args)
      ele.clear
    end

    # 提交操作
    def form_submit(key,args)
      ele=select_tag_list(key,args)
      ele.submit
    end

    # tag: html中标签
    # action：set text value clear submit hover double_click  right_click select  checked
    # 根据不同的标签进行元素操作
    # 2017/03/31
    # 阚利君
    def operation(tag,action,args)
      if @frame
        br= @frame
      else
        br = @browser
      end
      if action.length==0
        eval "br.#{tag}(args[0])"
      elsif args.length==2
        if tag =='input'
         eval "br.text_field(args[0]).#{action.join('_')}(args[1])"
        else
          eval "br.#{tag}(args[0]).#{action.join('_')}(args[1])"
        end
      elsif args.length==1
        eval "br.#{tag}(args[0]).#{action.join('_')}"
      else
        fail 'args data for locating element is invalid!'
      end
    end
    #######方法：根据不同的标签对应属性定位到元素 供后续的元素操作
    #######date；2016/11/02
    #######author: kanlijun
    def select_tag_list (key,args)
      if @frame
        br= @frame
      else
        br = @browser
      end
      case key
        when 'div' then
          return br.div(args)
        when 'input'
          return br.input(args)
        when 'textarea'
          return br.textarea(args)
        when 'a'
          return br.a(args)
        when 'button'
          return br.button(args)
        when 'span'
          return br.span(args)
        when 'checkbox'
          return br.checkbox(args)
        when 'select_list'
          return br.select_list(args)
        when 'select'
          return br.select(args)
        when 'link'
          return br.link(args)
        when 'i'
          return br.i(args)
        when 'form'
          return br.form(args)
        when 'iframe'
          return br.iframe(args)
        when 'img'
          return br.img(args)
        when 'p'
          return br.p(args)
        when 'li'
          return br.li(args)
        when 'label'
          return br.label(args)
        when 'b'
          return br.b(args)
        when 'td'
          return br.td(args)
        when 'radio'
          return br.radio(args)
        when 'tbody'
          return br.tbody(args)
      end
    end

    ################################################################################################################################################
    #checkbox标签点击
    def click_checkbox_elmts(*args)                  #9/13新加
      @browser.checkbox(*args).set(value=true)
    end

    # 选择
    def select_list_set_value(name, value) #新加
      @browser.select_list(:name, name).option(:value,value).select
    end

    #截图
    def screenshots_to(path)
      @browser.screenshot.save(path)
    end

    # 键盘事件方法 :enter :space :tab :return
    def send_to_keys(key)      #20161103
      @browser.send_keys key
    end

    # alert 操作
    # 判断是否存在；确定关闭；获取alerttext close
    def alert_operate(status)
      case status
        when 'exists?'
          @browser.alert.exists?
        when 'ok'
          @browser.alert.ok
        when 'text'
          @browser.alert.text
        when 'close'
          @browser.alert.close
      end
    end

  end
end


