extends GdUnitTestSuite

# Initial test script as I learn GDUnit4

func test_foo() -> void:
    var a: int = 5
    var b: int = 10
    var result: int = min(a,b)
    
    assert_int(result).is_equal(a)
    

func test_int() -> void:
    var test: int = 23
    var expected: int = 23
    var small: int = -123
    var big: int = 123
    assert_int(test).is_equal(expected)
    assert_int(small).is_less(big)
    assert_int(big).is_greater(small)
    assert_int(big).is_greater_equal(small)
    assert_int(big).is_odd()
    assert_int(test).is_not_null()


func test_float() -> void:
    var test: float = 23.5
    var expected: float = 23.5
    var zero: float = 0.0
    assert_float(test).is_equal(expected)
    assert_float(zero).is_zero()
    assert_float(zero).is_less(test)
    assert_float(zero).is_not_null()


func test_bool() -> void:
    var test: bool = false
    var expected: bool = false
    assert_bool(test).is_equal(expected)
    assert_bool(test).is_false()
    assert_bool(not test).is_true()
    assert_bool(not test).is_not_equal(test)


func test_str() -> void:
    var test: String = "Kurt Schwind"
    var expected: String = "Kurt Schwind"
    var caps: String = "KURT SCHWIND"
    assert_str(test).is_equal(expected)
    assert_str(test).is_equal_ignoring_case(caps)
    assert_str(test).is_not_empty()
    assert_str(test).starts_with("K")
    assert_str(test).starts_with("Kurt")
    assert_str(test).ends_with("wind")
