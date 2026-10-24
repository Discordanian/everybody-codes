extends GdUnitTestSuite

# Test GCD (Greatest Common Divisor)
func test_gcd_basic() -> void:
	assert_int(AoCMath.gcd(12, 8)).is_equal(4)
	assert_int(AoCMath.gcd(48, 18)).is_equal(6)
	assert_int(AoCMath.gcd(100, 50)).is_equal(50)

func test_gcd_coprime() -> void:
	# Numbers with no common factors except 1
	assert_int(AoCMath.gcd(17, 19)).is_equal(1)
	assert_int(AoCMath.gcd(13, 7)).is_equal(1)

func test_gcd_same_number() -> void:
	assert_int(AoCMath.gcd(42, 42)).is_equal(42)
	assert_int(AoCMath.gcd(1, 1)).is_equal(1)

func test_gcd_with_zero() -> void:
	assert_int(AoCMath.gcd(0, 5)).is_equal(5)
	assert_int(AoCMath.gcd(7, 0)).is_equal(7)
	assert_int(AoCMath.gcd(0, 0)).is_equal(0)

func test_gcd_with_one() -> void:
	assert_int(AoCMath.gcd(1, 100)).is_equal(1)
	assert_int(AoCMath.gcd(53, 1)).is_equal(1)

func test_gcd_negative_numbers() -> void:
	assert_int(AoCMath.gcd(-12, 8)).is_equal(4)
	assert_int(AoCMath.gcd(12, -8)).is_equal(4)
	assert_int(AoCMath.gcd(-12, -8)).is_equal(4)

func test_gcd_large_numbers() -> void:
	assert_int(AoCMath.gcd(1071, 462)).is_equal(21)
	assert_int(AoCMath.gcd(270, 192)).is_equal(6)

func test_gcd_prime_numbers() -> void:
	assert_int(AoCMath.gcd(17, 23)).is_equal(1)
	assert_int(AoCMath.gcd(31, 37)).is_equal(1)

# Test LCM (Least Common Multiple)
func test_lcm_basic() -> void:
	assert_int(AoCMath.lcm(12, 8)).is_equal(24)
	assert_int(AoCMath.lcm(4, 6)).is_equal(12)
	assert_int(AoCMath.lcm(21, 6)).is_equal(42)

func test_lcm_coprime() -> void:
	# LCM of coprime numbers is their product
	assert_int(AoCMath.lcm(7, 13)).is_equal(91)
	assert_int(AoCMath.lcm(5, 11)).is_equal(55)

func test_lcm_same_number() -> void:
	assert_int(AoCMath.lcm(15, 15)).is_equal(15)
	assert_int(AoCMath.lcm(1, 1)).is_equal(1)

func test_lcm_with_one() -> void:
	assert_int(AoCMath.lcm(1, 50)).is_equal(50)
	assert_int(AoCMath.lcm(73, 1)).is_equal(73)

func test_lcm_multiple_relationship() -> void:
	# When one number is a multiple of another
	assert_int(AoCMath.lcm(5, 10)).is_equal(10)
	assert_int(AoCMath.lcm(3, 12)).is_equal(12)

func test_lcm_large_numbers() -> void:
	assert_int(AoCMath.lcm(24, 36)).is_equal(72)
	assert_int(AoCMath.lcm(15, 25)).is_equal(75)

# Test EGCD (Extended Euclidean Algorithm)
func test_egcd_basic() -> void:
	var result: Vector3i = AoCMath.egcd(30, 20)
	assert_int(result.x).is_equal(10)  # gcd
	# Verify Bézout's identity: 30*x + 20*y = 10
	assert_int(30 * result.y + 20 * result.z).is_equal(result.x)

func test_egcd_coprime() -> void:
	var result: Vector3i = AoCMath.egcd(17, 13)
	assert_int(result.x).is_equal(1)  # gcd should be 1
	# Verify Bézout's identity: 17*x + 13*y = 1
	assert_int(17 * result.y + 13 * result.z).is_equal(1)

func test_egcd_bezout_identity() -> void:
	# Test that a*x + b*y = gcd(a,b) holds
	var a: int = 240
	var b: int = 46
	var result: Vector3i = AoCMath.egcd(a, b)
	assert_int(a * result.y + b * result.z).is_equal(result.x)

func test_egcd_with_zero() -> void:
	var result: Vector3i = AoCMath.egcd(5, 0)
	assert_int(result.x).is_equal(5)
	assert_int(5 * result.y + 0 * result.z).is_equal(5)

func test_egcd_same_number() -> void:
	var result: Vector3i = AoCMath.egcd(42, 42)
	assert_int(result.x).is_equal(42)
	assert_int(42 * result.y + 42 * result.z).is_equal(42)

