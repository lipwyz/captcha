extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var scroll_container: ScrollContainer = $ScrollContainer
@export var conteudo : Control

#func _ready() -> void:
	#await get_tree().process_frame
	#await get_tree().process_frame
	#await get_tree().create_timer(0.5).timeout
	#iniciar_cutscene()

func iniciar_cutscene() -> void:
	animation_player.play("cutscene")
	#_cutscene_code()

func _cutscene_code() -> void:
	# final
	var pos_final : float = conteudo.size.y
	# posicao
	pos_final -= scroll_container.size.y
	# algo
	pos_final -= scroll_container.size.y
	
	# pular pra posicao final
	#scroll_container.scroll_vertical = int(pos_final)
	
	# aaaa
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(scroll_container,
						"scroll_vertical",
						int(pos_final),
						2.5
						).from_current()
	
