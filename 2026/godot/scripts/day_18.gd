extends DayBase

func _init() -> void:
	day = 18


func part1(data: String, ans: LineEdit) -> void:
	ans.text = Q18.part1(data)


func part2(data: String, ans: LineEdit) -> void:
	ans.text = Q18.part2(data)


func part3(data: String, ans: LineEdit) -> void:
	ans.text = Q18.part3(data)
