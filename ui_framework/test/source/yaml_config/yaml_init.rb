# encoding:utf-8
# author: kanlijun
require 'yaml'
Module.new do

  #获取目录下rb文件
  def self.back_yml(file_path)
    if File.directory? file_path
      arr=[]
      Dir.foreach(file_path) do |file|
        if file.match(/(.*).yml/)
          arr<<file
        end
      end
      return arr
    else
      puts "file_path is not exist!"
    end
  end

  $params={}
  path =File.dirname(__FILE__)+'/data/'
  back_yml(path).each do |file|
    key =file.split('.')[0]
    $params[key]= YAML.load_file(path+file)
  end
end
