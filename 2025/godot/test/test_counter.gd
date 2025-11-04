extends GdUnitTestSuite

# Test initialization
func test_init_empty() -> void:
    var counter: Counter = Counter.new()
    assert_int(counter.total()).is_equal(0)
    assert_array(counter.items()).is_empty()

func test_init_with_array() -> void:
    var counter: Counter = Counter.new(["a", "b", "a", "c", "a", "b"])
    assert_int(counter.get_count("a")).is_equal(3)
    assert_int(counter.get_count("b")).is_equal(2)
    assert_int(counter.get_count("c")).is_equal(1)

func test_init_with_integers() -> void:
    var counter: Counter = Counter.new([1, 2, 3, 1, 2, 1])
    assert_int(counter.get_count(1)).is_equal(3)
    assert_int(counter.get_count(2)).is_equal(2)
    assert_int(counter.get_count(3)).is_equal(1)

func test_init_with_mixed_types() -> void:
    var counter: Counter = Counter.new([1, "a", 1, "a", 2.5, "a"])
    assert_int(counter.get_count(1)).is_equal(2)
    assert_int(counter.get_count("a")).is_equal(3)
    assert_int(counter.get_count(2.5)).is_equal(1)

# Test add operation
func test_add_new_item() -> void:
    var counter: Counter = Counter.new()
    counter.add("a")
    assert_int(counter.get_count("a")).is_equal(1)

func test_add_existing_item() -> void:
    var counter: Counter = Counter.new()
    counter.add("a")
    counter.add("a")
    counter.add("a")
    assert_int(counter.get_count("a")).is_equal(3)

func test_add_with_custom_count() -> void:
    var counter: Counter = Counter.new()
    counter.add("a", 5)
    assert_int(counter.get_count("a")).is_equal(5)
    counter.add("a", 3)
    assert_int(counter.get_count("a")).is_equal(8)

func test_add_zero_count() -> void:
    var counter: Counter = Counter.new()
    counter.add("a", 0)
    assert_int(counter.get_count("a")).is_equal(0)

func test_add_negative_count() -> void:
    var counter: Counter = Counter.new()
    counter.add("a", 5)
    counter.add("a", -2)
    assert_int(counter.get_count("a")).is_equal(3)

func test_add_multiple_different_items() -> void:
    var counter: Counter = Counter.new()
    counter.add("a")
    counter.add("b")
    counter.add("c")
    assert_int(counter.get_count("a")).is_equal(1)
    assert_int(counter.get_count("b")).is_equal(1)
    assert_int(counter.get_count("c")).is_equal(1)

# Test get_count operation
func test_get_count_existing_item() -> void:
    var counter: Counter = Counter.new(["a", "a", "b"])
    assert_int(counter.get_count("a")).is_equal(2)
    assert_int(counter.get_count("b")).is_equal(1)

func test_get_count_nonexistent_item() -> void:
    var counter: Counter = Counter.new()
    assert_int(counter.get_count("nonexistent")).is_equal(0)

func test_get_count_after_removal() -> void:
    var counter: Counter = Counter.new(["a", "a", "a"])
    counter.remove("a", 3)
    assert_int(counter.get_count("a")).is_equal(0)

# Test remove operation
func test_remove_single_occurrence() -> void:
    var counter: Counter = Counter.new(["a", "a", "a"])
    counter.remove("a")
    assert_int(counter.get_count("a")).is_equal(2)

func test_remove_multiple_occurrences() -> void:
    var counter: Counter = Counter.new(["a", "a", "a", "a"])
    counter.remove("a", 2)
    assert_int(counter.get_count("a")).is_equal(2)

func test_remove_all_occurrences() -> void:
    var counter: Counter = Counter.new(["a", "a", "a"])
    counter.remove("a", 3)
    assert_bool(counter.has("a")).is_false()
    assert_int(counter.get_count("a")).is_equal(0)

func test_remove_more_than_count() -> void:
    var counter: Counter = Counter.new(["a", "a"])
    counter.remove("a", 5)
    assert_bool(counter.has("a")).is_false()
    assert_int(counter.get_count("a")).is_equal(0)

