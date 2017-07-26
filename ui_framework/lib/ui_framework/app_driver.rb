#encoding: utf-8
#author: kanlijun
require 'appium_lib'
require 'watir-webdriver'
require 'selenium-webdriver'
require_relative './log/AppLogging'



module UiFramework

   module AppDriver
     include AppLogging

     def self.android_launch(platform_name = nil, device_name = nil, app_path = nil, udid =nil,ip='127.0.0.1', port=4723,noReset=true)
       begin
         # Start Android driver
         opts = {
             caps: {
                 platformName: platform_name,
                 deviceName: device_name,
                 app: app_path,
                 unicodeKeyboard: true,
                 resetKeyboard: true,
                 autoAcceptAlerts:true,
                 udid: udid,
                 noReset: noReset,
                 # fullReset: true,
                 ignoreUnimportantViews: true
             },
             appium_lib: {
                 sauce_username: nil,
                 sauce_access_key: nil,
                 debug: false,
                 port: port,
             },
         }
         Appium::Driver.new(opts).start_driver_server("http://#{ip}:#{port}/wd/hub")
       rescue Exception=>e
         puts e.message
         puts e.backtrace
       end
     end

     # iOS appium启动
     def self.ios_launch(platform_name =nil, device_name = nil, app_path = '', version='', udid=nil,ip='127.0.0.1',port=4723)
       begin
         opts = {
             caps: {platformName: platform_name,
                    deviceName: device_name,
                    app: app_path,
                    platformVersion: version,
                    udid: udid,
                    autoAcceptAlerts:true,
                    unicodeKeyboard: true,
                    resetKeyboard: true,
             },
             appium_lib: {
                 sauce_username: nil,
                 sauce_access_key: nil,
                 debug: true,
                 port: port

             },
         }

         Appium::Driver.new(opts).start_driver_server("http://#{ip}:#{port}/wd/hub")
         Appium.promote_appium_methods Object
       rescue Exception=>e
         puts e.message
         puts e.backtrace
       end
     end


     ######滑动app页面切换####
     def slide_to_select(start_x, start_y, end_x, end_y, wait_time)
       Appium::TouchAction.new.press(x: start_x, y: start_y).wait(wait_time).move_to(x: end_x, y: end_y).release.perform
     end

     ######坐标选择点击#####
     def location_select(x,y)
       Appium::TouchAction.new.press(x: x,y: y).release.perform

     end

     def get_window_size
       size = $driver.window_size
       return size.width,size.height
     end


     # 终止appium
     def driver_stop
       $driver.driver_quit
     end

     ## 输入数字字符串
     def input_cardnumber(str)
       for i in 0...str.length
         $driver.press_keycode(str[i].to_i+7)
       end
     end

     # 没看明白这个方法（没有等到点击返回 为什么还要再点击元素？？？？？）
     # 阚利君
     def wait_elmts(*args,time)                             #返回到首页
       while (! wait_element_with_time(*args,time))
         system("adb shell input keyevent 4")      #引用dos命令返回页面
       end
       $driver.find_element(*args).click
     end

     #发送系统键盘指令  http://www.cnblogs.com/paulwinflo/p/4754701.html
     def send_key(key)
       $driver.press_keycode(key)
     end
     ##*****************************多属性定位控件 开始

     # 直接元素点击
     def click_by_elmts(args)
       begin
         $driver.find_element(args).click
       rescue Exception=>e
         put_info('ERROR: ',31,"click the element #{args} failed!")
         return e.message
       end

     end

     # 获取元素的text值
     def get_text_by_elmts(args)
       begin
         $driver.find_element(args).text
       rescue Exception=>e
         app_error("get element #{args} text failed!")
         return e.message
       end
     end

     #给输入框元素输入文本值
     def input_text_by_elmts(args, text)
       $driver.find_element(args).send_keys(text)
     end

     #清空输入框元素的数据
     def clear_cookie_by_elmts(args)
       $driver.find_element(args).clear
     end

     # 等待元素 默认超时时间30S
     # 成功返回true
     # 等不到返回false
     def wait_element_by_elmts(args)
       begin
         wait = Selenium::WebDriver::Wait.new(:timeout => 15)
         res = wait.until { $driver.find_element(args).displayed? }
         return res
       rescue Exception=>ex
         puts ex.message
         put_info('ERROR: ',31,"wait for #{args} abnormally")
         return false
       end
     end


     # 等待元素出现；
     # 添加等待的时间
     # 异常返回false
     def wait_element_with_time(args,time)
       begin
         wait = Selenium::WebDriver::Wait.new(:timeout => time)
         res=wait.until { $driver.find_element(args).displayed? }
         return res
       rescue Exception=>ex
         puts ex.message
         put_info('ERROR: ',31,"wait for #{args} abnormally")
         return false
       end
     end

     # 通过text方法定位点击
     # 请求参数为元素的text值
     def click_element_by_text(text)
       text_find = $driver.text(text)
       text_find.click
     end

     # 截图保存至path路径
     # path:
     def screenshots (switch,path)
       $driver.screenshot(path) if switch=='on'
     end

     # link方法点击
     def link_text_click(text)
       $driver.link(:text, text).click
     end


     # 获取并返回屏幕的宽高以及比例
     def get_screen_x_y_axis_ratio
       screen_axis_y = $driver.window_size.height
       screen_axis_x = $driver.window_size.width
       k=screen_axis_y.to_f/screen_axis_x.to_f
       return k,screen_axis_x,screen_axis_y
     end

     # ios苹果手机屏幕宽高获取
     # 以iPhone6 作为参考；
     # 计算其他屏幕的宽和高相对比例值并返回
     def get_size_data(yaml)
       RateParse.expand_configs(yaml)
       h = $driver.window_size.height
       w = $driver.window_size.width
       text_w='I'+w.to_s+'_'+h.to_s+'_width'
       text_h='I'+w.to_s+'_'+h.to_s+'_height'
       rate_width=eval "Configs.#{text_w}"
       rate_height=eval "Configs.#{text_h}"
       return rate_width,rate_height
     end

     #点开对应的控件，用input_keyevent(num) num是你要输入的值
     #例如：input_keyevent(140300201403037034)
     def  input_keyevent(num)
       #keyenent  安卓对应的系统码 0=>7,1=>8,2=>9 ...
       ary = [0,7,1,8, 2,9,3,10,4,11, 5,12,6,13,7,14, 8,15,9,16]
       #转换成hash形式
       hash= Hash[*ary.flatten]
       res=num.to_s.split(//)
       ret=res.join(",")
       arr=ret.split(",")
       for i in 0...arr.length
         #用hash的方式取安卓对应的代码值，模拟手工按键
         system("adb shell input keyevent #{hash[arr[i].to_i]}")
         sleep 0.5
       end
     end
     #########################################################################################################################################

     #断言方法
     def verify_equal(expected_result, actual_result, message_send)
       if expected_result == actual_result
         puts expected_result
         puts actual_result
         app_info message_send
       end
     end

     private
     ##02-13打印日志
     def put_info(name_ty=34,name,c_ty,c)
       puts "\033[#{name_ty}m#{name}\033[0m"+"\033[#{c_ty}m#{c}\033[0m\n"
     end
  end
end
