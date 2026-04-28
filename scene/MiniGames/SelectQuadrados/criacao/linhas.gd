class_name LinhasSelectQuadrado
extends Node2D

@export  var gerenciador_quadTree: GerenciadorQuadTree
## Imagem que o jogador vai clicar
#@export var imagem_verificador: Sprite2D
@export var colisor_imagem : CollisionShape2D

@export_category("Referencias")
## Line2D de referencia para criar as outras linhas
@export var referencia_line_2d: Line2D
## Line2D de referencia para criar as caixas de selecionado
@export var referencia_polygon_2d: Polygon2D

# Posicoes de comeco e fim da imagem
var pos_start : Vector2
var pos_end   : Vector2
var size_img  : Vector2
var div_size_img  : Vector2

func _ready() -> void:
	referencia_line_2d.hide()
	
	# TODO: tirar isso
	await get_tree().process_frame
	await get_tree().process_frame
	
	ajustar_tamanho_imagem()
	desenhar_quadrados()

func ajustar_tamanho_imagem() -> void:
	var rect : Rect2 = colisor_imagem.shape.get_rect()
	var tamanho = rect.size
	var pos_base := Vector2.ZERO
	pos_start = pos_base
	pos_end   = pos_base + tamanho
	# tamanho da imagem, para usar na conversao de [0, 1] -> [0, tamanho da imagem]
	size_img = pos_end - pos_start
	div_size_img = Vector2.ONE / size_img

func desenhar_quadrados() -> void:
	# limpa qualquer filho que tenha
	for c in get_children():
		c.queue_free()
	
	# percorre a lista de quadrados e desenha eles
	var lista_comeco_fim := gerenciador_quadTree.quadTree.get_dimensoes_visiveis()
	for comeco_fim_selecionado : Array in lista_comeco_fim:
		var comeco	:Vector2   = comeco_fim_selecionado[0]
		var fim 	:Vector2   = comeco_fim_selecionado[1]
		var selecionado : bool = comeco_fim_selecionado[2]
		var cantos = gerenciador_quadTree.quadTree.get_cantos_quadrado(comeco, fim)
		# desenha o quadrado
		desenhar_linhas_quadrado(cantos) 
		# se esetiver selecionado marcao o quadrado
		if selecionado:
			desenhar_interior_quadrado(cantos)

func desenhar_interior_quadrado(cantos_quadrado: Array) ->void:
	# faz uma copia do polygono de referencia
	var polygon : Polygon2D = referencia_polygon_2d.duplicate()
	# adiciona na cena
	add_child(polygon)
	# adiciona os pontos
	var cantos : Array[Vector2] = []
	for ponto in cantos_quadrado:
		cantos.append(_converter_ponto_quadTree_para_imagem(ponto))
	polygon.polygon = PackedVector2Array(cantos)
	polygon.show()

func desenhar_linhas_quadrado(cantos_quadrado: Array) -> void:
	# faz uma copia da linha de referencia
	var line : Line2D = referencia_line_2d.duplicate()
	line.clear_points()
	# adiciona na cena
	add_child(line)
	# coloca os pontos no quadrado
	_adicionar_pontos_linha(line, cantos_quadrado)
	line.show()

func _adicionar_pontos_linha(line : Line2D, cantos_quadrado: Array[Vector2]) -> void:
	line.clear_points()
	# coloca os pontos do quadrado
	for ponto : Vector2 in cantos_quadrado:
		line.add_point(_converter_ponto_quadTree_para_imagem(ponto))

func _converter_ponto_quadTree_para_imagem(ponto_quad: Vector2) -> Vector2:
	return pos_start + (ponto_quad * size_img)

func click(pos: Vector2) -> void:
	# pega o quadrado
	var quad_tree : QuadTree = gerenciador_quadTree.quadTree
	# converte a global_pos do mouse para o [0.0, 1.0] do quad tree
	var pos_quad : Vector2 = (pos - pos_start) * div_size_img
	
	## pega o valor do tamanho do quadrado
	#var valor = quad_tree.get_dados(pos_quad)
	## se nao tiver valor, coloque 1
	#if not valor: valor = 1
	## printa o valor e insere +1 dps
	#print("Valor no quad: %d" % valor)
	#quad_tree.inserir_dados(valor+1, pos_quad)
	
	quad_tree.print_id(pos_quad)
	quad_tree.deixar_filho_visivel(pos_quad)
	quad_tree.marcar_selecionado(pos_quad)
	
	desenhar_quadrados()

func _processar_click(pos: Vector2) -> void:
	# converte da poiscao global -> posicao local
	pos = to_local(pos)
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
