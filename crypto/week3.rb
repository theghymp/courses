require 'digest/sha2'

BLOCK_SIZE = 1024

File.open("cryptolecture.mp4") do |f|
	file_size = f.size

	num_blocks = (file_size / 1024) + 1

	block_num = 1
	last_block_size = file_size % 1024

	index = last_block_size
	h = nil
	bits_remaining = 0



	while block_num < num_blocks + 1
		puts "Block number: " + block_num.to_s + "-"
		puts "File size: " + file_size.to_s

		puts "Index: " + index.to_s
		f.seek(-index, IO::SEEK_END)

		if block_num == 1
			block = f.read(last_block_size)
		else
			block = f.read(1024)
		end

		puts "Block size: " + block.size.to_s

		unless h.nil?
			binary_hash = [h.to_s].pack('H*')
			block << binary_hash
		end

		puts "Adjusted block size: " + block.size.to_s

		h = Digest::SHA256.new << block
		puts "Hash: " + h.to_s
		puts "Number of blocks: " + num_blocks.to_s
		puts "Index: " + index.to_s

		bits_remaining = file_size - index
		puts "Bits remaining: " + bits_remaining.to_s
		index = (block_num * BLOCK_SIZE) + last_block_size
		block_num = block_num + 1
	end

end



