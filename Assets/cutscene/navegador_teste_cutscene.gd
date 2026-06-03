class_name TestCutScene
extends Control

@export var animation_player: AnimationPlayer

func iniciar_cutscene() -> void:
	animation_player.play("testecutscene")
