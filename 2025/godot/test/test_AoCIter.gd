extends GdUnitTestSuite

# Test combinations - basic cases
func test_combinations_basic() -> void:
    var result: Array[PackedInt32Array] = AoCIter.combinations(3, 2)
    # C(3,2) should give us: [0,1], [0,2], [1,2]
    assert_int(result.size()).is_equal(3)
    assert_array(Array(result[0])).is_equal([0, 1])
    assert_array(Array(result[1])).is_equal([0, 2])
    assert_array(Array(result[2])).is_equal([1, 2])

func test_combinations_choose_one() -> void:
    var result: Array[PackedInt32Array] = AoCIter.combinations(4, 1)
    # C(4,1) should give us: [0], [1], [2], [3]
    assert_int(result.size()).is_equal(4)
    assert_array(Array(result[0])).is_equal([0])
    assert_array(Array(result[1])).is_equal([1])
    assert_array(Array(result[2])).is_equal([2])
    assert_array(Array(result[3])).is_equal([3])

func test_combinations_choose_all() -> void:
    var result: Array[PackedInt32Array] = AoCIter.combinations(3, 3)
    # C(3,3) should give us just: [0,1,2]
    assert_int(result.size()).is_equal(1)
    assert_array(Array(result[0])).is_equal([0, 1, 2])

func test_combinations_choose_zero() -> void:
    var result: Array[PackedInt32Array] = AoCIter.combinations(5, 0)
    # C(5,0) should give us one empty combination
    assert_int(result.size()).is_equal(1)
    assert_int(result[0].size()).is_equal(0)

func test_combinations_empty_set() -> void:
    var result: Array[PackedInt32Array] = AoCIter.combinations(0, 0)
    # C(0,0) should give us one empty combination
    assert_int(result.size()).is_equal(1)
    assert_int(result[0].size()).is_equal(0)

func test_combinations_invalid_k_negative() -> void:
    var result: Array[PackedInt32Array] = AoCIter.combinations(5, -1)
    assert_array(result).is_empty()

func test_combinations_invalid_k_too_large() -> void:
    var result: Array[PackedInt32Array] = AoCIter.combinations(3, 5)
    assert_array(result).is_empty()

func test_combinations_size_formula() -> void:
    # C(n,k) = n! / (k! * (n-k)!)
    # C(5,2) = 10
    var result: Array[PackedInt32Array] = AoCIter.combinations(5, 2)
    assert_int(result.size()).is_equal(10)

func test_combinations_symmetry() -> void:
    # C(n,k) = C(n, n-k)
    var result1: Array[PackedInt32Array] = AoCIter.combinations(6, 2)
    var result2: Array[PackedInt32Array] = AoCIter.combinations(6, 4)
    assert_int(result1.size()).is_equal(result2.size())
    assert_int(result1.size()).is_equal(15)

func test_combinations_lexicographic_order() -> void:
    var result: Array[PackedInt32Array] = AoCIter.combinations(4, 2)
    # Should be in lexicographic order
    assert_array(Array(result[0])).is_equal([0, 1])
    assert_array(Array(result[1])).is_equal([0, 2])
    assert_array(Array(result[2])).is_equal([0, 3])
    assert_array(Array(result[3])).is_equal([1, 2])
    assert_array(Array(result[4])).is_equal([1, 3])
    assert_array(Array(result[5])).is_equal([2, 3])

func test_combinations_all_unique() -> void:
    var result: Array[PackedInt32Array] = AoCIter.combinations(4, 2)
    # Check that all combinations are unique
    for i: int in result.size():
        for j: int in range(i + 1, result.size()):
            assert_bool(Array(result[i]) == Array(result[j])).is_false()

func test_combinations_elements_in_range() -> void:
    var n: int = 5
    var k: int = 3
    var result: Array[PackedInt32Array] = AoCIter.combinations(n, k)
    # All elements should be in range [0, n-1]
    for combo: PackedInt32Array in result:
        for element: int in combo:
            assert_bool(element >= 0 and element < n).is_true()

func test_combinations_sorted_elements() -> void:
    var result: Array[PackedInt32Array] = AoCIter.combinations(5, 3)
    # Each combination should have elements in ascending order
    for combo: PackedInt32Array in result:
        for i: int in range(combo.size() - 1):
            assert_bool(combo[i] < combo[i + 1]).is_true()

