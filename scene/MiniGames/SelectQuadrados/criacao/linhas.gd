class_name LinhasSelectQuadrado
extends Node2D


@export  var gerenciador_quadTree: GerenciadorQuadTree
## Imagem que o jogador vai clicar
@export var imagem_verificador: Sprite2D
## Line2D de referencia para criar as outras linhas
@onready var referencia_line_2d: Line2D = $ReferenciaLine2D

var pos_start : Vector2
var pos_end   : Vector2

func _ready() -> void:
	referencia_line_2d.hide()
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	
	var tamanho = imagem_verificador.region_rect.size
	#tamanho *= imagem_verificador.scale
	
	var pos_base := imagem_verificador.global_position - global_position
	pos_start = pos_base
	pos_end   = pos_base + tamanho
	
	desenhar_quadrados()

func desenhar_quadrados() -> void:
	var lista_comeco_fim := gerenciador_quadTree.quadTree.mostrar_quadrados()
	for comeco_fim : Array[Vector2] in lista_comeco_fim:
		var comeco	:= comeco_fim[0]
		var fim 	:= comeco_fim[1]
		var cantos = gerenciador_quadTree.quadTree.get_cantos_quadrado(comeco, fim)
		## repete o primeiro para fechar o quadrado
		#cantos.append(cantos[0])
		# desenha o quadrado
		desenhar_posicoes(cantos) 
	
	#var dimensoes := gerenciador_quadTree.quadTree.get_dimensoes_nodos_com_dados(FL)
	
	
	
	
	## [comeco, fim, [filhos]]
	#var dimensoes := gerenciador_quadTree.quadTree.get_all_dimensoes()
	## ignora o root (que tem comeco 0.0 e fim 1.0)
	#dimensoes.remove_at(0)
	#dimensoes.remove_at(0)
	## para cada filho
	#for dimensao_filhos : Array in dimensoes:
		#print(dimensao_filhos)

func desenhar_posicoes(pontos: Array) -> void:
	# tamanho da imagem (para converter de [0, 1] para o tam da imagem
	var size_img := pos_end - pos_start
	
	var line : Line2D = referencia_line_2d.duplicate()
	line.clear_points()
	
	# cria uma line2D para esse quadrado
	#var line := Line2D.new()
	add_child(line)
	line.show()
	#line.width = 3
	#line.default_color = Color.from_hsv(randf(), 1.0, 1.0)
	
	for p in pontos:
		p = pos_start + (p * size_img)
		line.add_point(p)

# Clicar aumenta em 1 o valor que tem no quadrado
func click(pos: Vector2) -> void:
	
	#line_2d.add_point(pos)
	
	# pega o quadrado
	var quad_tree : QuadTree = gerenciador_quadTree.quadTree
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