func test_egcd_various_pairs() -> void:
	var pairs: Array = [[35, 15], [100, 25], [48, 18]]
	for pair: Array in pairs:
		var result: Vector3i = AoCMath.egcd(pair[0], pair[1])
		assert_int(pair[0] * result.y + pair[1] * result.z).is_equal(result.x)

# Test mod_inv (Modular Multiplicative Inverse)
func test_mod_inv_basic() -> void:
	# 3 * 7 ≡ 1 (mod 10) [21 mod 10 = 1]
	var inv: int = AoCMath.mod_inv(3, 10)
	assert_int((3 * inv) % 10).is_equal(1)

func test_mod_inv_verification() -> void:
	# Test various coprime pairs
	var a: int = 7
	var m: int = 26
	var inv: int = AoCMath.mod_inv(a, m)
	assert_int((a * inv) % m).is_equal(1)

func test_mod_inv_small_modulus() -> void:
	var inv: int = AoCMath.mod_inv(2, 5)
	assert_int((2 * inv) % 5).is_equal(1)
	assert_int(inv).is_equal(3)  # 2 * 3 = 6 ≡ 1 (mod 5)

func test_mod_inv_large_numbers() -> void:
	var a: int = 15
	var m: int = 26
	var inv: int = AoCMath.mod_inv(a, m)
	assert_int((a * inv) % m).is_equal(1)

func test_mod_inv_result_positive() -> void:
	# Result should always be positive
	var inv: int = AoCMath.mod_inv(3, 7)
	assert_bool(inv >= 0).is_true()
	assert_bool(inv < 7).is_true()

func test_mod_inv_prime_modulus() -> void:
	# Every number 1 to p-1 has an inverse modulo prime p
	var p: int = 11
	for a: int in range(1, p):
		var inv: int = AoCMath.mod_inv(a, p)
		assert_int((a * inv) % p).is_equal(1)

# Test mod_pow (Modular Exponentiation)
func test_mod_pow_basic() -> void:
	# 2^10 mod 1000 = 1024 mod 1000 = 24
	assert_int(AoCMath.mod_pow(2, 10, 1000)).is_equal(24)

func test_mod_pow_small_exponent() -> void:
	assert_int(AoCMath.mod_pow(5, 2, 13)).is_equal(12)  # 25 mod 13 = 12
	assert_int(AoCMath.mod_pow(3, 3, 10)).is_equal(7)   # 27 mod 10 = 7

func test_mod_pow_zero_exponent() -> void:
	# Any number to the power of 0 is 1
	assert_int(AoCMath.mod_pow(123, 0, 1000)).is_equal(1)
	assert_int(AoCMath.mod_pow(5, 0, 7)).is_equal(1)

func test_mod_pow_one_exponent() -> void:
	assert_int(AoCMath.mod_pow(7, 1, 10)).is_equal(7)
	assert_int(AoCMath.mod_pow(15, 1, 11)).is_equal(4)  # 15 mod 11 = 4

func test_mod_pow_large_exponent() -> void:
	# 2^100 mod 1000000 (should handle large exponents efficiently)
	var result: int = AoCMath.mod_pow(2, 100, 1000000)
	assert_bool(result >= 0).is_true()
	assert_bool(result < 1000000).is_true()

func test_mod_pow_modulus_one() -> void:
	assert_int(AoCMath.mod_pow(5, 10, 1)).is_equal(0)

func test_mod_pow_base_larger_than_mod() -> void:
	assert_int(AoCMath.mod_pow(15, 3, 7)).is_equal(AoCMath.mod_pow(1, 3, 7))  # 15 ≡ 1 (mod 7)

func test_mod_pow_fermat_little_theorem() -> void:
	# For prime p and a not divisible by p: a^(p-1) ≡ 1 (mod p)
	var p: int = 13
	var a: int = 5
	assert_int(AoCMath.mod_pow(a, p - 1, p)).is_equal(1)

func test_mod_pow_various_cases() -> void:
	assert_int(AoCMath.mod_pow(3, 4, 5)).is_equal(1)    # 81 mod 5 = 1
	assert_int(AoCMath.mod_pow(7, 3, 11)).is_equal(2)   # 343 mod 11 = 2
	assert_int(AoCMath.mod_pow(10, 5, 13)).is_equal(4) # 100000 mod 13 = 4

