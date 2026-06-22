class_name MiniGameScaryMaze
extends ConteudoAba

## Quantidade de anuncios exibidios cada vez q falha [br]
## Sendo o [b]X o minimo[/b] e [b]Y o maximo[/b] em um [code]randi_range[/code]
@export var quantidade_ads_por_falha := Vector2i(2,3) 

@export var scary_maze: ScaryMaze


func _ready() -> void:
	scary_maze.falhou.connect(_errar)
	scary_maze.ganhou.connect(minigame_ganhar)

func _errar() -> void:
	# quantidade de anuncios
	var qtd := randi_range(quantidade_ads_por_falha.x, quantidade_ads_por_falha.y)
	# emite qtd sinais
	for i in range(qtd):
		minigame_errar()
