import sys
import gmpy2
from gmpy2 import mpz,mpq,mpfr,mpc

PRIME = 13407807929942597099574024998205846127479365820592393377723561443721764030073546976801874298166903427690031858186486050853753882811946569946433649006084171
GENERATOR = 11717829880366207009516117596335367088558084999998952205599979459063929499736583746670572176471460312928594829675428279466566527115212748467589894601965568
HVALUE = 3239475104050450443565264378728065788649097520952449527834792452971981976143292558073856937958553180532878928001494706097394108577585732452307673444020333

SEARCH_SPACE_EXPONENT = 20


class FindDiscreteLog:

    def create_left_side_hash(self):
        dict = {}
        search_space = pow(2, SEARCH_SPACE_EXPONENT)

        for i in range(1, search_space):
            left_side_value = gmpy2.f_mod( (HVALUE * gmpy2.powmod(GENERATOR, -i, PRIME)), PRIME)
            dict[left_side_value] = i

            if gmpy2.f_mod(i, 100000) == 0:
                print i

        return dict

    def check_right_side_against_hash(self, hashed_left_data):
        search_space = pow(2, SEARCH_SPACE_EXPONENT)

        for i in range(1, search_space):
            e = search_space * i
            right_side_result = gmpy2.powmod(GENERATOR, e, PRIME)

            if right_side_result in hashed_left_data:
                print("x1: ", i)
                print("x0: ", hashed_left_data[right_side_result])

                final_answer = gmpy2.f_mod(( (i * search_space) + hashed_left_data[right_side_result]), PRIME)
                print("x0 * B + x1 mod p: ", final_answer)

                print("Check final answer: ", gmpy2.powmod(GENERATOR, final_answer, PRIME))
                return

            if gmpy2.f_mod(i, 100000) == 0:
                print("Checked: ", i)


if __name__ == "__main__":
    discrete_log = FindDiscreteLog()
    test_values = discrete_log.create_left_side_hash()
    found_value = discrete_log.check_right_side_against_hash(test_values)



