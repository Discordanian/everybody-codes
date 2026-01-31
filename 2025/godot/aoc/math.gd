class_name AoCMath extends RefCounted

## Calculate the Euclidean remainder 
## @param a a%b
## @param b a
## @return will be positive value
static func euclidean_mod(a: int, b: int) -> int:
	var retval: int = a % b
	if retval < 0:
		retval += abs(b)
	return retval


## Calculate the Greatest Common Divisor (GCD) of two integers using Euclidean algorithm
## @param a: First integer (can be negative, will be made positive)
## @param b: Second integer (can be negative, will be made positive)
## @return: The greatest common divisor of a and b (always positive)
static func gcd(a: int, b: int) -> int:
	a = abs(a)
	b = abs(b)

	while b != 0:
		var t: int = b
		b = a % t
		a = t
	return a

## Calculate the Least Common Multiple (LCM) of two integers
## @param a: First integer
## @param b: Second integer
## @return: The least common multiple of a and b
static func lcm(a: int, b: int) -> int:
	@warning_ignore("integer_division")
	return a / gcd(a, b) * b

## Extended Euclidean Algorithm - finds GCD and Bézout coefficients
## Solves the equation: a*x + b*y = gcd(a,b)
## @param a: First integer
## @param b: Second integer
## @return: Vector3i(gcd, x, y) where gcd = a*x + b*y
static func egcd(a: int, b: int) -> Vector3i:
	# returns (g, x, y) with a*x + b*y = g
	var x0: int = 1
	var y0: int = 0
	var x1: int = 0
	var y1: int = 1
	var aa: int = a
	var bb: int = b

	while bb != 0:
		@warning_ignore("integer_division")
		var q: int = aa / bb
		var aa2: int = bb
		bb = aa - q * bb
		aa = aa2
		var x2: int = x0 - q * x1
		x0 = x1
		x1 = x2
		var y2: int = y0 - q * y1
		y0 = y1
		y1 = y2
	return Vector3i(aa, x0, y0)

## Calculate the modular multiplicative inverse of a modulo m
## Finds x such that (a * x) ≡ 1 (mod m)
## @param a: Integer to find the inverse of
## @param m: Modulus (must be coprime with a)
## @return: The modular inverse of a modulo m
## @precondition: gcd(a, m) must equal 1 (assertion will fail otherwise)
static func mod_inv(a: int, m: int) -> int:
	var r: Vector3i = egcd(a, m)

	assert(r.x == 1) # inverse exists

	var x: int = r.y % m

	if x < 0:
		x += m

	return x

## Calculate modular exponentiation: (base^exp) mod mod
## Uses binary exponentiation for efficient computation
## @param base: The base number
## @param exp: The exponent (must be non-negative)
## @param mod: The modulus
## @return: (base^exp) mod mod
static func mod_pow(base: int, exponent: int, mod: int) -> int:
	var b: int = base % mod
	var e: int = exponent
	var r: int = 1

	while e > 0:
		if (e & 1) == 1:
			r = int((r as int) * (b as int) % mod)

		b = int((b as int) * (b as int) % mod)
		e >>= 1
	return r

## Generate a sieve of Eratosthenes to find all prime numbers up to n
## @param n: The upper limit (inclusive) to check for primes
## @return: PackedInt32Array where index i is 1 if i is prime, 0 if composite
##          Note: 0 and 1 are marked as 0 (not prime) by definition
static func sieve(n: int) -> PackedInt32Array:
	var prime: PackedInt32Array = PackedInt32Array()

	prime.resize(n + 1)

	for i:int in n + 1:
		prime[i] = 1

	if n >= 0: prime[0] = 0
	if n >= 1: prime[1] = 0

	var p: int = 2

	while p * p <= n:
		if prime[p] == 1:
			var k: int = p * p
			while k <= n:
				prime[k] = 0
				k += p
		p += 1
	return prime
