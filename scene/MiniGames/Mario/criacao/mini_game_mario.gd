extends ConteudoAba

@onready var mundo: MundoMario = $SubViewportContainer/SubViewport/Mundo

func _ready() -> void:
	# conecta os sinais de "fim de jogo"
	mundo.ganhou.connect(minigame_ganhar)
	mundo.acabou_vidas.connect(minigame_perder)
	mundo.morreu.connect(mostrar_ad)
	# 
	GerenciadorGlobal.todos_anuncios_fechados.connect(_sair_ad)

func mostrar_ad() -> void:
	# mostra o anuncio
	minigame_errar()
	call_deferred("_pausar_mundo")

# pausa o mundo (processamento, animacoes, etc)
func _pausar_mundo() -> void:
	mundo.process_mode = Node.PROCESS_MODE_DISABLED

func _sair_ad() -> void:
	# volta o mundo (processamento, animacoes, etc)
	mundo.process_mode = Node.PROCESS_MODE_INHERIT
	# respawna o jogador
	mundo.spawn()
