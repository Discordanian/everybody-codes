class_name Counter extends RefCounted

var _counts: Dictionary = {}

## Creates Counter from an Array
## @param Optional Array of items to count
func _init(arr: Array = []) -> void:
    for item: Variant in arr:
        add(item)

## Increase count of an item by `count`
## Inserts item if not there, otherwise adds `count`
## @param item to add to Counter
## @param count Option parameter defaults to 1.
## @returns void
func add(item: Variant, count: int = 1) -> void:
    if _counts.has(item):
        _counts[item] += count
    else:
        _counts[item] = count

## Get count of an item (returns 0 if not present)
## @param item 
## @returns int count for given item
func get_count(item: Variant) -> int:
    return _counts.get(item, 0)

## Remove occurrences of an item
## @param item Item to subtract `count` from.
## @param count Optional parameter number to remove
func remove(item: Variant, count: int = 1) -> void:
    if _counts.has(item):
        _counts[item] -= count
        if _counts[item] <= 0:
            _counts.erase(item)

# Get the most common items
## @param n Optional parameter to limit size of returned Array
## @returns Array (limited to size n if given) sorted by highest count
func most_common(n: int = -1) -> Array:
    var arr: Array = []
    for key: Variant in _counts.keys():
        arr.append([key, _counts[key]])
    
    # Sort by count (descending)
    arr.sort_custom(func(a: Variant, b: Variant) -> bool: return a[1] > b[1])
    
    if n > 0:
        return arr.slice(0, n)
    return arr

## Get total count of all items
## @returns int sum of all counts
func total() -> int:
    var sum: int = 0
    for count: Variant in _counts.values():
        sum += count
    return sum

## Get all unique items
## @returns Array of all items being counted
func items() -> Array:
    return _counts.keys()

## Clear all counts
func clear() -> void:
    _counts.clear()

## Check if item exists
## @param item Item to check existance of
## @returns bool True if item is in Counter
func has(item: Variant) -> bool:
    return _counts.has(item)

## Get the underlying dictionary
## @returns copy of underlying dictionary
func to_dict() -> Dictionary:
    return _counts.duplicate()

## String
## @returns String representation of Counter
func _to_string() -> String:
    return str(_counts)
