class_name MundoMario
extends Node2D

signal ganhou
signal morreu

@onready var coletavel: Area2D = $Coletavel
@onready var zona_morte: Area2D = $ZonaMorte
@onready var jogador: CharacterBody2D = $Jogador
@onready var spawn_jogador: Node2D = $SpawnJogador

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

func _coletar(_body : Node) -> void:
	coletavel.hide()
	await get_tree().create_timer(0.2).timeout
	ganhou.emit()

func _morrer(_body : Node) -> void:
	if imortal: return
	
	morreu.emit()