func test_remove_nonexistent_item() -> void:
    var counter: Counter = Counter.new(["a"])
    counter.remove("b")
    # Should not crash
    assert_int(counter.get_count("a")).is_equal(1)

func test_remove_to_zero_removes_item() -> void:
    var counter: Counter = Counter.new(["a", "a"])
    counter.remove("a", 2)
    assert_bool(counter.has("a")).is_false()
    assert_array(counter.items()).is_empty()

# Test most_common operation
func test_most_common_no_limit() -> void:
    var counter: Counter = Counter.new(["a", "a", "a", "b", "b", "c"])
    var result: Array = counter.most_common()
    assert_int(result.size()).is_equal(3)
    assert_array(result[0]).is_equal(["a", 3])
    assert_array(result[1]).is_equal(["b", 2])
    assert_array(result[2]).is_equal(["c", 1])

func test_most_common_with_limit() -> void:
    var counter: Counter = Counter.new(["a", "a", "a", "b", "b", "c"])
    var result: Array = counter.most_common(2)
    assert_int(result.size()).is_equal(2)
    assert_array(result[0]).is_equal(["a", 3])
    assert_array(result[1]).is_equal(["b", 2])

func test_most_common_single_item() -> void:
    var counter: Counter = Counter.new(["a", "b", "c", "d"])
    var result: Array = counter.most_common(1)
    assert_int(result.size()).is_equal(1)
    assert_int(result[0][1]).is_equal(1)

func test_most_common_empty_counter() -> void:
    var counter: Counter = Counter.new()
    var result: Array = counter.most_common()
    assert_array(result).is_empty()

func test_most_common_limit_larger_than_items() -> void:
    var counter: Counter = Counter.new(["a", "b"])
    var result: Array = counter.most_common(10)
    assert_int(result.size()).is_equal(2)

func test_most_common_equal_counts() -> void:
    var counter: Counter = Counter.new(["a", "b", "c"])
    var result: Array = counter.most_common()
    assert_int(result.size()).is_equal(3)
    # All should have count of 1
    assert_int(result[0][1]).is_equal(1)
    assert_int(result[1][1]).is_equal(1)
    assert_int(result[2][1]).is_equal(1)

# Test total operation
func test_total_empty_counter() -> void:
    var counter: Counter = Counter.new()
    assert_int(counter.total()).is_equal(0)

func test_total_single_item() -> void:
    var counter: Counter = Counter.new(["a"])
    assert_int(counter.total()).is_equal(1)

func test_total_multiple_items() -> void:
    var counter: Counter = Counter.new(["a", "a", "b", "c", "c", "c"])
    assert_int(counter.total()).is_equal(6)

func test_total_after_add() -> void:
    var counter: Counter = Counter.new(["a", "b"])
    assert_int(counter.total()).is_equal(2)
    counter.add("c", 3)
    assert_int(counter.total()).is_equal(5)

func test_total_after_remove() -> void:
    var counter: Counter = Counter.new(["a", "a", "a", "b", "b"])
    assert_int(counter.total()).is_equal(5)
    counter.remove("a", 2)
    assert_int(counter.total()).is_equal(3)

# Test items operation
func test_items_empty_counter() -> void:
    var counter: Counter = Counter.new()
    var result: Array = counter.items()
    assert_array(result).is_empty()

func test_items_returns_all_keys() -> void:
    var counter: Counter = Counter.new(["a", "b", "c", "a"])
    var result: Array = counter.items()
    assert_int(result.size()).is_equal(3)
    assert_bool(result.has("a")).is_true()
    assert_bool(result.has("b")).is_true()
    assert_bool(result.has("c")).is_true()

func test_items_after_remove_all() -> void:
    var counter: Counter = Counter.new(["a", "a"])
    counter.remove("a", 2)
    var result: Array = counter.items()
    assert_array(result).is_empty()

# Test clear operation
func test_clear_empty_counter() -> void:
    var counter: Counter = Counter.new()
    counter.clear()
    assert_int(counter.total()).is_equal(0)

func test_clear_removes_all_items() -> void:
    var counter: Counter = Counter.new(["a", "b", "c", "a", "b"])
    counter.clear()
    assert_int(counter.total()).is_equal(0)
    assert_array(counter.items()).is_empty()
    assert_int(counter.get_count("a")).is_equal(0)

