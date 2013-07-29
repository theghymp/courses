require 'net/http'



TARGET = 'http://crypto-class.appspot.com/po?er='

def query

	decode_block = 'bdf302936266926ff37dbf7035d5eeb4'
	parameter = 'f20bdba6ff29eed7b046d1df9fb7000058b1ffb4210a580f748b4ac714c001bd4a61044426fb515dad3f21f18aa577c0'
	message = " " * 48
	padding_string = ""

	adjusted_byte_number = parameter.length - 2

	uri = URI.parse(TARGET)

	Net::HTTP.start(uri.host, uri.port) do |http|

		(0..31).each do |index|
			is_correct_guess = false
			guess = 0
			while is_correct_guess == false && guess < 256

				i = guess ^ (index + 1)

				test_hex_code = i.to_s(16)

				if test_hex_code.length == 2
					parameter[adjusted_byte_number] = i.to_s(16)[0]
					parameter[adjusted_byte_number + 1] = i.to_s(16)[1]
				else
					parameter[adjusted_byte_number] = '0'
					parameter[adjusted_byte_number + 1] = i.to_s(16)[0]
				end

				padding_string.length.times do |pad_index|
					parameter[adjusted_byte_number + 2 + pad_index] = padding_string[pad_index]
				end

				uri = TARGET + parameter
				request = Net::HTTP::Get.new(uri)
				resp = http.request(request)

				puts resp.code + " " + uri + " " + parameter[adjusted_byte_number, 2] + " " + padding_string
				
				if resp.code == "404" #|| (resp.code == "200" && index > 0)
					
					decode_block_characters = decode_block.scan(/../)
					decode_block_character = decode_block_characters[decode_block_characters.length - index - 1].to_s

					puts "Last byte (decimal): " + decode_block_character.to_i(16).to_s
					puts "Guess: " + guess.to_s
					puts "Padding: " + (index + 1).to_s

					message[47 - index] = (guess ^ decode_block_character.to_i(16) ^ (index + 1)).chr
					puts "Guess XOR last-byte XOR padding (decimal): " + (guess ^ decode_block_character.to_i(16) ^ (index + 1)).to_s
					puts "Guess XOR last-byte XOR padding (character): " + message[47 - index]

					puts 'message: ' + message

					padding_string = increment_padding_string(parameter[adjusted_byte_number, 2], padding_string)
					puts "Padding String: " + padding_string
					is_correct_guess = true
				end

				guess = guess + 1
			end

			adjusted_byte_number = adjusted_byte_number - 2

			puts "\n\n"
		end
	end
end

def increment_padding_string(new_padding_byte, padding_string)

	incremented_padding = ""

	padding_bytes = padding_string.scan(/../)

	if padding_bytes.length > 0
		padding_bytes.each do |byte|
			incremented_byte = byte.to_i(16) ^ (padding_bytes.length + 1) ^ (padding_bytes.length + 2)
			incremented_padding << incremented_byte.to_s(16)
			# need to make sure I get the leading zeros in case that's necessary
		end
	end

	# need to figure out what number the new padding byte should be xor'ed with
	puts "New padding byte: " + new_padding_byte.to_s
	puts "New padding byte decimal: " + new_padding_byte.to_i(16).to_s
	puts "Padding bytes length: " + padding_bytes.length.to_s
	puts "New byte: " + (new_padding_byte.to_i(16) ^ (padding_bytes.length + 1) ^ (padding_bytes.length + 2)).to_s(16)


	updated_new_padding_byte = (new_padding_byte.to_i(16) ^ (padding_bytes.length + 1) ^ (padding_bytes.length + 2))
	
	zero_spacer = ''
	if updated_new_padding_byte < 10
		zero_spacer = '0'
	end

	incremented_padding = zero_spacer + updated_new_padding_byte.to_s(16) + incremented_padding
end

query