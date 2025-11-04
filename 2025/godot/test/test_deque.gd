extends GdUnitTestSuite

var deque: Deque

# Setup method called before each test
func before_test() -> void:
    deque = Deque.new()

# Cleanup method called after each test
func after_test() -> void:
    deque = null

# Test basic deque creation and empty state
func test_empty_deque() -> void:
    assert_bool(deque.empty()).is_true()
    assert_int(deque.size()).is_equal(0)

# Test deque with custom initial capacity
func test_custom_capacity() -> void:
    var custom_deque: Deque = Deque.new(8)
    assert_bool(custom_deque.empty()).is_true()
    assert_int(custom_deque.size()).is_equal(0)

# Test push_back functionality
func test_push_back() -> void:
    deque.push_back("first")
    deque.push_back("second")
    deque.push_back("third")
    
    assert_bool(deque.empty()).is_false()
    assert_int(deque.size()).is_equal(3)

# Test push_front functionality
func test_push_front() -> void:
    deque.push_front("first")
    deque.push_front("second")
    deque.push_front("third")
    
    assert_bool(deque.empty()).is_false()
    assert_int(deque.size()).is_equal(3)

# Test pop_back functionality
func test_pop_back() -> void:
    deque.push_back("first")
    deque.push_back("second")
    deque.push_back("third")
    
    var result3: Variant = deque.pop_back()
    assert_str(result3).is_equal("third")
    assert_int(deque.size()).is_equal(2)
    
    var result2: Variant = deque.pop_back()
    assert_str(result2).is_equal("second")
    assert_int(deque.size()).is_equal(1)
    
    var result1: Variant = deque.pop_back()
    assert_str(result1).is_equal("first")
    assert_bool(deque.empty()).is_true()

# Test pop_front functionality
func test_pop_front() -> void:
    deque.push_back("first")
    deque.push_back("second")
    deque.push_back("third")
    
    var result1: Variant = deque.pop_front()
    assert_str(result1).is_equal("first")
    assert_int(deque.size()).is_equal(2)
    
    var result2: Variant = deque.pop_front()
    assert_str(result2).is_equal("second")
    assert_int(deque.size()).is_equal(1)
    
    var result3: Variant = deque.pop_front()
    assert_str(result3).is_equal("third")
    assert_bool(deque.empty()).is_true()

# Test mixed push operations (LIFO-like behavior with push_front/pop_front)
func test_mixed_push_operations() -> void:
    deque.push_back("back1")
    deque.push_front("front1")
    deque.push_back("back2")
    deque.push_front("front2")
    
    assert_int(deque.size()).is_equal(4)
    
    # Order should be: front2, front1, back1, back2
    assert_str(deque.pop_front()).is_equal("front2")
    assert_str(deque.pop_front()).is_equal("front1")
    assert_str(deque.pop_front()).is_equal("back1")
    assert_str(deque.pop_front()).is_equal("back2")
    
    assert_bool(deque.empty()).is_true()

# Test queue-like behavior (FIFO with push_back/pop_front)
func test_queue_behavior() -> void:
    deque.push_back("first")
    deque.push_back("second")
    deque.push_back("third")
    
    assert_str(deque.pop_front()).is_equal("first")
    assert_str(deque.pop_front()).is_equal("second")
    assert_str(deque.pop_front()).is_equal("third")
    
    assert_bool(deque.empty()).is_true()

# Test stack-like behavior (LIFO with push_back/pop_back)
func test_stack_behavior() -> void:
    deque.push_back("first")
    deque.push_back("second")
    deque.push_back("third")
    
    assert_str(deque.pop_back()).is_equal("third")
    assert_str(deque.pop_back()).is_equal("second")
    assert_str(deque.pop_back()).is_equal("first")
    
    assert_bool(deque.empty()).is_true()