func test_clear_allows_adding_after() -> void:
    var counter: Counter = Counter.new(["a", "b"])
    counter.clear()
    counter.add("c")
    assert_int(counter.get_count("c")).is_equal(1)
    assert_int(counter.total()).is_equal(1)

# Test has operation
func test_has_existing_item() -> void:
    var counter: Counter = Counter.new(["a", "b"])
    assert_bool(counter.has("a")).is_true()
    assert_bool(counter.has("b")).is_true()

func test_has_nonexistent_item() -> void:
    var counter: Counter = Counter.new(["a"])
    assert_bool(counter.has("b")).is_false()

func test_has_after_removal() -> void:
    var counter: Counter = Counter.new(["a", "a"])
    counter.remove("a", 2)
    assert_bool(counter.has("a")).is_false()

func test_has_empty_counter() -> void:
    var counter: Counter = Counter.new()
    assert_bool(counter.has("anything")).is_false()

# Test to_dict operation
func test_to_dict_empty() -> void:
    var counter: Counter = Counter.new()
    var dict: Dictionary = counter.to_dict()
    assert_bool(dict.is_empty()).is_true()

func test_to_dict_returns_copy() -> void:
    var counter: Counter = Counter.new(["a", "b", "a"])
    var dict: Dictionary = counter.to_dict()
    
    # Modify the returned dict
    dict["a"] = 999
    
    # Original counter should be unchanged
    assert_int(counter.get_count("a")).is_equal(2)

func test_to_dict_contains_all_counts() -> void:
    var counter: Counter = Counter.new(["a", "a", "b", "c", "c", "c"])
    var dict: Dictionary = counter.to_dict()
    
    assert_int(dict["a"]).is_equal(2)
    assert_int(dict["b"]).is_equal(1)
    assert_int(dict["c"]).is_equal(3)

# Test _to_string operation
func test_to_string_not_empty() -> void:
    var counter: Counter = Counter.new(["a", "b"])
    var result: String = counter._to_string()
    assert_bool(result.length() > 0).is_true()

# Test edge cases and complex scenarios
func test_multiple_operations_sequence() -> void:
    var counter: Counter = Counter.new(["a", "b", "c"])
    counter.add("a", 2)
    counter.add("d", 5)
    counter.remove("b")
    counter.remove("c")
    
    assert_int(counter.get_count("a")).is_equal(3)
    assert_int(counter.get_count("b")).is_equal(0)
    assert_int(counter.get_count("c")).is_equal(0)
    assert_int(counter.get_count("d")).is_equal(5)
    assert_int(counter.total()).is_equal(8)

func test_large_counts() -> void:
    var counter: Counter = Counter.new()
    counter.add("item", 1000000)
    assert_int(counter.get_count("item")).is_equal(1000000)
    assert_int(counter.total()).is_equal(1000000)

func test_many_unique_items() -> void:
    var items: Array = []
    for i: int in range(100):
        items.append(i)
    
    var counter: Counter = Counter.new(items)
    assert_int(counter.items().size()).is_equal(100)
    assert_int(counter.total()).is_equal(100)

func test_counter_with_vectors() -> void:
    var counter: Counter = Counter.new([Vector2(1, 2), Vector2(1, 2), Vector2(3, 4)])
    assert_int(counter.get_count(Vector2(1, 2))).is_equal(2)
    assert_int(counter.get_count(Vector2(3, 4))).is_equal(1)

func test_counter_with_null() -> void:
    var counter: Counter = Counter.new([null, null, "a"])
    assert_int(counter.get_count(null)).is_equal(2)
    assert_int(counter.get_count("a")).is_equal(1)

func test_word_frequency_use_case() -> void:
    var text: Array = ["the", "quick", "brown", "fox", "jumps", "over", "the", "lazy", "dog", "the"]
    var counter: Counter = Counter.new(text)
    
    var most_common: Array = counter.most_common(3)
    assert_array(most_common[0]).is_equal(["the", 3])
    assert_int(counter.total()).is_equal(10)
