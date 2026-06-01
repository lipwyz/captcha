extends ConteudoAba

@onready var button_ganhar: Button = $Button_ganhar
@onready var button_perder: Button = $Button_perder
@onready var button_errar: Button = $Button_errar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_ganhar.pressed.connect(minigame_ganhar)
	button_perder.pressed.connect(minigame_perder)
	button_errar.pressed.connect(minigame_errar)
