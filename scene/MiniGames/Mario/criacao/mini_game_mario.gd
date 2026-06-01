extends ConteudoAba

@onready var ad_popup: Control = $AdPopup
@onready var button_skip: Button = $AdPopup/ButtonSkip
@onready var mundo: MundoMario = $SubViewportContainer/SubViewport/Mundo

func _ready() -> void:
	ad_popup.hide()
	# conecta os sinais de "fim de jogo"
	mundo.ganhou.connect(minigame_ganhar)
	mundo.morreu.connect(mostrar_ad)
	# 
	GerenciadorGlobal.todos_anuncios_fechados.connect(_sair_ad)

func mostrar_ad() -> void:
	# mostra o anuncio
	minigame_errar()
	# pausa o mundo (processamento, animacoes, etc)
	mundo.process_mode = Node.PROCESS_MODE_DISABLED
	

func _sair_ad() -> void:
	# volta o mundo (processamento, animacoes, etc)
	mundo.process_mode = Node.PROCESS_MODE_INHERIT
	mundo.spawn()
