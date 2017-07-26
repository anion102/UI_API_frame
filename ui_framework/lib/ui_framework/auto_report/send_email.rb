#encoding:utf-8
require 'mail'

def send_email sum,fail,case_path,name,receive
  smtp = { :address => 'smtp.mobanker.com', :port => 25, :domain => 'mobanker.com',
           :user_name => 'kanlijun@mobanker.com', :password => '******',
           :enable_starttls_auto => true, :openssl_verify_mode => 'none' }
  Mail.defaults { delivery_method :smtp, smtp }
  mail = Mail.new do
    from 'kanlijun@mobanker.com'
    to receive
    subject '自动化测试报告'
    body "各位好：
  附件为#{name.encode('utf-8')}，请查看。
  总结如下：本次回归共#{sum}个用例，失败#{fail}个

  说明：1.用例总数和失败数量是脚本统计出来的数据；
       2.详情见附件报告"
    add_file File.expand_path(case_path)
  end
  mail.deliver!
end


6.times do |i|
  p i+1
end