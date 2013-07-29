import sys
import gmpy2
import math
from gmpy2 import mpz,mpq,mpfr,mpc

#Challenge #1
N1 = mpz(179769313486231590772930519078902473361797697894230657273430081157732675805505620686985379449212982959585501387537164015710139858647833778606925583497541085196591615128057575940752635007475935288710823649949940771895617054361149474865046711015101563940680527540071584560878577663743040086340742855278549092581)

#Challenge #2
N2 = mpz(648455842808071669662824265346772278726343720706976263060439070378797308618081116462714015276061417569195587321840254520655424906719892428844841839353281972988531310511738648965962582821502504990264452100885281673303711142296421027840289307657458645233683357077834689715838646088239640236866252211790085787877)

N3 = mpz(720062263747350425279564435525583738338084451473999841826653057981916355690188337790423408664187663938485175264994017897083524079135686877441155132015188279331812309091996246361896836573643119174094961348524639707885238799396839230364676670221627018353299443241192173812729276147530748597302192751375739387929)

#Challenge #4
N4 = mpz(179769313486231590772930519078902473361797697894230657273430081157732675805505620686985379449212982959585501387537164015710139858647833778606925583497541085196591615128057575940752635007475935288710823649949940771895617054361149474865046711015101563940680527540071584560878577663743040086340742855278549092581)
ENCRYPTION_EXP = 65537
CIPHERTEXT = mpz(22096451867410381776306561134883418017410069787892831071731839143676135600120538004282329650473509424343946219751512256465839967942889460764542040581564748988013734864120452325229320176487916666402997509188729971690526083222067771600019329260870009579993724077458967773697817571267229951148662959627934791540)

class FactorFactory:

    def find_factors3(self, N):
        A = gmpy2.isqrt(6 * N) * 2
        print("Origi A: ", A)

        x = gmpy2.div(A, 5)
        p = gmpy2.mul(x, 2)
        q = gmpy2.mul(x, 3)

        print("x: ", x)        
        print("p: ", p)
        print("q: ", q)

        product = gmpy2.mul(p, q)
        difference = gmpy2.sub(product, N)
        if difference == 0:
            print("Found A: ", A)
            print("p: ", p)
            print("q: ", q)
        print("product: ", product)
        print("difference: ", difference)


    def find_factors2(self, N):
        A = gmpy2.isqrt(N) + 1
        print("Origi A: ", A)

        upper_bound_a = A + (2 ** 20)

        while A < upper_bound_a:

            x = gmpy2.isqrt((A * A) - N)
            p = gmpy2.sub(A, x)
            q = gmpy2.add(A, x)

            product = gmpy2.mul(p, q)
            difference = gmpy2.sub(product, N)
            if difference == 0:
                print("Found A: ", A)
                print("p: ", p)
                print("q: ", q)
                print("product: ", product)
                print("difference: ", difference)
            A = A + 1


    def find_factors1(self, N):
        A = gmpy2.isqrt(N) + 1

        x = gmpy2.isqrt((A * A) - N)
        p = gmpy2.sub(A, x)
        q = gmpy2.add(A, x)

        product = gmpy2.mul(p, q)
        difference = gmpy2.sub(product, N)
        print("p: ", p)
        print("q: ", q)

        phi_n = N - p - q + 1
        print("phi_n: ", phi_n)

        decryption_exp = gmpy2.invert(ENCRYPTION_EXP, phi_n)
        print("decryption_exp: ", decryption_exp)
        #print("inversion_check: ", gmpy2.f_mod(    mpz(  gmpy2.mul(ENCRYPTION_EXP, decryption_exp)  ),    mpz(phi_n)    ))

        plaintext = gmpy2.powmod(CIPHERTEXT, decryption_exp, N)
        print("plaintext: ", plaintext)

        return plaintext

        #plaintext_bin = bin(plaintext)
        #print("plaintext_bin: ", plaintext_bin)

        #print("product: ", product)
        #print("difference: ", difference)

    def convert(self, int_value):
       encoded = format(int_value, 'x')

       length = len(encoded)
       encoded = encoded.zfill(length+length%2)

       return encoded.decode('hex')


        
if __name__ == "__main__":
    factory = FactorFactory()
    #factors = factory.find_factors2(N2)
    #plaintext = factory.find_factors1(N1)
    #plaintext_hex = factory.convert(plaintext)
    #print("plaintext_hex: ", plaintext_hex)
    factors = factory.find_factors3(N3)



