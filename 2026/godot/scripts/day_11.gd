extends DayBase

func _init() -> void:
	day = 11


func part1(data: String) -> String:
	var quest1: Q11 = Q11.new()
	return quest1.part1(data)


func part2(data: String) -> String:
	var quest2: Q11 = Q11.new()
	return quest2.part2(data)


func part3(data: String) -> String:
	var quest3: Q11 = Q11.new()
	return quest3.part3(data)
