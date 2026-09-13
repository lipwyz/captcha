extends MarginContainer

func _on_quit_pressed() -> void:
	print("Quit")
	get_tree().quit()
