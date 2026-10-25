extends DayBase

func _init() -> void:
	day = 2


func part1(data: String, ans: LineEdit) -> void:
	var quest1: Q02 = Q02.new()
	ans.text = quest1.part1(data)


func part2(data: String, ans: LineEdit) -> void:
	var quest2: Q02 = Q02.new()
	ans.text = quest2.part2(data)


func part3(data: String, ans: LineEdit) -> void:
	var quest3: Q02 = Q02.new()
	ans.text = quest3.part3(data)
