extends Button
@export var scary_maze:PackedScene

func _pressed() -> void:
	get_tree().change_scene_to_packed(scary_maze)
