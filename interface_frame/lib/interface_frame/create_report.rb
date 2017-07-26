# encoding:utf-8
# author: kanlijun
require 'win32ole'
module InterfaceFrame

  # open api testcase excel file
  # read and parse case_data to test api
  class CreateReport
    @@row = 9
    @@num = 1
    @@pass = 0
    def initialize
      @excel
      @result = true
    end

    def excel_new(encoding='utf-8')
      @@worksheets_name = []
      @excel = WIN32OLE.new("EXCEL.APPLICATION")
      @excel.Visible=false
      @workbook = @excel.WorkBooks.Add()
      @encoding = encoding
    end

    def open(path)
      @excel = WIN32OLE.new("EXCEL.APPLICATION")
      @workbook =@excel.Workbooks.Open(path)
      @objSheet =@workbook.Worksheets(1)
      @objSheet.UsedRange.Rows.Count
    end

    #初始化创建excel报告模板
    def create_report_file(start_time,end_time='')
      excel_new
      @excel.DisplayAlerts = false

      @objSheet =  @excel.Sheets.Item(1)
      @excel.Sheets.Item(1).Select
      @objSheet.Name = "自动化测试报告"

      @objSheet.Range("A1").Value = "测试结果"
      #合并单元格
      @objSheet.Range("A1:I1").Merge
      #水平居中 -4108
      @objSheet.Range("A1:I1").HorizontalAlignment = -4108
      @objSheet.Range("A1:I1").Interior.ColorIndex = 53
      @objSheet.Range("A1:I1").Font.ColorIndex = 5
      @objSheet.Range("A1:I1").Font.Bold = true
      @objSheet.Range("A1:I1").Font.Size =24

      # @objSheet.Range("B2:E2").Merge
      # @objSheet.Rows(2).RowHeight = 20

      rowNum = [2,3,4,5,6,7]
      rowNum.each {|re|
        @objSheet.Range("B#{re}:I#{re}").Merge}

      # @objSheet.Range("B9:E9").Merge
      # @objSheet.Rows(9).RowHeight = 30

      date,t =time_now
      #Set the Date and time of Execution
      @objSheet.Range("A2").Value = "测试日期: "
      @objSheet.Range("A3").Value = "开始时间: "
      @objSheet.Range("A4").Value = "结束时间: "
      @objSheet.Range("A5").Value = "持续时间: "
      @objSheet.Range("B2").Value = date
      @objSheet.Range("B3").Value = start_time
      @objSheet.Range("B4").Value = end_time
      @objSheet.Range("B5").Value = "=B4-B3"
      # @objSheet.Range("B5").Value = "=R[-1]B-R[-2]B"
      # @objSheet.Range("B5").NumberFormat ="[h]:mm:ss;@"

      #Set the Borders for the Date & Time Cells
      @objSheet.Range("A1:I7").Borders(1).LineStyle = 1
      @objSheet.Range("A1:I7").Borders(2).LineStyle = 1
      @objSheet.Range("A1:I7").Borders(3).LineStyle = 1
      @objSheet.Range("A1:I7").Borders(4).LineStyle = 1

      #Format the Date and Time Cells
      @objSheet.Range("A1:I7").Interior.ColorIndex = 40
      @objSheet.Range("A1:I7").Font.ColorIndex = 14
      @objSheet.Range("A1:I7").Font.Bold = true

      #Track the Row Count and insrtuct the viewer not to disturb this
      @objSheet.Range("B6").AddComment
      @objSheet.Range("B6").Comment.Visible = false
      @objSheet.Range("B6").Comment.Text "这点生成的数据大家不要删除哦"
      @objSheet.Range("B6").Value = "0"
      @objSheet.Range("A6").Value = "自动化测试场景总数:"
      @objSheet.Range("A7").Value = "测试通过率:"

      @objSheet.Range("A8").Value = "CaseID"
      @objSheet.Range("B8").Value = "用例描述"
      @objSheet.Range("C8").Value = "请求报文"
      @objSheet.Range("D8").Value = "实际返回报文"
      @objSheet.Range("E8").Value = "期望结果"
      @objSheet.Range("F8").Value = "附加比对实际值"
      @objSheet.Range("G8").Value = "附加比对期望值"
      @objSheet.Range("H8").Value = "异常信息"
      @objSheet.Range("I8").Value = "测试结果"

      #添加超链接功能
      # @objSheet.Hyperlinks.Add(@objSheet.Range("B9"), "","测试结果!A1")
      # @objSheet.Range("B9").Value = "点击测试用例名称打开详情页面."

      #  @objSheet.Hyperlinks.Add(@objSheet.Range("B9"), "http://www.163.com")
      #Format the Heading for the Result Summery
      @objSheet.Range("A8:I8").Interior.ColorIndex = 53
      @objSheet.Range("A8:I8").Font.ColorIndex = 1
      @objSheet.Range("A8:I8").Font.Bold = true
      @objSheet.Range("A8:I8").Font.Size = 13

      #Set the Borders for the Result Summery
      @objSheet.Range("A8:I8").Borders(1).LineStyle = 1
      @objSheet.Range("A8:I8").Borders(2).LineStyle = 1
      @objSheet.Range("A8:I8").Borders(3).LineStyle = 1
      @objSheet.Range("A8:I8").Borders(4).LineStyle = 1

      #Set Column width
      @objSheet.Columns("A:I").Select

      @objSheet.Range("A9").Select
      @objSheet.Range("A9").ColumnWidth=18
      @objSheet.Range("B9").ColumnWidth=24
      @objSheet.Range("C9").ColumnWidth=30
      @objSheet.Range("D9").ColumnWidth=30
      @objSheet.Range("E9").ColumnWidth=30
      @objSheet.Range("F9").ColumnWidth=18
      @objSheet.Range("G9").ColumnWidth=18
      @objSheet.Range("H9").ColumnWidth=15
      @objSheet.Range("I9").ColumnWidth=10

      #change line in cell

      # @objSheet.Columns("H").WrapText=true
      # #Freez pane
      @excel.ActiveWindow.FreezePanes = true
    end


    ###02-13 接口名称写入excel中
    def fill_in_interface(name,row)
      #将接口测试场景写入excel之前，将接口名写入excel
      @objSheet.Range("A#{row}").Value = 'Interface'
      @objSheet.Range("B#{row}").Value = name
      @objSheet.Range("B#{row}:I#{row}").Merge
      @objSheet.Range("A#{row}:I#{row}").Interior.ColorIndex = 40
      @objSheet.Rows(row).RowHeight=18
    end

    # 02-13 各测试用例详情写入excel中
    # 2017/02/21
    # 更新：固定interface行 行高不变，其他行数调整为成功30 失败60且格式自动换行
    # kanlijun
    def fill_in_testcase(data)
      row = 9
      num = 1
      pass = 0
      name = data[0][0]
      interface =[]
      fill_in_interface(name,row)
      interface << row
      row +=1
      data.each do |line|
        unless line[0] == name
          name=line[0]
          fill_in_interface(name,row)
          interface << row
          row += 1
        end
        @objSheet.Range("A#{row}").Value = num                #case id
        @objSheet.Range("B#{row}").Value = line[1]            #测试场景描述
        @objSheet.Range("C#{row}").Value = line[2]            #请求报文
        if line[3].length>=20000
          @objSheet.Range("D#{row}").Value = line[3][0...20000]     #实际结果长度超出excel单元格承受范围，截取部分存储
          @objSheet.Range("D#{row}").Interior.ColorIndex = 27
          @objSheet.Range("D#{row}").AddComment
          @objSheet.Range("D#{row}").Comment.Visible = false
          @objSheet.Range("D#{row}").Comment.Text "返回报文过长，末尾有省略"
        elsif line[3].length>=400
          @objSheet.Range("D#{row}").WrapText=true
        else
          @objSheet.Range("D#{row}").Value = line[3]            #实际结果
        end
        @objSheet.Range("E#{row}").Value = line[4]            #期望值
        @objSheet.Range("F#{row}").Value = line[5]            #附加比对实际值
        @objSheet.Range("G#{row}").Value = line[6]            #附加比对期望值
        @objSheet.Range("H#{row}").Value = line[7]            #异常信息存储位置
        if line[8]=='true'
          @objSheet.Range("I#{row}").Value = 'pass'            #校验结果值
          @objSheet.Range("I#{row}").Interior.ColorIndex = 4
          @objSheet.Rows(row).RowHeight=30
          pass += 1
        else
          @objSheet.Range("I#{row}").Value = 'fail'            #校验结果值
          @objSheet.Range("I#{row}").Interior.ColorIndex = 3
          @objSheet.Rows(row).RowHeight=60
          @objSheet.Range("C#{row}:H#{row}").WrapText=true
          @result = false

        end
        row += 1
        num += 1
      end

      ###############将用例总数以及成功率写入excel中##################
      @objSheet.Range('B6').Value = num - 1
      @objSheet.Range('B7').Value = ((pass.to_f/(num - 1))*100).round(2).to_s+'%'
      @objSheet.Range("A1:I#{row-1}").VerticalAlignment = -4160   #顶端对齐         #2017/02/20 新增对齐方式控制。
      @objSheet.Columns("B").WrapText=true
      # excel_save(excel_path)
      return @result,pass,num-1
    end


    def case_sheet_style(ed,sum,percent)
      @objSheet.Range("C6").Value=sum
      @objSheet.Range("C7").Value=percent
      @objSheet.Range("B9:E#{ed}").Borders(1).LineStyle = 1
      @objSheet.Range("B9:E#{ed}").Borders(2).LineStyle = 1
      @objSheet.Range("B9:E#{ed}").Borders(3).LineStyle = 1
      @objSheet.Range("B9:E#{ed}").Borders(4).LineStyle = 1
      @objSheet.Range("B9:E#{ed}").Font.Size = 12
    end

    def get_usedrows
      @objSheet.UserdRange.Rows.Count
    end

    def excel_save(file_path,result)
      #Save the Workbook at the specified Path with the Specified Name
      if File.exist?(file_path)
        File.delete(file_path)
      end
      unless result[0]
        fail_num=result[-1]-result[-2]
        file_path=file_path.insert(-6,"_fail_#{fail_num}")
      else
        file_path=file_path.insert(-6,"_success")

      end
      @excel.ActiveWorkbook.SaveAs(file_path)
      @excel.Quit()
      # @workbook.close(1)                       #关闭表sheet空间
    end

    def summary_case(end_time)
      @objSheet.Range("B4").Value = end_time
      @objSheet.Range("B5").Value = "=B4-B3"
      @objSheet.Range('B6').Value = num -1
      @objSheet.Range('B7').Value = ((@@pass.to_f/(@@num -1))*100).round(2).to_s+'%'
    end

    def time_now
      t = Time.now
      date=t.strftime('%Y-%m-%d')
      time=t.strftime('%H:%M:%S')
      return date,time
    end
  end
end