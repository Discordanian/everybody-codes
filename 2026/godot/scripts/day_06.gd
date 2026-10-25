extends DayBase

func _init() -> void:
	day = 6


func part1(data: String, ans: LineEdit) -> void:
	var quest1: Q06 = Q06.new()
	ans.text = quest1.part1(data)


func part2(data: String, ans: LineEdit) -> void:
	var quest2: Q06 = Q06.new()
	ans.text = quest2.part2(data)


func part3(data: String, ans: LineEdit) -> void:
	var quest3: Q06 = Q06.new()
	ans.text = quest3.part3(data)
