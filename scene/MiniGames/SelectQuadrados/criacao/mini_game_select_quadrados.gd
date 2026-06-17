extends ConteudoAba

@export var gerenciador_imagem_clicavel: GerenciadorImagemClicavel

@onready var verificador: Control = $Verificador

func _ready() -> void:
	gerenciador_imagem_clicavel.concluido.connect(minigame_ganhar)
	gerenciador_imagem_clicavel.errado.connect(minigame_errar)
	# ajustar o tamanho da imagem
	_ajustar_tamanho_img()

func _ajustar_tamanho_img() -> void:
	# calcula a posicao do canto direito baixo da imagem
	var end_pos_x = gerenciador_imagem_clicavel.position.x
	end_pos_x += gerenciador_imagem_clicavel.get_image_size().x
	# ajusta o tamanho do Control, para o tamnho da imagem
	verificador.set_anchors_preset(Control.PRESET_LEFT_WIDE)
	verificador.size.x = end_pos_x
	# por alguma razao ele ta alterando a posicao do filho, entao reseta
	await get_tree().process_frame
	verificador.get_child(0).position = Vector2.ZERO
