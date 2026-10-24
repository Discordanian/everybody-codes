extends DayBase

func _init() -> void:
	day = 6


func part1(data: String, ans: LineEdit) -> void:
	ans.text = Q06.part1(data)


func part2(data: String, ans: LineEdit) -> void:
	ans.text = Q06.part2(data)


func part3(data: String, ans: LineEdit) -> void:
	ans.text = Q06.part3(data)