# Test sieve (Sieve of Eratosthenes)
func test_sieve_small_range() -> void:
	var primes: PackedInt32Array = AoCMath.sieve(10)
	# Primes up to 10: 2, 3, 5, 7
	assert_int(primes[0]).is_equal(0)  # 0 is not prime
	assert_int(primes[1]).is_equal(0)  # 1 is not prime
	assert_int(primes[2]).is_equal(1)  # 2 is prime
	assert_int(primes[3]).is_equal(1)  # 3 is prime
	assert_int(primes[4]).is_equal(0)  # 4 is not prime
	assert_int(primes[5]).is_equal(1)  # 5 is prime
	assert_int(primes[6]).is_equal(0)  # 6 is not prime
	assert_int(primes[7]).is_equal(1)  # 7 is prime
	assert_int(primes[8]).is_equal(0)  # 8 is not prime
	assert_int(primes[9]).is_equal(0)  # 9 is not prime
	assert_int(primes[10]).is_equal(0) # 10 is not prime

func test_sieve_first_primes() -> void:
	var primes: PackedInt32Array = AoCMath.sieve(20)
	var expected_primes: Array = [2, 3, 5, 7, 11, 13, 17, 19]
	for p: int in expected_primes:
		assert_int(primes[p]).is_equal(1)

func test_sieve_composites() -> void:
	var primes: PackedInt32Array = AoCMath.sieve(20)
	var composites: Array = [4, 6, 8, 9, 10, 12, 14, 15, 16, 18, 20]
	for c: int in composites:
		assert_int(primes[c]).is_equal(0)

func test_sieve_zero_and_one() -> void:
	var primes: PackedInt32Array = AoCMath.sieve(5)
	assert_int(primes[0]).is_equal(0)
	assert_int(primes[1]).is_equal(0)

func test_sieve_size() -> void:
	var n: int = 30
	var primes: PackedInt32Array = AoCMath.sieve(n)
	assert_int(primes.size()).is_equal(n + 1)

func test_sieve_count_primes() -> void:
	var primes: PackedInt32Array = AoCMath.sieve(100)
	var count: int = 0
	for i: int in primes.size():
		if primes[i] == 1:
			count += 1
	# There are 25 primes less than or equal to 100
	assert_int(count).is_equal(25)

func test_sieve_very_small() -> void:
	var primes: PackedInt32Array = AoCMath.sieve(1)
	assert_int(primes[0]).is_equal(0)
	assert_int(primes[1]).is_equal(0)

func test_sieve_just_two() -> void:
	var primes: PackedInt32Array = AoCMath.sieve(2)
	assert_int(primes[2]).is_equal(1)

func test_sieve_larger_range() -> void:
	var primes: PackedInt32Array = AoCMath.sieve(50)
	# Check some known primes
	var known_primes: Array = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
	for p: int in known_primes:
		assert_int(primes[p]).is_equal(1)
    
	# Check some known composites
	var known_composites: Array = [4, 6, 8, 9, 10, 12, 14, 15, 16, 18, 20, 25, 30, 35, 40, 45, 50]
	for c: int in known_composites:
		assert_int(primes[c]).is_equal(0)

# Test mathematical properties and relationships
func test_gcd_lcm_relationship() -> void:
	# For any two numbers: a * b = gcd(a, b) * lcm(a, b)
	var a: int = 12
	var b: int = 18
	assert_int(a * b).is_equal(AoCMath.gcd(a, b) * AoCMath.lcm(a, b))

func test_mod_inv_with_mod_pow() -> void:
	# Using Fermat's little theorem: a^(p-1) ≡ 1 (mod p) for prime p
	# Therefore: a^(p-2) ≡ a^(-1) (mod p)
	var p: int = 17  # prime
	var a: int = 5
	var inv_direct: int = AoCMath.mod_inv(a, p)
	var inv_fermat: int = AoCMath.mod_pow(a, p - 2, p)
	assert_int(inv_direct).is_equal(inv_fermat)

func test_multiple_gcd_operations() -> void:
	# gcd(a, b, c) = gcd(gcd(a, b), c)
	var a: int = 24
	var b: int = 36
	var c: int = 60
	var gcd_ab: int = AoCMath.gcd(a, b)
	var gcd_abc: int = AoCMath.gcd(gcd_ab, c)
	assert_int(gcd_abc).is_equal(12)

func test_gcd_commutativity() -> void:
	# gcd(a, b) = gcd(b, a)
	assert_int(AoCMath.gcd(15, 25)).is_equal(AoCMath.gcd(25, 15))
	assert_int(AoCMath.gcd(48, 18)).is_equal(AoCMath.gcd(18, 48))

func test_lcm_commutativity() -> void:
	# lcm(a, b) = lcm(b, a)
	assert_int(AoCMath.lcm(6, 8)).is_equal(AoCMath.lcm(8, 6))
	assert_int(AoCMath.lcm(15, 20)).is_equal(AoCMath.lcm(20, 15))
