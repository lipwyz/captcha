class_name MainMenu
extends Control

@export var cena_jogo: PackedScene
@onready var label_nao_implementado: Label = $LabelNaoImplementado

func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_packed(cena_jogo)

func _on_button_options_pressed() -> void:
	_deletar_isso()

func _on_button_credits_pressed() -> void:
	_deletar_isso()

func _on_button_exit_pressed() -> void:
	get_tree().quit()

# TODO: deletar
func _deletar_isso() -> void:
	var label := label_nao_implementado.duplicate()
	label.text = "Não Implementado ainda"
	add_child(label)
	label.show()
	label.global_position = get_global_mouse_position()
	label.global_position += Vector2(randi_range(-20, 20), randi_range(-10, 10))
	get_tree().create_timer(2.0).timeout.connect(
		func(): 
			if is_instance_valid(label):
				label.queue_free()
	)
