class_name MiniGameScaryMaze
extends ConteudoAba

@export var scary_maze: ScaryMaze

func _ready() -> void:
	scary_maze.falhou.connect(minigame_errar)
	scary_maze.falhou.connect(minigame_ganhar)
