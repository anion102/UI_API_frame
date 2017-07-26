#encoding:utf-8
#author:kanlijun
module UiFramework
  class Analyse
    @@case =1
    @@compare = true
    @@pass = 0
    @@fail = 0
    class << self

      #用户调试（单个接口测试）打印测试场景相关信息
      #2017-02-17
      #增加数据库期望实际值处理逻辑
      #kanlijun
      #2017/03/06 增加场景执行汇总信息
      def output_terminal(case_name,actual,expect,compare,compare_desc,exception,time)
        put_info("测试场景#{@@case}: ",34,case_name)
        put_info('运行时长(S): ',30,time)
        put_info('实际值: ',30,actual)
        put_info('期望值: ',30,expect)
        unless exception==nil
          put_info('异常信息: ',31,exception.message)
          puts exception.backtrace
        end
        if compare.include?(false)
          @@fail+=1
          index =compare.index(false)
          put_info(31,"校验结果失败描述出现在第#{index+1}个: ",31,compare_desc[index])
          put_info(31,'************************************校验结果: ',31,"Fail***********************************\n")
          put_info(31,"************************************汇总: ",31,"Pass:#{@@pass}  Fail:#{@@fail}*************************************")
        else
          @@pass+=1
          put_info(32,'************************************校验结果: ',32,"Pass***********************************\n")
          put_info(32,"************************************汇总: ",32,"Pass:#{@@pass}  Fail:#{@@fail}*************************************")
        end
        @@case += 1
      end

      #02-13
      #2017-02-17
      #增加数据库期望实际值处理逻辑
      #kanlijun
      def input_temporary_file(file_path,case_name,actual,expect,result,result_desc,ex,path,time)
        name =file_path.split('/')[-1]
        file =File.open(path,'a+')
        unless ex==nil
          file.write("#{name}阚%#{case_name}阚%#{actual}阚%#{expect}阚%#{result}阚%#{result_desc}阚%#{ex.message}-#{ex.backtrace[0]}阚%#{time}阚%")
        else
          file.write("#{name}阚%#{case_name}阚%#{actual}阚%#{expect}阚%#{result}阚%#{result_desc}阚%#{ex}阚%#{time}阚%")
        end
        file.write("\n")
        file.close
      end

      #02-13将结果写入excel中
      def input_excel(log_path,report,excel_path)
        data =read_config_log(log_path)    # 读取config.log内容
        result = report.fill_in_testcase(data)
        report.excel_save(excel_path)
        File.delete(log_path) if File.exist? log_path
      end

      #02-13
      def read_config_log(path)
        f =File.open(path,'r')
        lines= f.readlines
        data=Array.new(lines.length,Array.new)
        for i in 0..lines.length-1
          m=lines[i].force_encoding('gbk').force_encoding('utf-8')
          line=m.split('阚%')[0..-1]
          data[i]=line
        end
        f.close
        return data
      end

      # 2017/03/06 增加参数值异常处理
      def compare_array(actual,expect)
        if actual.class!=Array||expect.class!=Array
          return false
        elsif actual.length!=expect.length
          return false
        else
          i=0
          compare_result=[]
          expect.each do |item|
            result = (item!=nil&&item==actual[i])
            compare_result[i]=result
            i +=1
          end
          return compare_result
        end
      end
      ##02-13打印日志
      def put_info(name_ty=34,name,c_ty,c)
        puts "\033[#{name_ty}m#{name}\033[0m"+"\033[#{c_ty}m#{c}\033[0m\n"
      end

    end
  end
end