func test_combinations_larger_set() -> void:
    # C(7,3) = 35
    var result: Array[PackedInt32Array] = AoCIter.combinations(7, 3)
    assert_int(result.size()).is_equal(35)

# Test next_permutation - basic cases
func test_next_permutation_basic() -> void:
    var arr: Array[int] = [1, 2, 3]
    var success: bool = AoCIter.next_permutation(arr)
    assert_bool(success).is_true()
    assert_array(arr).is_equal([1, 3, 2])

func test_next_permutation_multiple_calls() -> void:
    var arr: Array[int] = [1, 2, 3]
    AoCIter.next_permutation(arr)
    assert_array(arr).is_equal([1, 3, 2])
    AoCIter.next_permutation(arr)
    assert_array(arr).is_equal([2, 1, 3])
    AoCIter.next_permutation(arr)
    assert_array(arr).is_equal([2, 3, 1])
    AoCIter.next_permutation(arr)
    assert_array(arr).is_equal([3, 1, 2])
    AoCIter.next_permutation(arr)
    assert_array(arr).is_equal([3, 2, 1])

func test_next_permutation_last_permutation() -> void:
    var arr: Array[int] = [3, 2, 1]
    var success: bool = AoCIter.next_permutation(arr)
    assert_bool(success).is_false()
    # Array should remain in last permutation state
    assert_array(arr).is_equal([3, 2, 1])

func test_next_permutation_two_elements() -> void:
    var arr: Array[int] = [1, 2]
    assert_bool(AoCIter.next_permutation(arr)).is_true()
    assert_array(arr).is_equal([2, 1])
    assert_bool(AoCIter.next_permutation(arr)).is_false()
    assert_array(arr).is_equal([2, 1])

func test_next_permutation_single_element() -> void:
    var arr: Array[int] = [1]
    var success: bool = AoCIter.next_permutation(arr)
    assert_bool(success).is_false()
    assert_array(arr).is_equal([1])

func test_next_permutation_empty_array() -> void:
    var arr: Array[int] = []
    var success: bool = AoCIter.next_permutation(arr)
    assert_bool(success).is_false()

func test_next_permutation_all_permutations() -> void:
    # Generate all permutations of [1, 2, 3]
    var arr: Array[int] = [1, 2, 3]
    var perms: Array = []
    perms.append(arr.duplicate())
    
    while AoCIter.next_permutation(arr):
        perms.append(arr.duplicate())
    
    # Should have 3! = 6 permutations
    assert_int(perms.size()).is_equal(6)
    
    # Verify all expected permutations
    assert_array(perms[0]).is_equal([1, 2, 3])
    assert_array(perms[1]).is_equal([1, 3, 2])
    assert_array(perms[2]).is_equal([2, 1, 3])
    assert_array(perms[3]).is_equal([2, 3, 1])
    assert_array(perms[4]).is_equal([3, 1, 2])
    assert_array(perms[5]).is_equal([3, 2, 1])

func test_next_permutation_with_duplicates() -> void:
    # Note: next_permutation works with duplicates
    var arr: Array[int] = [1, 1, 2]
    var perms: Array = []
    perms.append(arr.duplicate())
    
    while AoCIter.next_permutation(arr):
        perms.append(arr.duplicate())
    
    # Should have fewer unique permutations due to duplicates
    assert_int(perms.size()).is_equal(3)
    assert_array(perms[0]).is_equal([1, 1, 2])
    assert_array(perms[1]).is_equal([1, 2, 1])
    assert_array(perms[2]).is_equal([2, 1, 1])

func test_next_permutation_larger_array() -> void:
    var arr: Array[int] = [1, 2, 3, 4]
    var count: int = 1  # Count initial permutation
    
    while AoCIter.next_permutation(arr):
        count += 1
    
    # Should have 4! = 24 permutations
    assert_int(count).is_equal(24)

func test_next_permutation_non_sequential() -> void:
    var arr: Array[int] = [1, 3, 5]
    assert_bool(AoCIter.next_permutation(arr)).is_true()
    assert_array(arr).is_equal([1, 5, 3])
    assert_bool(AoCIter.next_permutation(arr)).is_true()
    assert_array(arr).is_equal([3, 1, 5])

