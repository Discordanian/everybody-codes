extends DayBase

func _init() -> void:
	day = 2


func part1(data: String, ans: LineEdit) -> void:
	ans.text = Q02.part1(data)


func part2(data: String, ans: LineEdit) -> void:
	ans.text = Q02.part2(data)


func part3(data: String, ans: LineEdit) -> void:
	ans.text = Q02.part3(data)
