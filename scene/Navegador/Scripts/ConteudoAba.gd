class_name ConteudoAba
extends Control

signal minigame_ganhou
signal minigame_perdeu
signal minigame_errou

func minigame_ganhar() -> void:
	minigame_ganhou.emit()

func minigame_perder() -> void:
	minigame_perdeu.emit()

func minigame_errar() -> void:
	minigame_errou.emit()
