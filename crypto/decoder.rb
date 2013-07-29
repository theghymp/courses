
input_codes = [87, 244, 86, 65]
input_string = 'ing '

input_codes.length.times do |i|
	puts input_codes[i] ^ input_string[i].unpack('c')[0]
end