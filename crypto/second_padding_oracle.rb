require 'net/http'

SERVER_URL = 'http://crypto-class.appspot.com/po?er='
PADDING_ERROR_CODE = "403"
PADDING_GOOD_CIPHERTEXT_ERROR = "404"
BLOCK_OFFSET = 32

# To do - figure out how to add padding - where should the padding variable be stored? Hash?
# What needs to be stored in the padding variable? 
# Figure out if I should be using the entire query string or just a piece of it.



def decode_block(ciphertext, block_number=nil)
	decoded_message_codes = ''
	decoded_message = ''
	padding_array = []

	(0..15).each do |index|
		decoded_character = decode_message_character(ciphertext, index, padding_array)
		decoded_message_codes = decoded_character.to_s + " " + decoded_message_codes
		decoded_message = decoded_character.chr + decoded_message

		puts "Decoded message codes: " + decoded_message_codes
		puts "Decoded message: " + decoded_message
	end
end


def decode_message_character(ciphertext, index, padding_array)

	byte_to_decode = ciphertext[-(BLOCK_OFFSET + 2) - (index * 2), 2]
	puts "byte_to_decode: " + byte_to_decode

	padding_string = ''

	padding_array.each do |byte|
		padding_string = int_to_str_hex_code(byte ^ (index + 1)) + padding_string
	end

	raw_decoded_byte = decode_next_byte(ciphertext, index, padding_string)
	puts "raw_decoded_byte: " + raw_decoded_byte.to_s

	padding_array[index] = raw_decoded_byte ^ (index + 1)

	decoded_byte = padding_array[index] ^ byte_to_decode.to_i(16)

	return decoded_byte
end


def decode_next_byte(ciphertext, index, padding_string)
	base_uri = URI.parse(SERVER_URL)
	is_correct_guess = false
	query_ciphertext = ciphertext
	guess = 0

	ciphertext = insert_padding_string(ciphertext, index, padding_string)

	Net::HTTP.start(base_uri.host, base_uri.port) do |http|

		while is_correct_guess == false && guess < 256

			query_ciphertext = increment_query_ciphertext(query_ciphertext, guess, index)
			query_response = submit_query(http, query_ciphertext)

			puts query_response + " " + query_ciphertext + " " + 
				int_to_str_hex_code(guess) + " " + padding_string

			if query_response == PADDING_GOOD_CIPHERTEXT_ERROR
				is_correct_guess = true		
			end

			if query_response == "200" && index > 1
				is_correct_guess = true
			end
			guess = guess + 1
		end
	end	

	return guess - 1
end

def insert_padding_string(ciphertext, index, padding_string)

	i = 0
	padding_string.each_char do |char|
		ciphertext[ciphertext.length - (BLOCK_OFFSET + padding_string.length) + i] = padding_string[i]
		i = i + 1
	end

	return ciphertext
end


def increment_query_ciphertext(query_ciphertext, guess, index)

	query_ciphertext[query_ciphertext.length - ((BLOCK_OFFSET + 2) + (index * 2))] = int_to_str_hex_code(guess)[0]
	query_ciphertext[query_ciphertext.length - ((BLOCK_OFFSET + 1) + (index * 2))] = int_to_str_hex_code(guess)[1]

	return query_ciphertext

end

def submit_query(http, query)
	uri = SERVER_URL + query
	request = Net::HTTP::Get.new(uri)
	resp = http.request(request)
	return resp.code
end

def get_pad_string(index)

end


def int_to_str_hex_code(int)
	return sprintf("%02x", int)
end

# decode first block
decode_block('f20bdba6ff29eed7b046d1df9fb7000058b1ffb4210a580f748b4ac714c001bd')

# decode second block
#decode_block('f20bdba6ff29eed7b046d1df9fb7000058b1ffb4210a580f748b4ac714c001bd4a61044426fb515dad3f21f18aa577c0')

# decode third block
#decode_block('f20bdba6ff29eed7b046d1df9fb7000058b1ffb4210a580f748b4ac714c001bd4a61044426fb515dad3f21f18aa577c0bdf302936266926ff37dbf7035d5eeb4')

