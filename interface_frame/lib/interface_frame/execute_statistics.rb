# encoding:utf-8
# author:kanlijun
require_relative 'create_report'

module InterfaceFrame

  class Statistic
    @@case =1
    @@compare = true
    @@pass = 0
    @@fail = 0
    class << self

      #结果比较执行
      def compare_result(expect,actual)
        if expect.to_s.match(/\?-mix:{.*}/)
          if actual.to_s.match(expect)
            return true
          else
            return false
          end
        elsif expect.class == Hash&&actual.class==Hash
          #精确比较hash内键值对
          compare_hash(expect,actual)
          result =@@compare
          @@compare = true
          return result
        else
          return false
        end
      end

      #用户调试（单个接口测试）打印测试场景相关信息
      #2017-02-17
      #增加数据库期望实际值处理逻辑
      #kanlijun
      #2017/03/06 增加场景执行汇总信息
      def output_terminal(req,actual,expect,compared,desc,exception,sql_actual='',sql_expect='')
        put_info("测试场景#{@@case}: ",34,desc)
        put_info('请求报文: ',30,req)
        put_info('实际返回报文: ',30,actual)
        put_info('附加比对实际值',30,sql_actual) if sql_actual!=''
        put_info('期望结果: ',30,expect)
        put_info('附加比对期望值',30,sql_expect) if sql_expect!=''
        unless exception==nil
          put_info('异常信息: ',31,exception.message)
          puts exception.backtrace
        end
        if compared
          @@pass+=1
          put_info(32,'************************************校验结果: ',32,"Pass***********************************\n")
          put_info(32,"************************************汇总: ",32,"Pass:#{@@pass}  Fail:#{@@fail}*************************************")
        else
          @@fail+=1
          put_info(31,'************************************校验结果: ',31,"Fail***********************************\n")
          put_info(31,"************************************汇总: ",31,"Pass:#{@@pass}  Fail:#{@@fail}*************************************")
        end
        @@case += 1
      end

      #02-13
      #2017-02-17
      #增加数据库期望实际值处理逻辑
      #kanlijun
      def input_temporary_file(url,req,actual,expect,comparision,desc,path,ex,sql_expect='',sql_actual='')
        name=url.split('/')[-1]
        file =File.open(path,'a+')
        unless ex==nil
          file.write("#{name}阚%#{desc}阚%#{req}阚%#{actual}阚%#{expect}阚%#{sql_actual}阚%#{sql_expect}阚%#{ex.message}-#{ex.backtrace[0]}阚%#{comparision}阚%")
        else
          file.write("#{name}阚%#{desc}阚%#{req}阚%#{actual}阚%#{expect}阚%#{sql_actual}阚%#{sql_expect}阚%#{ex}阚%#{comparision}阚%")
        end
        file.write("\n")
        file.close
      end

      #02-13将结果写入excel中
      def input_excel(log_path,report,excel_path)
        data =read_config_log(log_path)    # 读取config.log内容
        result = report.fill_in_testcase(data)
        report.excel_save(excel_path,result)
        File.delete(log_path) if File.exist? log_path
        [result[1],result[2]]
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

      # 比较实际hash值和期望hash值(满足实际hash包含期望hash值)
      def compare_hash(expect,actual)
        expect.each do |key,value|
          if value.class!=Hash&&value.class!=Array
            if actual==nil||(!actual.has_key?(key))
              @@compare = false
            else
              @@compare = false if actual[key]!=value
            end
          end
          if value.class==Array&&actual[key].class==Array
            for i in 0...value.length
              if value[i].class==String
                @@compare = false if value[i] != actual[key][i]
              else
                compare_hash(value[i],actual[key][i])
              end

            end
          elsif  value.class==Array&&actual[key].class!=Array

            @@compare=false
          elsif value.class==Hash&&actual[key].class==Hash

            compare_hash(value,actual[key])
          elsif  value.class==Hash&&actual[key].class!=Hash

            @@compare=false
          end
        end
      end
      # 2017/03/06 增加参数值异常处理
      def compare_array(actual,expect)
        if actual.class!=Array||expect.class!=Array

          return false

        elsif actual.length!=expect.length

          return false

        else
          i=0
          c=[]
          expect.each do |item|
            result = (item!=nil&&item==actual[i])
            c[i]=result
            i +=1
          end
          if c.include?(false)
            return false
          else
            return true
          end
        end
      end
      ##02-13打印日志
      def put_info(name_ty=34,name,c_ty,c)
        puts "\033[#{name_ty}m#{name}\033[0m"+"\033[#{c_ty}m#{c}\033[0m\n"
      end

    end

  end
end

=begin
actual= {"data"=>[{'userId'=>'1'},{"password"=>"1",'userId'=>'2'}],'product'=>['uzone','shoujidai']}
expect = {"data"=>[{'userId'=>'1'},{"password"=>"1",'userId'=>'2'}],'product'=>['uzone','shoujidai']}

result =InterfaceFrame::Statistic.compare_result(expect,actual)
p result
=end
