extends Node2D


func _on_button_pressed() -> void:
	var chosen_day: String = $DaySelector.get_item_text($DaySelector.selected)
	print("Chosen day: ", chosen_day)
	chosen_day = chosen_day.get_slice("day ", 1)
	var scene = load("res://day"+chosen_day+".tscn")
	var instance = scene.instantiate()
	add_child(instance)
	instance.solve($InputText.text)

func set_solution(solution: String) -> void:
	$ResultText.text = solution
