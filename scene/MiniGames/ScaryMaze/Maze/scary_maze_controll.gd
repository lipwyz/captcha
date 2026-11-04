class_name ScaryMaze
extends Node2D

signal falhou
signal ganhou

@onready var area_2d_inicio: Area2D = $Area2DInicio
@onready var area_2d_vitoria: Area2D = $Area2DVitoria

@onready var controlador_tile_map: ControladorTileMap = $TileMapLayer
@onready var mouse_detector: MouseDetector = $mouseDetector

@onready var label_start: Label = $Area2DInicio/LabelStart

@onready var area_2d_check_point: Area2D = $Area2DCheckPoint
@onready var area_2d_check_point_2: Area2D = $Area2DCheckPoint2
@onready var label_check_point_start: Label = $Area2DCheckPoint/LabelCheckPointStart
@onready var label_check_point_2_start: Label = $Area2DCheckPoint2/LabelCheckPoint2Start

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
	area_2d_inicio.mouse_entered.connect(spawn_point)
	area_2d_inicio.area_entered.connect(func(_x): spawn_point() )
	# vitoria
	area_2d_vitoria.mouse_entered.connect(ganhar)
	area_2d_vitoria.area_entered.connect(func(_x): ganhar() )
	# check points
	area_2d_check_point.mouse_entered.connect(check1)
	area_2d_check_point.area_entered.connect(func(_x): check1() )
	area_2d_check_point_2.mouse_entered.connect(check2)
	area_2d_check_point_2.area_entered.connect(func(_x): check2() )
	
	# conecta os sinais de mouse entrou no local de falha
	controlador_tile_map.tile_entered.connect(entered)
	mouse_detector.collided.connect(entered)
	
	_display_iniciado_text()

var esta_cooldown_iniciar: bool = false

func iniciar() -> void:
	if iniciado: return
	
	if esta_cooldown_iniciar: return 
	# espera um 1 segundo para desligar o cooldown
	esta_cooldown_iniciar = true
	get_tree().create_timer(0.5).timeout.connect(
		func(): esta_cooldown_iniciar = false
	)
	
	iniciado = true

func entered():
	if not iniciado: return
	falhar()

func falhar() -> void:
	if not iniciado: return
	
	# TODO: esse fix eh temporario pq se a pessoa for mt rapido para o fim,
	# ela pode ganhar
	if esta_cooldown_iniciar: return
	
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
	label_start.hide()
	label_check_point_start.hide()
	label_check_point_2_start.hide()
	
	if iniciado: return
	
	match (local_inicio):
		LocaisInicios.SPAWN:
			label_start.show()
		LocaisInicios.CHECK_1:
			label_check_point_start.show()
		LocaisInicios.CHECK_2:
			label_check_point_2_start.show()

enum LocaisInicios {SPAWN, CHECK_1, CHECK_2}
var local_inicio := LocaisInicios.SPAWN

func spawn_point() -> void:
	# se nao for o local atual aqui, pare
	if local_inicio != LocaisInicios.SPAWN:
		return
	# se nao tiver rolando, inicie
	if not iniciado:
		iniciar()

func check1() -> void:
	# se o jogo rolando, marque o spawn
	if iniciado:
		local_inicio = LocaisInicios.CHECK_1
	# se jogo nao rolando, mas o spawn for aqui, inicia do spawn
	elif local_inicio == LocaisInicios.CHECK_1:
		iniciar()

func check2() -> void:
	# se o jogo rolando, marque o spawn
	if iniciado:
		local_inicio = LocaisInicios.CHECK_2
	# se jogo nao rolando, mas o spawn for aqui, inicia do spawn
	elif local_inicio == LocaisInicios.CHECK_2:
		iniciar()
