extends GdUnitTestSuite

var heap: MinHeap


func before_test() -> void:
    heap = MinHeap.new()


func after_test() -> void:
    heap = null

func test_empty_heap() -> void:
    assert_bool(heap.empty()).is_true()


func test_single_element() -> void:
    heap.push(5, "test")

    assert_bool(heap.empty()).is_false()

    var result: Dictionary = heap.pop()
    assert_int(result["p"]).is_equal(5)
    assert_str(result["v"]).is_equal("test")
    assert_bool(heap.empty()).is_true()

func test_min_heap_property() -> void:
    heap.push(10, "ten")
    heap.push(3, "three")
    heap.push(7, "seven")
    heap.push(1, "one")
    heap.push(15, "fifteen")

    var result: Dictionary = heap.pop()
    assert_int(result["p"]).is_equal(1)
    assert_str(result["v"]).is_equal("one")

    result = heap.pop()
    assert_int(result["p"]).is_equal(3)
    assert_str(result["v"]).is_equal("three")

    result = heap.pop()
    assert_int(result["p"]).is_equal(7)
    assert_str(result["v"]).is_equal("seven")

    result = heap.pop()
    assert_int(result["p"]).is_equal(10)
    assert_str(result["v"]).is_equal("ten")

    result = heap.pop()
    assert_int(result["p"]).is_equal(15)
    assert_str(result["v"]).is_equal("fifteen")

    assert_bool(heap.empty()).is_true()

func test_duplicate_priorities() -> void:
    heap.push(10, "ten")
    heap.push(10, "another ten")
    heap.push(3, "top dog")
    heap.push(10, "a third ten")

    var result: Dictionary = heap.pop()
    assert_int(result["p"]).is_equal(3)
    assert_str(result["v"]).is_equal("top dog")

    result = heap.pop()
    assert_int(result["p"]).is_equal(10)

    result = heap.pop()
    assert_int(result["p"]).is_equal(10)

    result = heap.pop()
    assert_int(result["p"]).is_equal(10)

    assert_bool(heap.empty()).is_true()
