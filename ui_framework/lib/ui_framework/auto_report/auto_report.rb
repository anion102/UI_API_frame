=begin
  encoding:utf-8
  author:阚利君
  date：2016/11/23
=end
require_relative '../../mobanker_app_source/auto/excel_spread'
require_relative '../../mobanker_app_source/auto/write_case_result'
require_relative '../../mobanker_app_source/auto/generate_app_report_mac'

module AutoReport

  PATH='temp_config.log'

  ##存放测试用例描述
  class <<self
    # 2017/02/28
    # 兼容批量跑脚本生成一次性报告
    # author kanlijun
    def config
      File.delete(PATH) if File.exist? PATH
      f =File.new(PATH, 'a+')
      f.close
    end

    def param_init file_name
      @@file_name=file_name
      @@desc=[]
      @@case_result=[]
      @@desc_path='../source/data/desc.txt'
      unless File.exist? '../'+PATH
        @@assert = ExcelSpread.new(file_name)
      end
      @@path="../assert_res/"
      @@time=[]
      @@time<<Time.now
    end
    def assert_process(test_name, expect, ret, line, sum, rescue_message)
      actual=Array.new(expect.length,nil)
      actual=array_str_operate(sum,actual)
      ##########################断言比较结果#######################################
      arr=compare_arr(expect,actual)
      ##########################test执行结果#######################################
      result = !arr.include?(false)
      if File.exist?('../'+PATH)
        WriteCaseResult.input_temporary_file(@@file_name,@@desc,expect,actual,arr,ret,rescue_message,'../'+PATH)
      else
      ##########################写入excel#######################################
        @@assert.add_context(test_name,result,rescue_message)
        @@assert.add_array(expect,actual,line,ret,arr)
      end
      return result
    end

    def assert_report_show
      unless File.exist?('../'+PATH)
        puts '******自动化结果生成******'
        #功能描述
        WriteCaseResult.write_desc_data(@@file_name,@@desc,@@desc_path)
        #用例执行结果
        WriteCaseResult.file_initial('../spec/'+@@file_name+'.txt')
        WriteCaseResult.write_result(@@file_name,@@case_result,@@time)
        @@assert.save_excel(@@file_name,@@path,@@time,@@desc)
      else
        WriteCaseResult.write_time(@@time,'../'+PATH)
      end

    end

    def check_array?(arr,len)
      if arr==nil
        return Array.new(len,'failed')
      end
    end

    def compare_arr(a,b)
      i=0
      c=[]
      a.each do |item|
        result = (item!=nil&&item==b[i])
        c[i]=result
        i +=1
      end
      return c
    end

    def array_str_operate(args,act)
      args.flatten!
      i =0
      args.each do |q|
        unless q==nil
          act[i]=q
          i+=1
        else
          break
        end
      end
      return act
    end

    def automating_reports(file_path="#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx")
      begin
        rows = WriteCaseResult.read_temporary_file(PATH)
        p rows
        generate =GenerateAppReportMac.new
        generate.create_report_file
        generate.fill_in_testcase(rows)
      rescue Exception=>e
        puts e.message
        puts e.backtrace
      ensure
        generate.excel_save(file_path)
        File.delete(PATH) if File.exist? PATH
      end
    end
  end

end