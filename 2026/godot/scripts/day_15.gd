extends DayBase

func _init() -> void:
	day = 15


func part1(data: String) -> String:
	var quest1: Q15 = Q15.new()
	return quest1.part1(data)


func part2(data: String) -> String:
	var quest2: Q15 = Q15.new()
	return quest2.part2(data)


func part3(data: String) -> String:
	var quest3: Q15 = Q15.new()
	return quest3.part3(data)
