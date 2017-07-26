# encoding:utf-8
# author:anion
require 'openssl'
require 'base64'
require 'digest'
module EnDecrypt
  # set cipher algorithm mode
  ALG='DES-EDE3'

  def rsa_encrypt(public_key,data)
    rsa= OpenSSL::PKey::RSA.new(Base64.decode64(public_key))
    # rsa= OpenSSL::PKey::RSA.new(File.read('./public_key.pem'))
    rsa_data = rsa.public_encrypt(data)
    result =Base64.encode64(rsa_data)
    result.gsub!("\n",'')
  end

  def digest_sha?(data,type)
    case type
      when 1
        Digest::SHA1.hexdigest(data)
      when 256
        Digest::SHA256.hexdigest(data)
      when 384
        Digest::SHA384.hexdigest(data)
      when 512
        Digest::SHA512.hexdigest(data)
    end
  end

  def des3_encrypt(des_key, des_text)
    des =OpenSSL::Cipher::Cipher.new(ALG)
    des.encrypt
    des.key=des_key
    result = des.update(des_text)
    result << des.final
    data=Base64.encode64(result)
    data.gsub!("\n",'')
  end

  def des3_decrypt(des_key,des_text)
    des =OpenSSL::Cipher::Cipher.new(ALG)
    des.decrypt
    des.padding=7           # set pckspadding1--7
    des.key=des_key
    text = Base64.decode64(des_text)
    result = des.update(text).gsub(/\t|\b|\n/,'')
    result << des.final
    result
  end
end
