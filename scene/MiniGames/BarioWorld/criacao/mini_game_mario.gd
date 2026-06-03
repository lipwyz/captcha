extends ConteudoAba

@onready var mundo: MundoMario = $SubViewportContainer/SubViewport/Mundo

func _ready() -> void:
	# conecta os sinais de "fim de jogo"
	mundo.ganhou.connect(minigame_ganhar)
	mundo.acabou_vidas.connect(minigame_perder)
	mundo.morreu.connect(respawn_ad)
	mundo.mostrar_anuncio.connect(_mostrar_ad)

func respawn_ad() -> void:
	# mostra o anuncio
	_mostrar_ad()
	# respawna o jogador
	mundo.spawn()

func _mostrar_ad() -> void:
	minigame_errar()
