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

func mostrar_ad() -> void:
	ad_popup.show()
	# pausa o mundo (processamento, animacoes, etc)
	mundo.process_mode = Node.PROCESS_MODE_DISABLED

func _sair_ad() -> void:
	ad_popup.hide()
	# termina
	terminar()

