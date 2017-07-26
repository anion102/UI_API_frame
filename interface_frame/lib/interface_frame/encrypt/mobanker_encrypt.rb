# encoding:utf-8
# author: kanlijun
require 'yaml'
require_relative 'mobanker_encrypt/http_request'
require_relative 'mobanker_encrypt/en_decrypt'
module MobankerEncrypt
  # Your code goes here...
  include HttpRequest
  include EnDecrypt
  HOST = YAML.load(File.open('../source/service.yml'))['host']

  def encrypt_request_packet(req_data)
    # 第一次握手
    num1,first=first_shake
    sleep 1
    # 第二次握手
    num3,data =second_shake(num1,first)
    ####################################3des加密###############################
    serverCode=des3_decrypt(data['secret']+num3,data['signData'])
    # p "serverCode: #{serverCode}"
    key= num1+','+first['num2']+','+num3
    # p "key: #{key}"
    reqData=des3_encrypt(key,req_data.to_json)
    # p "reqData: #{reqData}"
    request={
        :uuid=>"#{serverCode}",
        :reqData=>reqData
    }
    return request
  end
  # create random number
  def generate_random(len)
    chars=('0'..'9').to_a
    number=''
    1.upto(len){ number<<chars[rand(chars.size-1)] }
    return number
  end

  def first_shake
    num1 = generate_random(32)
    req = {
        :reqData=>"{'num1':#{num1}}"}
    url = HOST+'security/firstShake'
    res = post_from(url,req)
    return num1,res['data']
  end

  def second_shake(num1,first)
    #### shake second
    rand=generate_random(32)
    num3=rsa_encrypt(first['publicKey'],rand)
    str = num1[0...first['tailor']]+','+num3
    # hsa256加密
    sign =digest_sha?(str,256)
    req={
        :reqData=>"{'uuid':'#{first['uuid']}','num3':'#{num3}','sign':'#{sign}'}"
    }
    # puts "sec_request:#{req}\n"
    url =HOST+'security/secondShake'
    res=post_from(url,req)
    puts "second_shake_response:#{res}\n"
    puts "**************************************************************************\n"
    data =res['data']
    return num3,data
  end
end
