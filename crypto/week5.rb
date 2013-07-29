require 'openssl'

PRIME = 13407807929942597099574024998205846127479365820592393377723561443721764030073546976801874298166903427690031858186486050853753882811946569946433649006084171
GENERATOR = 11717829880366207009516117596335367088558084999998952205599979459063929499736583746670572176471460312928594829675428279466566527115212748467589894601965568
HVALUE = 3239475104050450443565264378728065788649097520952449527834792452971981976143292558073856937958553180532878928001494706097394108577585732452307673444020333

search_space = 2**20


class Integer
  def rosetta_mod_exp(exp, mod)
    exp < 0 and raise ArgumentError, "negative exponent"
    prod = 1
    base = self % mod
    until exp.zero?
      exp.odd? and prod = (prod * base) % mod
      exp >>= 1
      base = (base * base) % mod
    end
    prod
  end
end


#based on pseudo code from http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Iterative_method_2 and from translating the python implementation.
def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0
  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient*x, x
    y, last_y = last_y - quotient*y, y
  end
 
  return last_remainder, last_x * (a < 0 ? -1 : 1)
end
 

def invmod(e, et)
  g, x = extended_gcd(e, et)
  if g != 1
    raise 'Teh maths are broken!'
  end
  x % et
end



def create_left_side_hash(search_space)
	left_side_hash = {}
	massive_number = 2**128

	for i in 1..search_space
		left_side_hash[(HVALUE * invmod(GENERATOR.rosetta_mod_exp(i, massive_number), PRIME)) % PRIME] = i
		if i % 10000 == 0
			puts i
		end
	end
	return left_side_hash
end

def check_right_side_against_hash(hashed_left_data, search_space)
	for i in 1..search_space
		right_side_result = GENERATOR.rosetta_mod_exp((search_space*i), PRIME)
		if hashed_left_data[right_side_result] != nil
			puts "Found the result: " + i.to_s
		end
		if i % 10000 == 0
			puts "Checked: " + i.to_s
		end
	end
end

hashed_left_data = create_left_side_hash(search_space)
check_right_side_against_hash(hashed_left_data, search_space)



