# encoding: utf-8
# author: kanlijun
require 'yaml'
require_relative 'interface_frame/version'
require_relative 'frame_driver'

=begin
框架入口方法InterfaceFrame::FrameDriver.executing
executing 说明：
1.期望值:可以是报文正则表达式（参数格式严格如下：使用ruby对象，以及双引号），可以是某一个参数值
  expect = /{.*"data"=>{"key1"=>".*?", "key2"=>"\d{1,}"}.*}/
  expect = {"data"=>[{'key2'=>'1'},{"key1"=>"83e",'key2'=>'2'}]}
  expect ={'key0'=>'1',"key1"=>"0"}

2.http请求支持方式在LIST中 默认post_from；header默认 ={"Content-type"=>"application/json"}

3.接口请求异常置于接口返回报文中；测试执行异常信息置于exception中

4.flag参数：flag=1 判定只进行接口返回校验；flag=0接口校验完成后进行数据库校验

增加extra方法对数据库数据校验做兼容
=end

module InterfaceFrame
  # Your code goes here...

end
