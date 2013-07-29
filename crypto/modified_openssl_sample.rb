require "openssl"

data = "Basic CBC mode encryption needs padding."

cipher = OpenSSL::Cipher::AES.new(128, :CBC)
cipher.encrypt
key = ["140b41b22a29beb4061bda66b6747e14"].pack('H*')
iv = ["4ca00ff4c898d61e1edbf1800618fb28"].pack('H*')

puts "key: " + key
puts "iv: " + iv


encrypted = cipher.update(data) + cipher.final

puts encrypted.unpack('H*').to_s

decipher = OpenSSL::Cipher::AES.new(128, :CBC)
decipher.decrypt
decipher.key = key
decipher.iv = iv

plain = decipher.update(encrypted) + decipher.final

puts data == plain #=> true
