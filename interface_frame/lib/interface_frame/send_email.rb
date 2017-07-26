#encoding:utf-8
require 'mail'
module InterfaceFrame
  def self.send_email(sum,fail,case_path,name,email_address,email_port,sender,password,receive)

    smtp = { :address => email_address,
             :port => email_port,
             :domain => sender.split('@')[-1],
             :user_name => sender,
             :password => password,
             :enable_starttls_auto => true,
             :openssl_verify_mode => 'none' }
    Mail.defaults { delivery_method :smtp, smtp }
    mail = Mail.new do
      from sender
      to receive
      subject '自动化测试报告'
      body "各位好：
  附件为#{name.encode('utf-8')}自动化测试报告，请查看。
  总结如下：本次回归共#{sum}个用例，失败#{fail}个"
      add_file File.expand_path(case_path)
    end
    mail.deliver!
  end
end
