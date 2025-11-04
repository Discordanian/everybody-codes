extends GdUnitTestSuite

var set: Set

func before_test() -> void:
    set = Set.new()
    
func after_test() -> void:
    set = null
    
func test_Add_and_to_array() -> void:
    set.add("apple")
    set.add("banana")

    assert_array(set.get_as_array()).contains("apple")
    assert_array(set.get_as_array()).contains("banana")
    assert_int(set.size()).is_equal(2)
    
func test_add_duplicate() -> void:
    set.add("apple")
    set.add("apple")

    assert_int(set.size()).is_equal(1)
    
func test_remove_existing() -> void:
    set.add("apple")
    set.remove("apple")

    assert_bool(set.is_empty()).is_true()
    
func test_remove_nonexistent() -> void:
    set.remove("ghost") # should not crash

    assert_bool(set.is_empty()).is_true()
    
func test_clear() -> void:
    set.add("apple")
    set.remove("banana")
    set.clear()

    assert_bool(set.is_empty()).is_true()

func test_add_all() -> void:
    set.add_all(["apple", "banana", "cherry"])

    assert_array(set.get_as_array()).contains("cherry")
    assert_int(set.size()).is_equal(3)
    
func test_union() -> void:
    set.add_all(["apple", "banana"])

    var other: Set = Set.new()

    other.add_all(["banana", "cherry"])

    var result: Set = set.union(other)

    assert_array(result.get_as_array()).contains("apple")
    assert_array(result.get_as_array()).contains("banana")
    assert_array(result.get_as_array()).contains("cherry")
    assert_int(result.size()).is_equal(3)
    
func test_intersection() -> void:
    set.add_all(["apple", "banana"])

    var other: Set = Set.new()

    other.add_all(["banana", "cherry"])

    var result: Set = set.intersection(other)

    assert_array(result.get_as_array()).contains("banana")
    assert_int(result.size()).is_equal(1)
    
func test_difference() -> void:
    set.add_all(["apple", "banana"])

    var other: Set = Set.new()

    other.add_all(["banana", "cherry"])

    var result: Set = set.difference(other)

    assert_array(result.get_as_array()).contains("apple")
    assert_int(result.size()).is_equal(1)
