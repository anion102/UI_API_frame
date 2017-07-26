#encoding:utf-8
#author:kanlijun
require 'active_record'
require 'mysql2'
require 'yaml'

#读取数据库配置信息
yaml=YAML.load(File.open('../config/database.yml'))
config=yaml['mysql']
config['database']='db'
$database=config

#星辰征信服务所需的表
class YUsers < ActiveRecord::Base
  self.table_name='t'
  self.establish_connection $database
  self.inheritance_column=nil
end

