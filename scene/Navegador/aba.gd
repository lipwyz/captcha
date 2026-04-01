class_name Aba
extends PanelContainer

# emitido ao clicar na aba (entrar na aba)
signal clicada
# emitido ao clicar em fechar aba
signal fechada

# estados possiveis para aba estar
enum Estados {
	Idle,			# esperando algo
	Foco, 			# atualmente em foco
	Atencao,		# chamando atencao
	Desativada, 	# ja foi completada
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

## criador de aba
static func criar_aba(	_titulo: String,
						_fechavel:=false,
						_estado_inicial:=Estados.Idle,
						_texto_url:= "https://texto.com") -> Aba:
	# cria uma aba
	var essa_cena := load("res://scene/Navegador/Aba.tscn")
	var aba: Aba = essa_cena.instantiate()
	# ajusta os parametros
	aba.titulo = _titulo
	aba.fechavel = _fechavel
	aba.estado_inicial = _estado_inicial
	aba.texto_url = _texto_url
	# retorna a aba criada
	return aba

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

## Chamar ao clicar para visualizar o conteudo da aba
func entrar_aba() -> void:
	mudar_estado(Estados.Foco)
	button_fechar.visible = fechavel

## Chamar ao sair da aba atual, para visualizar outra aba
func sair_aba() -> void:
	mudar_estado(Estados.Idle)
	button_fechar.visible = false

# muda a cor da aba dependendo do estado recebido
func mudar_estado(novo_estado : Estados) -> void:
	color_rect.color = cores_aba[novo_estado]

# chamado ao apertar o botao de fechar a aba
func _on_button_fechar_pressed() -> void:
	# emite o sinal de fechada ao pressionar
	emit_signal("fechada")

# detectar o click na aba, para clicar e entrar em uma aba
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			aba_clicada()
