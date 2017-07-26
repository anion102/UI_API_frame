# encoding:utf-8
# author:anion
require 'json'
require 'net/http'
require 'uri'

module HttpRequest

  # http:post  request's data can be json string
  def post_json *args
    begin
      uri = URI.parse args[0]
      req = Net::HTTP::Post.new(uri.request_uri,args[2])
      req.body = args[1]
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      return JSON.parse(res.body)
    rescue Exception=>e
      if res==nil
        return e.message
      elsif !res.body.match(/{.*}/)
        return res.code+'-'+e.message
      else
        return e.message
      end
    end
  end

  # http:post  request's data can be data form
  def post_form(*args)
    begin
      uri = URI.parse(args[0])
      res = Net::HTTP.start(uri.host,uri.port){|http|
        req = Net::HTTP::Post.new(uri.path,args[2])
        req.set_form_data args[1]
        http.request(req)
      }
      return JSON.parse(res.body)
    rescue Exception=>e
      if res==nil
        return e.message
      elsif !res.body.match(/{.*}/)
        return res.code+'-'+e.message
      else
        return e.message
      end
    end
  end

  #http:get  request's data can be json string
  def get_json *args
    begin
      uri = URI.parse args[0]
      req = Net::HTTP::Get.new(uri.request_uri,args[2])
      req.body = args[1]
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      return JSON.parse(res.body)
    rescue Exception=>e
      if res==nil
        return e.message
      elsif !res.body.match(/{.*}/)
        return res.code+'-'+e.message
      else
        return e.message
      end
    end
  end

  #get请求 请求包是表单格式，返回body并转换成json对象text/html;charset=UTF-8
  def get_form *args
    begin
      uri = URI.parse(args[0])
      uri.query=URI.encode_www_form(args[1])
      res = Net::HTTP.get_response(uri,args[2])
      return JSON.parse(res.body)
    rescue Exception=>e
      if res==nil
        return e.message
      elsif !res.body.match(/{.*}/)
        return res.code+'-'+e.message
      else
        return e.message
      end
    end
  end

  # directly go to url
  def get url
    begin
      uri = URI(url)
      res = Net::HTTP.get_response(uri)
      return JSON.parse(res.body)
    rescue Exception=>e
      if res==nil
        return e.message
      elsif !res.body.match(/{.*}/)
        return res.code+'-'+e.message
      else
        return e.message
      end
    end
  end
end