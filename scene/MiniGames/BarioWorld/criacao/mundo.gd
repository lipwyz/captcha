class_name MundoMario
extends Node2D

signal ganhou
signal morreu
signal acabou_vidas
signal mostrar_anuncio

@export var numero_vidas: int = 3
@export var lista_coletaveis_anuncio: Array[Area2D]

@onready var coletavel_fim: Area2D = $ColetavelFim
@onready var zona_morte: Area2D = $ZonaMorte
@onready var jogador: CharacterBody2D = $Jogador
@onready var spawn_jogador: Node2D = $SpawnJogador
@onready var coracao_1: Sprite2D = $Coracao_1

var vidas : Array[Sprite2D]

var imortal: bool = false :
	set(_imortal):
		imortal = _imortal
		await get_tree().create_timer(0.5).timeout
		imortal = false

func spawn() -> void:
	imortal = true
	jogador.velocity = Vector2.ZERO
	jogador.global_position = spawn_jogador.global_position

func _ready() -> void:
	coletavel_fim.body_entered.connect(_coletar_fim)
	zona_morte.body_entered.connect(_morrer)
	# ajustar vidas
	vidas = [coracao_1]
	while vidas.size() < numero_vidas:
		var nova_vida = coracao_1.duplicate()
		add_child(nova_vida)
		nova_vida.position.x += vidas.size() * 120
		vidas.append(nova_vida)
	# ajustar os coletaveis de anuncio
	for coletavel_ad: Area2D in lista_coletaveis_anuncio:
		coletavel_ad.body_entered.connect(_coletar_ad.bind(coletavel_ad))

func _coletar_fim(_body : Node) -> void:
	coletavel_fim.hide()
	await get_tree().create_timer(0.2).timeout
	ganhou.emit()

func _coletar_ad(_body : Node, coletavel_ad: Area2D) -> void:
	coletavel_ad.queue_free()
	mostrar_anuncio.emit()

func _morrer(_body : Node) -> void:
	if imortal: return
	
	# retira uma vida
	var vida_perdida : Sprite2D = vidas.pop_back()
	# sem vidas, fim de jogo
	if vidas.is_empty():
		acabou_vidas.emit()
		return
	# morreu, respawn
	morreu.emit()
	vida_perdida.queue_free()
