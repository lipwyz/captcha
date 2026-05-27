class_name ImagemAnuncio
extends Node

@export var sprite_imagem: Sprite2D

func get_tamanho_sprite() -> Vector2:
	if not sprite_imagem: 
		push_error("Sprite da imagem do anuncio nao ajustada")
		return Vector2(100,100)
	var tam := sprite_imagem.position * 2
	return tam
