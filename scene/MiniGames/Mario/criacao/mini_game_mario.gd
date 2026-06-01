extends ConteudoAba

@onready var mundo: MundoMario = $SubViewportContainer/SubViewport/Mundo

func _ready() -> void:
	# conecta os sinais de "fim de jogo"
	mundo.ganhou.connect(minigame_ganhar)
	mundo.acabou_vidas.connect(minigame_perder)
	mundo.morreu.connect(mostrar_ad)

func mostrar_ad() -> void:
	# mostra o anuncio
	minigame_errar()
	# respawna o jogador
	mundo.spawn()
