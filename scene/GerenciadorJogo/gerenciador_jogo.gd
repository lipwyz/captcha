class_name GerenciadorJogo
extends Node

@export var navegador: Navegador
@export var area_trabalho: AreaTrabalho

func _ready() -> void:
	_conectar_sinais()

# -----------------------------------------------------------------------------
# Conectar os sinais
# -----------------------------------------------------------------------------
func _conectar_sinais() -> void:
	area_trabalho.click_navegador.connect(_abrir_navegador)

func _abrir_navegador() -> void:
	navegador.abrir()
