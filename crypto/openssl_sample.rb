require "openssl"

data = "Very, very confidential data"

cipher = OpenSSL::Cipher::AES.new(128, :CTR)
cipher.encrypt
cipher.key = ["140b41b22a29beb4061bda66b6747e14"].pack('H*')
cipher.iv = ["4ca00ff4c898d61e1edbf1800618fb28"].pack('H*')

#puts "key: " + key.unpack('H*').to_s
#puts "iv: " + iv.unpack('H*').to_s


encrypted = cipher.update(data) + cipher.final

decipher = OpenSSL::Cipher::AES.new(128, :CBC)
decipher.decrypt
decipher.key = ["140b41b22a29beb4061bda66b6747e14"].pack('H*')
decipher.iv = ["4ca00ff4c898d61e1edbf1800618fb28"].pack('H*')

plain = decipher.update(encrypted) + decipher.final

puts data == plain #=> true