# Test reverse stack behavior (LIFO with push_front/pop_front)
func test_reverse_stack_behavior() -> void:
    deque.push_front("first")
    deque.push_front("second")
    deque.push_front("third")
    
    assert_str(deque.pop_front()).is_equal("third")
    assert_str(deque.pop_front()).is_equal("second")
    assert_str(deque.pop_front()).is_equal("first")
    
    assert_bool(deque.empty()).is_true()

# Test buffer growth functionality
func test_buffer_growth() -> void:
    var small_deque: Deque = Deque.new(2)  # Start with capacity of 2
    
    # Fill beyond initial capacity to trigger growth
    small_deque.push_back(1)
    small_deque.push_back(2)
    small_deque.push_back(3)  # Should trigger growth
    small_deque.push_back(4)
    small_deque.push_back(5)  # Should trigger another growth
    
    assert_int(small_deque.size()).is_equal(5)
    
    # Verify all elements are intact
    assert_int(small_deque.pop_front()).is_equal(1)
    assert_int(small_deque.pop_front()).is_equal(2)
    assert_int(small_deque.pop_front()).is_equal(3)
    assert_int(small_deque.pop_front()).is_equal(4)
    assert_int(small_deque.pop_front()).is_equal(5)

# Test buffer growth with mixed operations
func test_buffer_growth_mixed_operations() -> void:
    var small_deque: Deque = Deque.new(3)  # Start with capacity of 3
    
    # Fill and exceed capacity with mixed front/back operations
    small_deque.push_back(1)
    small_deque.push_front(0)
    small_deque.push_back(2)    # Full capacity
    small_deque.push_front(-1)  # Should trigger growth
    small_deque.push_back(3)
    
    assert_int(small_deque.size()).is_equal(5)
    
    # Verify order: -1, 0, 1, 2, 3
    assert_int(small_deque.pop_front()).is_equal(-1)
    assert_int(small_deque.pop_front()).is_equal(0)
    assert_int(small_deque.pop_front()).is_equal(1)
    assert_int(small_deque.pop_front()).is_equal(2)
    assert_int(small_deque.pop_front()).is_equal(3)

# Test with different data types
func test_mixed_data_types() -> void:
    deque.push_back("string")
    deque.push_back(42)
    deque.push_back([1, 2, 3])
    deque.push_back({"key": "value"})
    deque.push_back(3.14)
    
    assert_int(deque.size()).is_equal(5)
    
    assert_str(deque.pop_front()).is_equal("string")
    assert_int(deque.pop_front()).is_equal(42)
    assert_array(deque.pop_front()).is_equal([1, 2, 3])
    assert_dict(deque.pop_front()).is_equal({"key": "value"})
    assert_float(deque.pop_front()).is_equal(3.14)

# Test large number of elements
func test_large_deque() -> void:
    var test_size: int = 1000
    
    # Fill with numbers 0 to 999
    for i: int in range(test_size):
        deque.push_back(i)
    
    assert_int(deque.size()).is_equal(test_size)
    
    # Verify all elements come out in order
    for i: int in range(test_size):
        assert_int(deque.pop_front()).is_equal(i)
    
    assert_bool(deque.empty()).is_true()

# Test alternating operations
func test_alternating_operations() -> void:
    # Simulate a sliding window pattern
    deque.push_back(1)
    deque.push_back(2)
    deque.push_back(3)
    
    assert_int(deque.pop_front()).is_equal(1)
    deque.push_back(4)
    
    assert_int(deque.pop_front()).is_equal(2)
    deque.push_back(5)
    
    assert_int(deque.pop_front()).is_equal(3)
    deque.push_back(6)
    
    assert_int(deque.size()).is_equal(3)
    assert_int(deque.pop_front()).is_equal(4)
    assert_int(deque.pop_front()).is_equal(5)
    assert_int(deque.pop_front()).is_equal(6)

