# encoding:utf-8
# author: kanlijun

require 'spreadsheet'
module UiFramework
  # date:2017/03/14
  # author: kanlijun
  # app老框架增加的生成一次性总的报告--只是给老框架ios
  class GenerateAppReport
    def initialize
      @workbook
    end

    def excel_new(encoding='utf-8')
      Spreadsheet.client_encoding =encoding
      @workbook = Spreadsheet::Workbook.new
    end

    #初始化创建excel报告模板
    def create_report_file
      excel_new
      @worksheet = @workbook.create_worksheet :name=>'自动化测试报告'

      @worksheet[0,0] = "测试结果"
      #设置title格式
      title=Spreadsheet::Format.new(:color=>:xls_color_13, :weight => :bold, :pattern => 1,:border=>:thin,
                                    :pattern_fg_color => :xls_color_39, :horizontal_align=>:center, :size=>24,:text_wrap=>true)
      @worksheet.merge_cells(0,0,0,6)
      7.times do |num|
        @worksheet.row(0).set_format(num,title)
      end
      #测试场景汇总信息设置
      list=Spreadsheet::Format.new(:color=>:xls_color_13, :weight => :bold, :pattern => 1,
                                    :pattern_fg_color => :xls_color_39,:size=>12,:border=>:thin)

      test=['测试日期:','测试场景总数:','测试通过率:']
      i=0
      [1,2,3].each {|row|
        @worksheet[row,0]=test[i]
        @worksheet.row(row).set_format(0,list)
        @worksheet.merge_cells(row,1,row,6)
        6.times do |n|
          @worksheet.row(row).set_format(n+1,list)
        end
        i+=1
      }
      #执行时间
      date,t =time_now
      @worksheet[1,6] = date

      #excel列宽配置
      i=0
      [37,20,25,26,15,31,31].each do |item|
        set_width(i,item)
        i+=1
      end

      #编辑测试场景列名
      @worksheet[4,0]="测试场景"
      @worksheet[4,1]='运行时长'
      @worksheet[4,2]='断言预期结果'
      @worksheet[4,3]='断言实际结果'
      @worksheet[4,4]='断言执行结果'
      @worksheet[4,5]='执行结果备注'
      @worksheet[4,6]='异常结果备注'
      cases = Spreadsheet::Format.new(:weight=>:bold,:pattern=>1,:pattern_fg_color => :xls_color_52,:size=>12,:border=>:thin)
      7.times {|i| @worksheet.row(4).set_format(i,cases)}

      # @worksheet.freeze!(5,7)
      # @workbook.write("test1.xls")
    end

    #03-14 将接口名字写入excel中
    def  fill_in_interface(name,row)
      #将接口测试场景写入excel之前，将接口名写入excel
      @worksheet[row,0] = '测试脚本文件名'
      @worksheet[row,1] = name
      @worksheet.merge_cells(row,1,row,6)
      format =Spreadsheet::Format.new(:weight=>:bold,:size=>12,:pattern=>1,:pattern_fg_color=>:xls_color_39,:border=>:thin)
      set_height(row,19)
      7.times do |i|
        @worksheet.row(row).set_format(i,format)
      end
    end


    # 03-14 各测试用例详情写入excel中
    # 2017/03/14
    # 更新：固定interface行 行高不变，其他行数调整为60
    # kanlijun
    def fill_in_testcase(data)
      row = 5
      #校验用例总数
      num = 1
      #测试场景统计
      case_num=0
      #通过的用例数
      pass = 0
      name = data[0][0]
      interface =[]
      fill_in_interface(name,row)
      interface << row
      row +=1
      format=Spreadsheet::Format.new(:border=>:thin,:size=>11)
      data.each do |line|
        p line
        p line[4]
        unless line[0] == name
          name=line[0]
          fill_in_interface(name,row)
          interface << row
          row += 1
        end

        unless line[1]==@worksheet[row-1,0]          #测试场景描述
          @worksheet[row,0] = line[1]
          case_num +=1
        else
          @worksheet[row,0] = ''
        end
        @worksheet[row,1] =line[7]                          #运行时长
        @worksheet[row,6] =line[6]                          #异常结果备注

        #将数组字符串转换为数组
        expect=line[2].gsub(/\"/,'')[1..-2].split(',')
        actual=line[3].gsub(/\"/,'')[1..-2].split(',')
        assert_desc=line[5].gsub(/\"/,'')[1..-2].split(',')
        result =line[4].gsub(/\"/,'')[1..-2].split(',')
        p expect
        p actual
        p assert_desc
        p "result: #{result}"
        #使用执行结果备注做循环体 循环写入结果
        i =0
        assert_desc.each do |item|
          7.times do |i|
            @worksheet.row(row).set_format(i,format)
          end
          @worksheet[row,2] = expect[i]                          #断言预期结果
          @worksheet[row,3] = actual[i]                          #断言实际结果
          if result[i].strip=='true'
            @worksheet[row,4] = 'pass'
            green=Spreadsheet::Format.new(:pattern=>1,:pattern_fg_color=>:green,:border=>:thin,:size=>11)#断言执行结果
            @worksheet.row(row).set_format(4,green)

            pass += 1
          else
            @worksheet[row,5] = item                             #执行失败 备注
            @worksheet[row,4] = 'fail'                           #断言执行结果
            red=Spreadsheet::Format.new(:pattern=>1,:pattern_fg_color=>:red,:border=>:thin,:size=>11)
            @worksheet.row(row).set_format(4,red)
          end
          set_height(row,27)

          i +=1
          row += 1
          num += 1
        end

      end
      @worksheet[2,6] = case_num
      @worksheet[3,6] = ((pass.to_f/(num - 1))*100).round(2).to_s+'%'
    end

    def excel_save(file_path)
      #Save the Workbook at the specified Path with the Specified Name
      if File.exist?(file_path)
        File.delete(file_path)
      end
      @workbook.write(file_path)
      # @workbook.close(1)                       #关闭表sheet空间
    end

    def time_now
      t = Time.now
      date=t.strftime('%Y-%m-%d')
      time=t.strftime('%H:%M:%S')
      return date,time
    end

    def set_height(row,h)
      @worksheet.row(row).height=h
    end

    def set_width(col,w)
      @worksheet.column(col).width=w
    end

end
end