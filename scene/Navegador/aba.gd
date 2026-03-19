class_name Aba
extends PanelContainer

# emitido ao clicar em fechar aba
signal fechada
# emitido ao clicar na aba (entrar na aba)
signal clicada

# estados possiveis para aba estar
enum Estados {
	Desativada, 	# ja foi completada
	Idle,			# esperando algo
	Foco, 			# atualmente em foco
	Atencao,		# chamando atencao
}

@export var titulo : String = "Titulo"
@export var fechavel : bool = false
@export var estado_inicial : Estados = Estados.Idle

@export var texto_url : String = "https://texto.com"
@export var conteudo : PackedScene

@export var cores_aba : Dictionary[Estados, Color]

@onready var label_nome_site: Label = $HBox/LabelNomeSite
@onready var button_fechar: Button = $HBox/ButtonFechar
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	# da nome a aba
	label_nome_site.text = titulo
	
	# nao mostra o botao de fechar ao criar a aba
	button_fechar.visible = false
	
	## se for fechavel, mostre o botao de fechar
	## se nao for fechavel, esconda o botao de fechar
	#button_fechar.visible = fechavel
	

func aba_clicada() -> void:
	print("{nome_aba} clicada".format({"nome_aba": name}))
	emit_signal("clicada")

func entrar_aba() -> void:
	mudar_estado(Estados.Foco)
	button_fechar.visible = fechavel

func sair_aba() -> void:
	mudar_estado(Estados.Idle)
	button_fechar.visible = false

# muda a cor da aba dependendo do estado recebido
func mudar_estado(novo_estado : Estados) -> void:
	color_rect.color = cores_aba[novo_estado]

func _on_button_fechar_pressed() -> void:
	# conecta o sinal de fechada ao pressionar
	emit_signal("fechada")

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			aba_clicada()
