extends ConteudoAba

@onready var ad_popup: Control = $AdPopup
@onready var button_skip: Button = $AdPopup/ButtonSkip
@onready var mundo: MundoMario = $Mundo

func _ready() -> void:
	ad_popup.hide()
	# conecta os sinais de "fim de jogo"
	mundo.perdeu.connect(mostrar_ad)
	mundo.ganhou.connect(terminar)
	# conecta o botao de sair do ad
	button_skip.pressed.connect(_sair_ad)
	# resize
	#GameGerenciador.resize_conteudo_navegador.connect(_resize)
	_resize(GameGerenciador.get_size_conteudo_navegador())

func mostrar_ad() -> void:
	ad_popup.show()
	# pausa o mundo (processamento, animacoes, etc)
	mundo.process_mode = Node.PROCESS_MODE_DISABLED

func _sair_ad() -> void:
	ad_popup.hide()
	# termina
	terminar()

@onready var fim_mapa: Node2D = $Mundo/FimMapa
func _resize(conteudo_size : Vector2) -> void:
	## pegar conteudo_size com GameGerenciador
	#var conteudo_size := GameGerenciador.get_size_conteudo_navegador()
	
	## recebido conteudo_size como signal
	#var tam := conteudo_size.x / fim_mapa.position.x
	
	## usar viewport
	var viewport_size := get_viewport().get_visible_rect().size
	var tam := conteudo_size.x / viewport_size.x
	
	# resize 
	mundo.scale = Vector2.ONE * tam
	
	print("fim_mapa.position ", fim_mapa.position)
	print(" viewport_size ", viewport_size)
	print("conteudo_size ", conteudo_size)
	print("tam ", tam)
