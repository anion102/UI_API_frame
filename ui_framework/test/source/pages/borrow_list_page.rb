#encoding:utf-8
#author:kanlijun

class BorrowListPage
  include UiFramework::BrowserDriver
  def initialize
    @borrow ={
    }
  end

  def search_borrow(name)
    a_click(@borrow['list'])
    input_set(@borrow['search_name'],name)
    button_click(@borrow['search_btn'])
    sleep 2
    td = td({:text=>name})
    tbody = td.parent.parent
    result=[]
    for i in 0..1
      result << tbody[i][2].text==name
    end
    result
  end

end
