# encoding:utf-8
# author:kanlijun
require 'json'
require 'net/http'
require 'uri'
require 'rest-client'

module InterfaceFrame
  class HttpRequest
    class<<self
      # http:post  request's data can be json string
      def post_json *args
        begin
          uri = URI.parse args[0]
          req = Net::HTTP::Post.new(uri.request_uri,args[2])
          req.body = args[1].to_json
          res = Net::HTTP.start(uri.hostname, uri.port) do |http|
            http.request(req)
          end
          return JSON.parse(res.body)
        rescue Exception=>e
          puts e.message
          puts e.backtrace
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
          puts e.message
          puts e.backtrace
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
          puts e.message
          puts e.backtrace
          if res==nil
            return e.message
          elsif !res.body.match(/{.*}/)
            return res.code+'-'+e.message
          else
            return e.message
          end
        end
      end

      # form_data  with header data
      # http:post  request's data can be data form
      def get_form_with_header(*args)
        begin
          uri = URI.parse(args[0])
          res = Net::HTTP.start(uri.host,uri.port){|http|
            req = Net::HTTP::Get.new(uri.path,args[2])
            req.set_form_data args[1]
            http.request(req)
          }
          return JSON.parse(res.body)
        rescue Exception=>e
          puts e.message
          puts e.backtrace
          if res==nil
            return e.message
          elsif !res.body.match(/{.*}/)
            return res.code+'-'+e.message
          else
            return e.message
          end
        end
      end

      # URI.encode_www_form([["q", "ruby"], ["lang", "en"]])
      # #=> "q=ruby&lang=en"
      def get_form *args
        begin
          uri = URI.parse(args[0])
          uri.query=URI.encode_www_form(args[1])
          res = Net::HTTP.get_response(uri)
          return JSON.parse(res.body)
        rescue Exception=>e
          puts e.message
          puts e.backtrace
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
      def get *args
        begin
          uri = URI(args[0])
          res = Net::HTTP.get_response(uri)
          return JSON.parse(res.body)
        rescue Exception=>e
          puts e.message
          puts e.backtrace
          if res==nil
            return e.message
          elsif !res.body.match(/{.*}/)
            return res.code+'-'+e.message
          else
            return e.message
          end
        end
      end

      def up_post(*args)
        begin
          res =RestClient.post(args[0],args[1],args[2])
          return JSON.parse(res.body)
        rescue Exception=>e
          puts e.backtrace
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

  end

end