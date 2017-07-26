# InterfaceFrame
InterfaceFrame is Automated Test Framework that examining interface services for mobanker。
It provides several ways for http service,including post with form data or json data, get with form data or json data,and
post with files uploading. 
## Installation

install it yourself as:

    $ gem install interface_frame

## Usage

Tester just transfer url, request data, expected data by method "InterfaceFrame.executing".
The framework present finally testing-report forms. when executing single case,terminal shows request data and testing result. When executing lots of cases,outputting request data and result into excel.

If you want to use, just following:

require 'interface_frame'

## Description for function
### updating in 2017-02-15

新版API自动化测试框架第一版
 1、实现http请求；
 2、接口请求结果自行分析校验；
 3、增加终端分析报告以及excel汇总报告两种类型；

### updating in 2017-03-06（v1.2.0）

新增功能：
1、终端报告增加实时成功失败场景数量统计；并以红色和绿色区分；
2、http请求增加异常backtrace打印，便于问题跟踪；
3、附加期望值和实际值增加异常值处理；

### updating in 2017-03-07（v1.3.0）

1、修复返回报文过长，excel存储失败问题
2、修复实际返回报文数组数据为空校验逻辑问题

### updating in 2017-03-08（v1.3.0）

1、增加线程保护

2、报告中有执行失败场景增加_fail备注

### updating in 2017-03-14(v1.4.0)

1、excel报告增加错误场景数量标示（执行场景有失败文件名标注fail以及错误场景数量）

2、框架增加邮件发送模块，可调用可屏蔽。

3、报文中 hash数组 结果校验优化

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/interface_frame.

