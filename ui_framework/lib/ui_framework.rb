require_relative 'ui_framework/version'

# 申明一个全局驱动变量，供 appium 启动或浏览器启动使用
# $Browser = nil

require_relative 'ui_framework/app_driver'
require_relative 'ui_framework/driver'
require_relative 'ui_framework/browser_driver'

$driver =nil