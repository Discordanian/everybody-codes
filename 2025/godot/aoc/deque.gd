class_name Deque extends RefCounted

# Internal circular buffer to store elements
var _buf: Array[Variant]

# Index of the first element in the circular buffer
var _head: int

# Current number of elements in the deque
var _count: int

# Initialize the deque with a specified initial capacity
# @param capacity: Initial size of the internal buffer (default: 16)
func _init(capacity: int = 16) -> void:
	_buf = []
	var ok: int = _buf.resize(capacity)

	assert(ok == OK)

	_head = 0
	_count = 0

# Grow the internal buffer when it becomes full
# Doubles the buffer size and reorganizes elements to maintain order
func _grow() -> void:
	var new_buf: Array[Variant] = []
	var ok: int = new_buf.resize(max(2 * _buf.size(), 1))

	assert(ok == OK)

	for i: int in _count:
		new_buf[i] = _buf[(_head + i) % _buf.size()]
	_buf = new_buf
	_head = 0

# Check if the deque is empty
# @return: true if the deque contains no elements, false otherwise
func empty() -> bool:
	return _count == 0

# Get the current number of elements in the deque
# @return: The number of elements currently stored
func size() -> int:
	return _count

# Add an element to the back (end) of the deque
# @param v: The value to add to the back of the deque
func push_back(v: Variant) -> void:
	if _count == _buf.size(): _grow()
	_buf[(_head + _count) % _buf.size()] = v
	_count += 1

# Add an element to the front (beginning) of the deque
# @param v: The value to add to the front of the deque
func push_front(v: Variant) -> void:
	if _count == _buf.size(): _grow()
	_head = (_head - 1 + _buf.size()) % _buf.size()
	_buf[_head] = v
	_count += 1

# Remove and return the element from the front of the deque
# @return: The value that was at the front of the deque
# @precondition: The deque must not be empty (assertion will fail if empty)
func pop_front() -> Variant:
	assert(_count > 0)

	var v: Variant = _buf[_head]

	_head = (_head + 1) % _buf.size()
	_count -= 1

	return v

# Remove and return the element from the back of the deque
# @return: The value that was at the back of the deque
# @precondition: The deque must not be empty (assertion will fail if empty)
func pop_back() -> Variant:
	assert(_count > 0)

	var idx: int = (_head + _count - 1) % _buf.size()
	var v: Variant = _buf[idx]

	_count -= 1

	return v
