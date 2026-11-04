extends ConteudoAba

@onready var main: FruitNinjaMain = $SubViewportContainer/SubViewport/FruitNinja/Main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main.terminou_partida.connect(minigame_ganhar)
