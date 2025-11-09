extends GdUnitTestSuite

var test_set: Set

func before_test() -> void:
    test_set = Set.new()
    
func after_test() -> void:
    test_set = null
    
func test_Add_and_to_array() -> void:
    test_set.add("apple")
    test_set.add("banana")

    assert_array(test_set.get_as_array()).contains("apple")
    assert_array(test_set.get_as_array()).contains("banana")
    assert_int(test_set.size()).is_equal(2)
    
func test_add_duplicate() -> void:
    test_set.add("apple")
    test_set.add("apple")

    assert_int(test_set.size()).is_equal(1)
    
func test_remove_existing() -> void:
    test_set.add("apple")
    test_set.remove("apple")

    assert_bool(test_set.is_empty()).is_true()
    
func test_remove_nonexistent() -> void:
    test_set.remove("ghost") # should not crash

    assert_bool(test_set.is_empty()).is_true()
    
func test_clear() -> void:
    test_set.add("apple")
    test_set.remove("banana")
    test_set.clear()

    assert_bool(test_set.is_empty()).is_true()

func test_add_all() -> void:
    test_set.add_all(["apple", "banana", "cherry"])

    assert_array(test_set.get_as_array()).contains("cherry")
    assert_int(test_set.size()).is_equal(3)
    
func test_union() -> void:
    test_set.add_all(["apple", "banana"])

    var other: Set = Set.new()

    other.add_all(["banana", "cherry"])

    var result: Set = test_set.union(other)

    assert_array(result.get_as_array()).contains("apple")
    assert_array(result.get_as_array()).contains("banana")
    assert_array(result.get_as_array()).contains("cherry")
    assert_int(result.size()).is_equal(3)
    
func test_intersection() -> void:
    test_set.add_all(["apple", "banana"])

    var other: Set = Set.new()

    other.add_all(["banana", "cherry"])

    var result: Set = test_set.intersection(other)

    assert_array(result.get_as_array()).contains("banana")
    assert_int(result.size()).is_equal(1)
    
func test_difference() -> void:
    test_set.add_all(["apple", "banana"])

    var other: Set = Set.new()

    other.add_all(["banana", "cherry"])

    var result: Set = test_set.difference(other)

    assert_array(result.get_as_array()).contains("apple")
    assert_int(result.size()).is_equal(1)
