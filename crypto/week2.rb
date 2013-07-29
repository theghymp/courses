require "openssl"


def add_padding(partial_block)
	required_padding = 16 - partial_block.length

	required_padding.times do |t|
		partial_block << required_padding
	end
	return partial_block
end

def cbc_encrypt(plaintext, key, iv)
	ciphertexts = []

	cipher = OpenSSL::Cipher::AES.new(128, :CBC)

	blocks = plaintext.scan(/.{1,16}/)

	blocks.each do |block|
		cipher.reset
		cipher.encrypt
		cipher.key = key
		cipher.padding = 0

		cipher.iv = iv

		if block.length < 16
			block = add_padding(block)
		end

		ciphertext = cipher.update(block) + cipher.final
		iv = ciphertext

		ciphertexts << ciphertext
	end

	return ciphertexts.join
end


def cbc_decrypt(data, key, iv)
	decipher = OpenSSL::Cipher::AES.new(128, :CBC)

	blocks = data.scan(/.{1,16}/)

	plain = ""

	blocks.each do |block|
		decipher.reset
		decipher.decrypt
		decipher.key = key
		decipher.iv = iv
		decipher.padding = 0

		deciphered_block = decipher.update(block) + decipher.final

		# Remove padding
		if deciphered_block[15].ord < 17
			deciphered_block = deciphered_block[0..(15 - deciphered_block[15].ord)]
		end

		plain << deciphered_block
		iv = block
	end

	return plain
end


data1 = cbc_encrypt("Basic CBC mode encryption needs padding.", 
	["140b41b22a29beb4061bda66b6747e14"].pack('H*'), 
	["4ca00ff4c898d61e1edbf1800618fb28"].pack('H*'))

puts cbc_decrypt(data1, 
	["140b41b22a29beb4061bda66b6747e14"].pack('H*'), 
	["4ca00ff4c898d61e1edbf1800618fb28"].pack('H*'))

data2 = cbc_encrypt("Our implementation uses rand. IV",
	["140b41b22a29beb4061bda66b6747e14"].pack('H*'),
	["5b68629feb8606f9a6667670b75b38a5"].pack('H*'))

puts cbc_decrypt(data2,
	["140b41b22a29beb4061bda66b6747e14"].pack('H*'),
	["5b68629feb8606f9a6667670b75b38a5"].pack('H*'))




