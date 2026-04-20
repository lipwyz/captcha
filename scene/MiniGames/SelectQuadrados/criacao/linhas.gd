extends Node2D

## Imagem que o jogador vai clicar
@export var imagem_verificador: Sprite2D
## Profundidade da quantidade de camadas
@export var profundidade : int = 3

@onready var line_2d: Line2D = $Line2D

var pos_start : Vector2
var pos_end   : Vector2

func _ready() -> void:
	criar_linhas()

func criar_linhas() -> void:
	#var tamanho = Vector2(
		#imagem_verificador.texture.get_width(), 
		#imagem_verificador.texture.get_height()
	#) * imagem_verificador.scale
	var tamanho = imagem_verificador.region_rect.size
	tamanho *= imagem_verificador.scale
	
	var pos_base := imagem_verificador.global_position - line_2d.global_position
	
	pos_start = pos_base
	pos_end   = pos_base + tamanho
	
	line_2d.add_point(pos_start)
	line_2d.add_point(pos_end)

func click(pos: Vector2) -> void:
	
	line_2d.add_point(pos)

func _processar_click(pos: Vector2) -> void:
	# ignora se estiver fora da imagem
	if pos.y < pos_start.y: return 
	if pos.y > pos_end.y: return 
	if pos.x < pos_start.x: return 
	if pos.x > pos_end.x: return 
	# se estiver dentro dda imagem
	click(pos)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_processar_click(event.global_position)
