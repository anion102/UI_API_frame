#encoding:utf-8
#author:kanlijun

require 'active_record'
require 'mysql2'
require 'yaml'

require_relative 'yaml_config/yaml_init'
#数据库配置信息
config =$params['configure']['mysql']
db=$params['mysql']["#{config}"]
$mobp2p = db['db']

#定义ActiveRecord的子类对应相应需要用的表
#用户记录表
