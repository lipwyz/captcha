extends Control

@onready var scroll_container: ScrollContainer = $ScrollContainer
@export var conteudo : Control

#func _ready() -> void:
	#await get_tree().process_frame
	#await get_tree().process_frame
	#await get_tree().create_timer(0.5).timeout
	#iniciar_cutscene()

func iniciar_cutscene() -> void:
	# final
	var pos : float = conteudo.size.y
	# posicao
	pos -= scroll_container.size.y
	# algo
	pos -= scroll_container.size.y
	
	# aaaa
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(scroll_container,
						"scroll_vertical",
						int(pos),
						2.5
						).from_current()
	
	#scroll_container.scroll_vertical = int(pos)