# Test circular buffer wrapping
func test_circular_buffer_wrapping() -> void:
    var small_deque: Deque = Deque.new(4)
    
    # Fill the buffer
    small_deque.push_back(1)
    small_deque.push_back(2)
    small_deque.push_back(3)
    
    # Remove from front and add to back to test wrapping
    assert_int(small_deque.pop_front()).is_equal(1)
    small_deque.push_back(4)
    
    assert_int(small_deque.pop_front()).is_equal(2)
    small_deque.push_back(5)
    
    # Should still work correctly
    assert_int(small_deque.size()).is_equal(3)
    assert_int(small_deque.pop_front()).is_equal(3)
    assert_int(small_deque.pop_front()).is_equal(4)
    assert_int(small_deque.pop_front()).is_equal(5)

# Test front operations exclusively
func test_front_operations_only() -> void:
    deque.push_front(1)
    deque.push_front(2)
    deque.push_front(3)
    
    assert_int(deque.size()).is_equal(3)
    
    assert_int(deque.pop_front()).is_equal(3)
    assert_int(deque.pop_front()).is_equal(2)
    assert_int(deque.pop_front()).is_equal(1)
    
    assert_bool(deque.empty()).is_true()

# Test back operations exclusively
func test_back_operations_only() -> void:
    deque.push_back(1)
    deque.push_back(2)
    deque.push_back(3)
    
    assert_int(deque.size()).is_equal(3)
    
    assert_int(deque.pop_back()).is_equal(3)
    assert_int(deque.pop_back()).is_equal(2)
    assert_int(deque.pop_back()).is_equal(1)
    
    assert_bool(deque.empty()).is_true()

# Test deque as double-ended queue with random operations
func test_random_operations() -> void:
    var rng: RandomNumberGenerator = RandomNumberGenerator.new()
    rng.seed = 42  # Fixed seed for reproducible tests
    
    var reference_array: Array[int] = []
    var operations: int = 100
    
    for i: int in range(operations):
        var operation: int = rng.randi_range(0, 3)
        var value: int = rng.randi_range(1, 1000)
        
        match operation:
            0:  # push_back
                deque.push_back(value)
                reference_array.append(value)
            1:  # push_front
                deque.push_front(value)
                reference_array.push_front(value)
            2:  # pop_back (if not empty)
                if not deque.empty():
                    var deque_val: Variant = deque.pop_back()
                    var ref_val: Variant = reference_array.pop_back()
                    assert_int(deque_val).is_equal(ref_val)
            3:  # pop_front (if not empty)
                if not deque.empty():
                    var deque_val: Variant = deque.pop_front()
                    var ref_val: Variant = reference_array.pop_front()
                    assert_int(deque_val).is_equal(ref_val)
        
        # Verify size consistency
        assert_int(deque.size()).is_equal(reference_array.size())
        assert_bool(deque.empty()).is_equal(reference_array.is_empty())

# Test edge case: single element operations
func test_single_element_operations() -> void:
    # Test push_back -> pop_back
    deque.push_back("test1")
    assert_str(deque.pop_back()).is_equal("test1")
    assert_bool(deque.empty()).is_true()
    
    # Test push_back -> pop_front
    deque.push_back("test2")
    assert_str(deque.pop_front()).is_equal("test2")
    assert_bool(deque.empty()).is_true()
    
    # Test push_front -> pop_back
    deque.push_front("test3")
    assert_str(deque.pop_back()).is_equal("test3")
    assert_bool(deque.empty()).is_true()
    
    # Test push_front -> pop_front
    deque.push_front("test4")
    assert_str(deque.pop_front()).is_equal("test4")
    assert_bool(deque.empty()).is_true()

# Test stress test with capacity 1
func test_minimal_capacity() -> void:
    var tiny_deque: Deque = Deque.new(1)
    
    # Should trigger immediate growth
    tiny_deque.push_back(1)
    tiny_deque.push_back(2)  # Forces growth
    
    assert_int(tiny_deque.size()).is_equal(2)
    assert_int(tiny_deque.pop_front()).is_equal(1)
    assert_int(tiny_deque.pop_front()).is_equal(2)
    assert_bool(tiny_deque.empty()).is_true()