func test_next_permutation_negative_numbers() -> void:
    var arr: Array[int] = [-1, 0, 1]
    var perms: Array = []
    perms.append(arr.duplicate())
    
    while AoCIter.next_permutation(arr):
        perms.append(arr.duplicate())
    
    assert_int(perms.size()).is_equal(6)

func test_next_permutation_descending_order() -> void:
    # Already in last permutation
    var arr: Array[int] = [5, 4, 3, 2, 1]
    assert_bool(AoCIter.next_permutation(arr)).is_false()
    assert_array(arr).is_equal([5, 4, 3, 2, 1])

func test_next_permutation_ascending_order() -> void:
    # In first permutation
    var arr: Array[int] = [1, 2, 3, 4, 5]
    assert_bool(AoCIter.next_permutation(arr)).is_true()
    assert_array(arr).is_equal([1, 2, 3, 5, 4])

func test_next_permutation_partially_sorted() -> void:
    var arr: Array[int] = [1, 4, 3, 2]
    assert_bool(AoCIter.next_permutation(arr)).is_true()
    assert_array(arr).is_equal([2, 1, 3, 4])

# Test combinations and permutations relationship
func test_combinations_permutations_count() -> void:
    # For n=4, k=2: C(4,2) = 6 combinations
    # Each combination has 2! = 2 permutations
    var combos: Array[PackedInt32Array] = AoCIter.combinations(4, 2)
    assert_int(combos.size()).is_equal(6)
    
    # Each combination of size k has k! permutations
    # So total permutations P(4,2) = C(4,2) * 2! = 6 * 2 = 12

func test_combinations_not_modified() -> void:
    # Ensure combinations doesn't modify internal state between calls
    var result1: Array[PackedInt32Array] = AoCIter.combinations(4, 2)
    var result2: Array[PackedInt32Array] = AoCIter.combinations(4, 2)
    assert_int(result1.size()).is_equal(result2.size())
    for i: int in result1.size():
        assert_array(Array(result1[i])).is_equal(Array(result2[i]))

func test_next_permutation_idempotent_on_failure() -> void:
    # Multiple calls on last permutation should not change array
    var arr: Array[int] = [3, 2, 1]
    AoCIter.next_permutation(arr)
    var after_first: Array[int] = arr.duplicate()
    AoCIter.next_permutation(arr)
    assert_array(arr).is_equal(after_first)

func test_combinations_edge_case_n_equals_k() -> void:
    for n: int in range(1, 6):
        var result: Array[PackedInt32Array] = AoCIter.combinations(n, n)
        assert_int(result.size()).is_equal(1)
        assert_int(result[0].size()).is_equal(n)

func test_next_permutation_lexicographic_order() -> void:
    # Next permutation should always produce lexicographically next sequence
    var arr1: Array[int] = [1, 2, 3]
    var arr2: Array[int] = [1, 2, 3]
    
    AoCIter.next_permutation(arr2)
    
    # arr2 should be lexicographically greater than arr1
    var is_greater: bool = false
    for i: int in arr1.size():
        if arr2[i] > arr1[i]:
            is_greater = true
            break
        elif arr2[i] < arr1[i]:
            break
    assert_bool(is_greater).is_true()

func test_combinations_binomial_coefficient() -> void:
    # Test various binomial coefficients
    assert_int(AoCIter.combinations(5, 0).size()).is_equal(1)   # C(5,0) = 1
    assert_int(AoCIter.combinations(5, 1).size()).is_equal(5)   # C(5,1) = 5
    assert_int(AoCIter.combinations(5, 2).size()).is_equal(10)  # C(5,2) = 10
    assert_int(AoCIter.combinations(5, 3).size()).is_equal(10)  # C(5,3) = 10
    assert_int(AoCIter.combinations(5, 4).size()).is_equal(5)   # C(5,4) = 5
    assert_int(AoCIter.combinations(5, 5).size()).is_equal(1)   # C(5,5) = 1

func test_next_permutation_four_elements_sequence() -> void:
    var arr: Array[int] = [0, 1, 2, 3]
    var expected_second: Array[int] = [0, 1, 3, 2]
    
    AoCIter.next_permutation(arr)
    assert_array(arr).is_equal(expected_second)
