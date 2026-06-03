extends ConteudoAba

@export var mundo_quebra_cabeca: MundoQuebraCabeca

func _ready() -> void:
	mundo_quebra_cabeca.completou.connect(minigame_ganhar)
	mundo_quebra_cabeca.falhou.connect(minigame_perder)
	mundo_quebra_cabeca.errou.connect(minigame_errar)
