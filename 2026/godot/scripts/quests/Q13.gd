class_name Q13 extends RefCounted

func part1(data: String) -> String:
	return str(_calibration(data))


func part2(data: String) -> String:
	return str(data.length())


func part3(data: String) -> String:
	return str(data.length())


func _calibration(data: String) -> int:
	var total: int = 0
	var span: PackedInt32Array = PackedInt32Array()
	var turn: PackedInt32Array = PackedInt32Array()
	var at: PackedInt32Array = PackedInt32Array()
	var duration: PackedInt32Array = PackedInt32Array()
	var seen: int = 0
	for line: String in ECodes.string_to_lines(data.strip_edges()):
		if line.is_empty():
			continue
		var bits: PackedStringArray = line.split(" ", false)
		match bits[0]:
			"hands":
				if seen == 15:
					total += _signals(span, turn, at, duration)
				span = _numbers(bits[1])
				seen = 1
			"direction":
				turn = PackedInt32Array()
				for token: String in bits[1].split(":"):
					turn.append(1 if token == "CW" else -1)
				seen |= 2
			"current":
				at = _numbers(bits[1])
				seen |= 4
			"move":
				duration = _numbers(bits[1])
				seen |= 8
	if seen == 15:
		total += _signals(span, turn, at, duration)
	return total


func _numbers(text: String) -> PackedInt32Array:
	var values: PackedInt32Array = PackedInt32Array()
	for number: int in ECodes.array_int_from_string(text):
		values.append(number)
	return values


func _signals(
	span: PackedInt32Array,
	turn: PackedInt32Array,
	at: PackedInt32Array,
	duration: PackedInt32Array,
) -> int:
	var stops: Array[int] = [0]
	for hand: int in duration.size():
		if duration[hand] > 0 and duration[hand] not in stops:
			stops.append(duration[hand])
	stops.sort()
	var total: int = 0
	for index: int in stops.size() - 1:
		var start: int = stops[index]
		var length: int = stops[index + 1] - start
		var velocity: PackedInt32Array = PackedInt32Array()
		var position: PackedInt32Array = PackedInt32Array()
		velocity.resize(span.size())
		position.resize(span.size())
		for hand: int in span.size():
			var moved: int = mini(start, duration[hand])
			position[hand] = at[hand] + turn[hand] * moved
			velocity[hand] = turn[hand] if start < duration[hand] else 0
		for left: int in span.size():
			for right: int in range(left + 1, span.size()):
				total += _crossings(
					span[left], velocity[left], position[left],
					span[right], velocity[right], position[right],
					length,
				)
	return total


# Times in this stretch when the two hands point the same way, excluding a
# meeting that is already true at the start of the stretch.
func _crossings(
	span_a: int,
	velocity_a: int,
	position_a: int,
	span_b: int,
	velocity_b: int,
	position_b: int,
	length: int,
) -> int:
	var scale: int = span_a * span_b
	var speed: int = velocity_a * span_b - velocity_b * span_a
	var offset: int = position_a * span_b - position_b * span_a
	if speed == 0:
		return 0
	var low: int
	var high: int
	if speed > 0:
		low = _floor_div(offset, scale) + 1
		high = _floor_div(offset + length * speed, scale)
	else:
		low = _floor_div(offset + length * speed + scale - 1, scale)
		high = _floor_div(offset - 1, scale)
	if high < low:
		return 0
	return high - low + 1


func _floor_div(numerator: int, denominator: int) -> int:
	if numerator >= 0:
		@warning_ignore("integer_division")
		return numerator / denominator
	var positive: int = -numerator
	@warning_ignore("integer_division")
	return -((positive + denominator - 1) / denominator)
