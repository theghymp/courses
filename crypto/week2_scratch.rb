require "openssl"

# Encryption
# Split the message up into IV, 16 byte chunks and add padding

puts OpenSSL::Cipher.ciphers

cipher = OpenSSL::Cipher::AES.new(128, :CBC)

plaintext = "Basic CBC mode encryption needs padding."

#binary_plaintext = plaintext.unpack('C*').map { |x| sprintf("%.8b", x)}

num_blocks = (plaintext.length / 16) + 1

#puts "Binary plaintext: " + binary_plaintext.to_s
#puts "Plaintext length: " + binary_plaintext.length.to_s
puts "Number of blocks: " + num_blocks.to_s

ciphertexts = []

num_blocks.times do |i|
	cipher.reset
	cipher.encrypt
	if i < 2
		cipher.padding = 0
	else
		cipher.padding = 8
	end

	puts "Block size: " + cipher.block_size.to_s

	cipher.key = ["140b41b22a29beb4061bda66b6747e14"].pack('H*')

	start_index = 0
	if i > 0
		start_index = i * 16
		cipher.iv = ciphertexts[i-1]
	else
		cipher.iv = ["4ca00ff4c898d61e1edbf1800618fb28"].pack('H*')
	end

	end_index = ((i + 1) * 16) - 1

	block = plaintext[start_index..end_index]
	puts "Block: " + block.to_s
	puts "Block length: " + block.length.to_s
	
	ciphertexts[i] = cipher.update(block) + cipher.final

	puts "ciphertexts #{i}: " + ciphertexts[i]
	puts "ciphertexts #{i} hex: " + ciphertexts[i].unpack('H*').to_s

	puts ""


	#block_items = binary_plaintext[start_index..end_index]
	#What format does the AES encryption require

	#block_items.each do |c|
	#	puts c + " " + c.to_i(2).to_s + " " + c.to_i(2).chr
	#end
end

puts "Ciphertexts: " + ciphertexts.join().unpack('H*').to_s


#puts "Hex plaintext first 16 bytes: " + first_bytes.unpack('C*')
#puts "First 16 plaintext bytes: " + "Basic CBC mode e".unpack('U*')


puts "Original data: " + ["28a226d160dad07883d04e008a7897ee2e4b7465d5290d0c0e6c6822236e1daafb94ffe0c5da05d9476be028ad7c1d81"].pack('H*')
data = ciphertexts.join()

iv = ["4ca00ff4c898d61e1edbf1800618fb28"].pack('H*')
key = ["140b41b22a29beb4061bda66b6747e14"].pack('H*')

puts "key: " + key.to_s
puts "iv: " + iv.to_s
puts "data: " + data

decipher = OpenSSL::Cipher::AES.new(128, :CBC)
decipher.decrypt
decipher.key = key
decipher.iv = iv

plain = decipher.update(data) + decipher.final

puts plain



5b68629feb8606f9a6667670b75b38a5

b4832d0f26e1ab7da33249de7d4afc48e713ac646ace36e872ad5fb8a512428a6e21364b0c374df45503473c5242a253




require "openssl"

def ctr_decrypt(data, key, iv)
	decipher = OpenSSL::Cipher::AES.new(128, :OFB)

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


		#puts "New IV: " + iv.unpack('H*').to_s
		decimal_iv = iv.unpack('C*')

		#puts [decimal_iv].to_s
		decimal_iv[decimal_iv.length - 1] = decimal_iv[decimal_iv.length - 1] + 1
		#puts ""
		#puts [decimal_iv].to_s


		#incremented_iv = decimal_iv.map { |i| i.to_s(16)}
		#puts "Incremented IV hex array: " + incremented_iv.to_s
		#incremented_iv = incremented_iv.join


		#puts "Incremented IV: " + incremented_iv.to_s

		result_string = ""
		
		decimal_iv.each do |c|
			result_string << c.chr
		end

		iv = result_string
		
		puts "Old IV: " + iv.unpack('H*').to_s

		puts ""
	end

	return plain
end


puts ctr_decrypt(["0ec7702330098ce7f7520d1cbbb20fc388d1b0adb5054dbd7370849dbf0b88d393f252e764f1f5f7ad97ef79d59ce29f5f51eeca32eabedd9afa9329"].pack('H*'),
	["36f18357be4dbd77f050515c73fcf9f2"].pack('H*'),
	["69dda8455c7dd4254bf353b773304eec"].pack('H*'))

puts ctr_decrypt(["e46218c0a53cbeca695ae45faa8952aa0e311bde9d4e01726d3184c34451"].pack('H*'),
	["36f18357be4dbd77f050515c73fcf9f2"].pack('H*'),
	["770b80259ec33beb2561358a9f2dc617"].pack('H*'))