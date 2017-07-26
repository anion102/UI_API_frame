#encoding:utf-8
#author:kanlijun

require_relative 'auto_report/analyse'
require_relative 'auto_report/generate_app_report'
module UiFramework
  PATH = 'yaml_config.log'
  class Driver
    @@time =[Time.now.to_i]
    def self.config
      File.delete(PATH) if File.exist? PATH
      f =File.new(PATH, 'a+')
      f.close
    end

    def self.checking(file,case_name,expect,actual,compare_desc,exception=nil)
      compare =Analyse.compare_array(expect,actual)
      fail '期望值或者实际值传入格式有误' unless compare

      @@time << Time.new.to_i
      if File.exist? '../'+PATH
        Analyse.input_temporary_file(file,case_name,actual,expect,compare,compare_desc,exception,'../'+PATH,@@time[-1]-@@time[-2])
      else
        Analyse.output_terminal(case_name,actual,expect,compare,compare_desc,exception,@@time[-1]-@@time[-2])
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
    def self.generate_report(path="#{Time.now.strftime('%Y%m%d%H%M%S')}.xls")
      begin
        # File.delete(path) if File.exist? path   # path是excel存放位置
        report =UiFramework::GenerateAppReport.new
        report.create_report_file
        @result = Analyse.input_excel(PATH,report,path)
      rescue Exception=>e
        puts e.message
        puts e.backtrace
      end

    end

    def self.transfer_emails(case_path,autotest_project_name,email_address,email_port=25,sender,pwd,receive)
      fail =@result[1]-@result[0]
      p fail
      send_email(@result[0],fail,case_path,autotest_project_name,email_address,email_port,sender,pwd,receive)
    end

  end
end