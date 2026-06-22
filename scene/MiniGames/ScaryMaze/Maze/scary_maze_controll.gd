class_name ScaryMaze
extends Node2D

signal falhou
signal ganhou

@onready var area_2d_inicio: Area2D = $Area2DInicio
@onready var area_2d_vitoria: Area2D = $Area2DVitoria

@onready var controlador_tile_map: ControladorTileMap = $TileMapLayer
@onready var mouse_detector: MouseDetector = $mouseDetector

@onready var label_start: Label = $Area2DInicio/LabelStart

## Ja ganhou o jogo, e por tanto nao precisa emitir vitoria novamente
var ja_ganhou: bool = false

## Marca se o jogo esta rodando atualmente [br]
## [code]True[/code] para o jogo que ja foi iniciado [br]
## [code]False[/code] caso o jogo ainda nao tenha sido iniciado, e por tanto
## nao deve emitir falhas e spawnar anuncios
var iniciado: bool = false :
	set(_iniciado):
		iniciado = _iniciado
		controlador_tile_map.set_iniciado(_iniciado)
		_display_iniciado_text()

func _ready() -> void:
	# condicao de inicio
	area_2d_inicio.mouse_entered.connect(iniciar)
	area_2d_inicio.area_entered.connect(func(_x): iniciar() )
	# vitoria
	area_2d_vitoria.mouse_entered.connect(ganhar)
	area_2d_vitoria.area_entered.connect(func(_x): ganhar() )
	# conecta os sinais de mouse entrou no local de falha
	controlador_tile_map.tile_entered.connect(entered)
	mouse_detector.collided.connect(entered)

func iniciar() -> void:
	if iniciado: return
	iniciado = true

func entered():
	if not iniciado: return
	falhar()

func falhar() -> void:
	if not iniciado: return
	# emite que errou
	falhou.emit()
	# tem que reiniciar
	iniciado = false

func ganhar() -> void:
	if not iniciado: return
	# emite o sinal de vitoria apenas a primeira vez
	if ja_ganhou: return
	ja_ganhou = true
	
	# emite que ganhou
	ganhou.emit()
	# desativa o jogo
	iniciado = false
	label_start.visible = false

func _display_iniciado_text() -> void:
	label_start.visible = not iniciado
