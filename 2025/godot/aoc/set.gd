class_name Set extends RefCounted

## A strongly-typed set implementation backed by a Dictionary.
## Provides O(1) add, remove, and lookup operations.

# The dictionary (_map) that backs our set.
# Provides amortized O(1) adding, removing, and presence-checking.
var _map: Dictionary = {}
var _start: int = 0
var _current: int = 0

# The dummy value we use to fill in the dictionary.
const VALUE: int = 1


## Initialization of Set
## @returns void
func _init() -> void:
	_map = {}
	_start = 0
	_current = 0


func _should_continue() -> bool:
	return _current < size()


func _iter_init(_arg: Variant) -> bool:
	_current = _start
	return _should_continue()


func _iter_next(_arg: Variant) -> bool:
	_current += 1
	return _should_continue()


func _iter_get(_arg: Variant) -> Variant:
	return _map.keys()[_current]


## Adds item to a Set
## @param element Item to add to Set
func add(element: Variant) -> void:
	_map[element] = VALUE


## Adds items to a Set from an Array
## @param elements Array of items to add to the Set
func add_all(elements: Array) -> void:
	for element: Variant in elements:
		add(element)


## Remove given item from set
## @param element Item to remove from Set
func remove(element: Variant) -> void:
	_map.erase(element)


## Remove items from set based on an array
## @param elements Array of items to remove from Set
func remove_all(elements: Array) -> void:
	for element: Variant in elements:
		remove(element)


## Removes all elements that return true when passed to the matcher
## @param matcher Callable function to apply to each element.  Matching elements are removed.
func remove_matching(matcher: Callable) -> void:
	for element: Variant in _map.keys():
		if matcher.call(element):
			remove(element)


## Checks existance of an element
## @param element Element to check existance of
func contains(element: Variant) -> bool:
	return _map.has(element)


## Returns all elements as an array
## @returns Array of Set elements
func get_as_array() -> Array:
	return _map.keys()


## Removes all elements from the set
func clear() -> void:
	_map.clear()


## Checks if the Set is is_empty
## @returns bool True if Set has no elements
func is_empty() -> bool:
	return _map.is_empty()


## Returns size of set
## @returns int Number of elements in Set
func size() -> int:
	return _map.size()


## Returns a new set containing all elements from this set and the other set
## @param other Set
## @param returns Another Set with the union of the first set and the other
func union(other: Set) -> Set:
	var result: Set = Set.new()
    
	# Add all elements from this set
	for element: Variant in _map.keys():
		result.add(element)
    
	# Add all elements from the other set
	for element: Variant in other._map.keys():
		result.add(element)
    
	return result


## Returns a new set containing all elements from this set contained in the other set
## @param other Set
## @param returns Another Set with the intersection of the first set and the other
func intersection(other: Set) -> Set:
	var result: Set = Set.new()
    
	# Iterate over the smaller set for better performance
	var smaller_set: Set = self if size() <= other.size() else other
	var larger_set: Set = other if size() <= other.size() else self
    
	for element: Variant in smaller_set._map.keys():
		if larger_set.contains(element):
			result.add(element)
    
	return result


## Returns a new set containing all elements from this set not contained in the other set
## @param other Set
## @param returns Another Set with the difference of the first set and the other
func difference(other: Set) -> Set:
	var result: Set = Set.new()
    
	for element: Variant in _map.keys():
		if not other.contains(element):
			result.add(element)
    
	return result


## Returns a new set containing all elements contained only in first OR other set but not both
## @param other Set
## @param returns Another Set with the symmetric difference of the first set and the other
func symmetric_difference(other: Set) -> Set:
	var result: Set = Set.new()
    
	# Add elements from this set not in other
	for element: Variant in _map.keys():
		if not other.contains(element):
			result.add(element)
    
	# Add elements from other set not in this
	for element: Variant in other._map.keys():
		if not contains(element):
			result.add(element)
    
	return result


## Returns true if this set is a subset of the other set
func is_subset(other: Set) -> bool:
	if size() > other.size():
		return false
    
	for element: Variant in _map.keys():
		if not other.contains(element):
			return false
    
	return true


## Returns true if this set is a superset of the other set
func is_superset(other: Set) -> bool:
	return other.is_subset(self)


## Returns true if the sets have no elements in common
func is_disjoint(other: Set) -> bool:
	var smaller_set: Set = self if size() <= other.size() else other
	var larger_set: Set = other if size() <= other.size() else self
    
	for element: Variant in smaller_set._map.keys():
		if larger_set.contains(element):
			return false
    
	return true


## Returns a string representation of the set
func _to_string() -> String:
	return "Set(" + str(get_as_array()) + ")"
