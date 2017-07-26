# encoding:utf-8
# author:kanlijun
require '../lib/interface_frame'
case_path='./case/'
start = Time.now.strftime('%H:%M:%S')
report_file=File.expand_path("./mobanker_api_test#{Time.now.to_i}.xlsx").gsub(/\//,'\\')

#触发excel配置
InterfaceFrame::FrameDriver.config
#批量执行脚本
begin
  cases =InterfaceFrame::FrameDriver.select_rb_file(case_path)
  cases.each do |file|
    system ("cd #{case_path}&&ruby #{file}")
  end
rescue Exception=>e
  puts e.message
ensure
  InterfaceFrame::FrameDriver.generate_report(start,report_file)

  ####发送邮件模块
=begin
  address='stmp.mobanker.com'
  pwd =''         #邮箱密码
  sender=''       #发件人
  receiver =''    #收件人
  InterfaceFrame::FrameDriver.transfer_emails(report_file,'测试Demo',address,sender,pwd,receiver)
=end
end
