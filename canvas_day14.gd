extends Node2D

var all_states = []
var current_state = []

func set_state_story(steps_states: Array) -> void:
	all_states = steps_states
	$HSlider.max_value = len(all_states) - 1

func _draw():
	draw_line(Vector2(1.5, 1.0), Vector2(1.5, 4.0), Color.RED, 1.0)
	draw_line(Vector2(4.0, 1.0), Vector2(4.0, 4.0), Color.RED, 2.0)
	draw_line(Vector2(7.5, 1.0), Vector2(7.5, 4.0), Color.RED, 3.0)
	for pos in current_state:
		draw_rect(Rect2(pos[0] * 8.0, pos[1] * 8.0, 8.0, 8.0), Color.GREEN)


func _on_timer_timeout() -> void:
	$HSlider.value += 1


func _on_h_slider_value_changed(value: float) -> void:
	print("position ", $HSlider.value)
	current_state = all_states[int($HSlider.value)]
	queue_redraw()
	get_parent().title = str($HSlider.value)


func _on_h_slider_drag_ended(value_changed: bool) -> void:
	$Timer.stop()
