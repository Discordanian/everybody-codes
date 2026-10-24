extends DayBase

func _init() -> void:
	day = 16


func part1(data: String, ans: LineEdit) -> void:
	ans.text = Q16.part1(data)


func part2(data: String, ans: LineEdit) -> void:
	ans.text = Q16.part2(data)


func part3(data: String, ans: LineEdit) -> void:
	ans.text = Q16.part3(data)
