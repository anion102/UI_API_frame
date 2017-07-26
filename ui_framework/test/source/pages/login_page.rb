#encoding:utf-8
#author:kanlijun

class LoginPage
  include UiFramework::BrowserDriver
  def initialize
    @log = {
    }
  end

  def login(user,pwd)
    # send(:input_set,@log['user'],user)
    input_set(@log['user'],user)
    send(:input_set,@log['password'],pwd)
    send(:button_click,@log['login_button'])
  end

  def test(switch)
    switch
  end
end
