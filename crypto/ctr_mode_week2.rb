require "openssl"


def ctr_encrypt(plaintext, key, iv)
	ciphertexts = []

	cipher = OpenSSL::Cipher::AES.new(128, :CTR)

	blocks = plaintext.scan(/.{1,16}/)

	blocks.each do |block|
		cipher.reset
		cipher.encrypt
		cipher.key = key
		cipher.padding = 0

		cipher.iv = iv

		ciphertext = cipher.update(block) + cipher.final
		ciphertexts << ciphertext
		
		decimal_iv = iv.unpack('C*')
		decimal_iv[decimal_iv.length - 1] = decimal_iv[decimal_iv.length - 1] + 1

		iv = ""
		
		decimal_iv.each do |c|
			iv << c.chr
		end
	end

	return ciphertexts.join
end

def ctr_decrypt(data, key, iv)
	decipher = OpenSSL::Cipher::AES.new(128, :CTR)

	blocks = data.scan(/.{1,16}/)

	plain = ""

	blocks.each do |block|
		decipher.reset
		decipher.decrypt
		decipher.key = key
		decipher.iv = iv
		decipher.padding = 0

		deciphered_block = decipher.update(block) + decipher.final

		plain << deciphered_block

		decimal_iv = iv.unpack('C*')
		decimal_iv[decimal_iv.length - 1] = decimal_iv[decimal_iv.length - 1] + 1

		iv = ""
		
		decimal_iv.each do |c|
			iv << c.chr
		end
	end

	return plain
end


data1 = ctr_encrypt("CTR mode lets you build a stream cipher from a block cipher.",
	["36f18357be4dbd77f050515c73fcf9f2"].pack('H*'),
	["69dda8455c7dd4254bf353b773304eec"].pack('H*'))

data2 = ctr_encrypt("Always avoid the two time pad!",
	["36f18357be4dbd77f050515c73fcf9f2"].pack('H*'),
	["770b80259ec33beb2561358a9f2dc617"].pack('H*'))

puts ctr_decrypt(data1,
	["36f18357be4dbd77f050515c73fcf9f2"].pack('H*'),
	["69dda8455c7dd4254bf353b773304eec"].pack('H*'))

puts ctr_decrypt(data2,
	["36f18357be4dbd77f050515c73fcf9f2"].pack('H*'),
	["770b80259ec33beb2561358a9f2dc617"].pack('H*'))


