class_name MundoQuebraCabeca
extends Node2D

signal completou
signal falhou
signal errou

@export var imagem_ref : Sprite2D
@export var quantidade_divisoes := Vector2i(3,3)

var blocos: Array[Sprite2D]

func _ready() -> void:
	iniciar()

func iniciar() -> void:
	blocos.resize(quantidade_divisoes.y * quantidade_divisoes.x)
	
	var block_size: Vector2 = imagem_ref.texture.get_size() / Vector2(quantidade_divisoes)
	
	print(block_size)
	print()
	
	for y in range(quantidade_divisoes.y):
		for x in range(quantidade_divisoes.x):
			var bloco := imagem_ref.duplicate()
			add_child(bloco)
			bloco.region_enabled = true
			bloco.region_rect = Rect2(
				Vector2i(block_size.x * x, block_size.y * y),
				Vector2i(block_size.x * (x+1), block_size.y * (y+1))
			)
			
			bloco.position = Vector2(block_size.x * x, block_size.y * y)
			bloco.position.x += randf_range(-10, 10)
			bloco.position.y += randf_range(-10, 10)
