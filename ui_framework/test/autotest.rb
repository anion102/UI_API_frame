# encoding:utf-8
# author:kanlijun
require 'rspec/autorun'
require 'ui_framework'

case_path ='./test/'
UiFramework::Driver.config

cases = UiFramework::Driver.select_rb_file(case_path)
cases.each do |file|
  system ("cd #{case_path}&&ruby #{file}")
end
UiFramework::Driver.generate_report



