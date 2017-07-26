# encoding:utf-8
# author: kanlijun

require_relative 'interface_frame/http_request'
require_relative 'interface_frame/execute_statistics'
require_relative 'interface_frame/send_email'

module InterfaceFrame
  PATH = 'config.log'
  LIST = ['post_form', 'post_json', 'get_form', 'get_json', 'get', 'up_post']
  class FrameDriver
    attr_reader :url
    attr_reader :request
    attr_reader :desc
    attr_reader :expect
    attr_reader :exception
    attr_reader :comparision
    attr_reader :file
    attr_reader :result

    def self.config
      File.delete(PATH) if File.exist? PATH
      f =File.new(PATH, 'a+')
      f.close
    end

    #供测试调用的执行方法 发起http请求以及结果校验
    def self.executing(url, req, desc, expect, exception, flag=1, header ={"Content-type"=>"application/json"}, httpType='post_form')
      @url=url
      @request=req
      @desc=desc
      @expect=expect
      @exception=exception

      unless LIST.include?(httpType)
        fail "httpType value:#{httpType} is invalid;\ntemporarily support['post_form','post_json','get_form','get_json','get']"
      end
      if req==nil
        @actual = 'The request data is nil'
      elsif url==nil||url==''
        @actual = 'The request url is invalid'
      else
        @actual = eval "InterfaceFrame::HttpRequest.#{httpType}(\"#{url}\",#{req},#{header})"
      end

      if ! @actual.to_s.match(/{.*}/)
        puts "#{desc}场景异常: #{@actual}"
        # exit(-1)  脚本直接终止不再继续执行
      else
        #进行实际值和期望值比较 将结果记录至excel中
        comparision =Statistic.compare_result(expect,@actual)
        @comparision = comparision
      end

      #将请求报文,实际结果以及用例描述存入excel中--方法
      @file = File.exist? '../'+PATH
      if flag == 1
        if @file
          t1 =Thread.new{Statistic.input_temporary_file(url,req,@actual,expect,comparision,desc,'../'+PATH,exception)}
          t1.join
        else
          t2 =Thread.new{Statistic.output_terminal(req,@actual,expect,comparision,desc,exception)}
          t2.join
        end
      else
        puts '***************extra data test'
      end
      return @actual
    end


    #2017/02/16 增加数据库数据校验
    def self.extra(actual,expect)
      sql_compare =Statistic.compare_array(actual,expect)
      result = sql_compare&&@comparision
      if @file
        t1=Thread.new{Statistic.input_temporary_file(@url,@request,@actual,@expect,result,@desc,'../'+PATH, @exception,actual,expect)}
        t1.join
      else
        t2 =Thread.new{Statistic.output_terminal(@request,@actual, @expect, result, @desc, @exception,actual,expect)}
        t2.join
      end
    end


    #获取目录下rb文件
    def self.select_rb_file(file_path)
      if File.directory? file_path
        arr=[]
        Dir.foreach(file_path) do |file|
          if file.match(/(.*).rb/)
            arr<<file
          end
        end
        return arr
      else
        puts "file_path is not exist!"
      end
    end

    # 解析log数据进行excel报告生成
    # 报告默认地址在调用脚本所在目录
    def self.generate_report(start,path="#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx")
      begin
        # File.delete(path) if File.exist? path   # path是excel存放位置
        report =InterfaceFrame::CreateReport.new
        report.create_report_file(start,Time.now.strftime('%H:%M:%S'))
        @result = Statistic.input_excel(PATH,report,path)
      rescue Exception=>e
        puts e.message
      end

    end

    def self.transfer_emails(case_path,autotest_project_name,email_address,email_port=25,sender,pwd,receive)
      fail =@result[1]-@result[0]
      p fail
      InterfaceFrame.send_email(@result[0],fail,case_path,autotest_project_name,email_address,email_port,sender,pwd,receive)
    end

  end

end
