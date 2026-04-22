class_name LinhasSelectQuadrado
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

## Cria o quadrado roxo em volta da imagem
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

func desenhar_posicoes(lista: Array) -> void:
	# tamanho da imagem (para converter de [0, 1] para o tam da imagem
	var size_img := pos_end - pos_start
	# para cada quadrado na lista
	for quad: Array in lista:
		# cria uma line2D para esse quadrado
		var line := Line2D.new()
		add_child(line)
		line.width = 3
		line.default_color = Color.from_hsv(randf(), 1.0, 1.0)
		# pega os pontos de comeco e fim, e cria os 4 cantos
		var pontos = _get_pontos_quadrado(quad[0], quad[1])
		for p in pontos:
			p = pos_start + (p * size_img)
			line.add_point(p)

# retorna os 4 cantos do quadrado, dado comeco (esq cima) e fim (direita baixo)
func _get_pontos_quadrado(comeco : Vector2, fim : Vector2) -> Array:
	return [
		Vector2(comeco.x, comeco.y),	# top esq
		Vector2(fim.x, comeco.y), 		# top dir
		Vector2(fim.x, fim.y), 			# bot dir
		Vector2(comeco.x, fim.y),		# bot esq
		# repetido do primeiro, para fechar o quadrado
		Vector2(comeco.x, comeco.y), 	# top esq
	]

# Clicar aumenta em 1 o valor que tem no quadrado
@onready var mini_game_select_quadrados: Control = $"../.."
func click(pos: Vector2) -> void:
	
	#line_2d.add_point(pos)
	
	# pega o quadrado
	var quad_tree : QuadTree = mini_game_select_quadrados.quad_tree
	# converte a global_pos do mouse para o [0.0, 1.0] do quad tree
	var pos_quad : Vector2 = (pos - pos_start) / (pos_end - pos_start)
	# pega o valor, se nao tiver, valor = 1
	var valor = quad_tree.get_dados(pos_quad)
	if not valor: valor = 1
	# printa o valor e insere +1 dps
	print("Valor no quad: %d" % valor)
	quad_tree.inserir_dados(valor+1, pos_quad)

func _processar_click(pos: Vector2) -> void:
	# ignora se estiver fora da imagem
	if pos.y < pos_start.y: return 
	if pos.y > pos_end.y: return 
	if pos.x < pos_start.x: return 
	if pos.x > pos_end.x: return 
	# se estiver dentro da imagem
	click(pos)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_processar_click(event.global_position)
