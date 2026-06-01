class_name MundoMario
extends Node2D

signal ganhou
signal morreu
signal acabou_vidas

@export var numero_vidas: int = 3

@onready var coletavel: Area2D = $Coletavel
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
	coletavel.body_entered.connect(_coletar)
	zona_morte.body_entered.connect(_morrer)
	# 
	vidas = [coracao_1]
	while vidas.size() < numero_vidas:
		var nova_vida = coracao_1.duplicate()
		add_child(nova_vida)
		nova_vida.position.x += vidas.size() * 120
		vidas.append(nova_vida)

func _coletar(_body : Node) -> void:
	coletavel.hide()
	await get_tree().create_timer(0.2).timeout
	ganhou.emit()

func _morrer(_body : Node) -> void:
	if imortal: return
	
	# retira uma vida
	vidas.pop_back().queue_free()
	# fim de jogo
	if vidas.is_empty():
		acabou_vidas.emit()
		return
	# morreu, respawn
	morreu.emit()
