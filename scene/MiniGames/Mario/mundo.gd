extends Node2D
class_name MundoMario

signal perdeu
signal ganhou

@onready var coletavel: Area2D = $Coletavel
@onready var zona_morte: Area2D = $ZonaMorte
@onready var jogador: CharacterBody2D = $Jogador

func _ready() -> void:
	coletavel.body_entered.connect(_coletar)
	zona_morte.body_entered.connect(_morrer)

func _coletar(_body : Node) -> void:
	await get_tree().create_timer(0.3).timeout
	emit_signal("ganhou")

func _morrer(_body : Node) -> void:
	await get_tree().create_timer(0.3).timeout
	emit_signal("perdeu")
