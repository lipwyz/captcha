@tool
class_name GerenciadorImagemClicavel
extends Node2D

signal concluido

@export var gerenciador_quadTree: GerenciadorQuadTree
## Imagem que o jogador vai clicar
@export var sprite_imagem : Sprite2D

@export var pai_linhas: Node2D

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

var quadTree : QuadTreeSelecao
# dados de calculo de final de level
var max_falta_selecionar_corretas: int
var max_selecoes_nao_corretas: int
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_processar_click(event.global_position)

func _ready() -> void:
	# nao rodar ready no editor
	if Engine.is_editor_hint():  return

	# certificar que estao na posicao correta
	for c: Node2D in get_children():
		assert(c.position == Vector2.ZERO, "Nodo %s nao esta na origem da Imagem (position != (0,0)), pode causar problemas" % c.name)
	
	# carrega os dados
	_load_dados_level()
	# mostra os quadrados que sao visiveis
	desenhar_quadrados_visiveis(quadTree)


## Ajusta os dados relacionados ao tamanho da imagem
## 		Chamar antes de qualquer desenhar quadrados na imagem, pois precisa dos dados
func ajustar_dados_tamanho_imagem() -> void:
	var rect : Rect2 = sprite_imagem.get_rect()
	var tamanho = rect.size * sprite_imagem.scale
	var pos_base := Vector2.ZERO
	pos_start = pos_base
	pos_end   = pos_base + tamanho
	# tamanho da imagem, para usar na conversao de [0, 1] -> [0, tamanho da imagem]
	size_img = pos_end - pos_start
	div_size_img = Vector2.ONE / size_img

func _load_dados_level() -> void:
	# load quadTree
	gerenciador_quadTree.load_quadTree()
	quadTree = gerenciador_quadTree.quadTree
	# load valores de concluir level
	max_falta_selecionar_corretas = gerenciador_quadTree.get_max_falta_selecionar_corretas()
	max_selecoes_nao_corretas = gerenciador_quadTree.get_max_selecoes_nao_corretas()
	
	##
	var level_res: MG_SelecaoDefinicoesRes = gerenciador_quadTree.quadTree_resource
	set_imagem(level_res.imagem_texture, level_res.imagem_scale, level_res.imagem_region_rect)
	
	# ajusta os dados relacionados ao tamanho da imagem
	ajustar_dados_tamanho_imagem()

#------------------------------------------------------------------------------
# Desenha Quadrados

## Desenha somente os quadrados que sao visiveis
func desenhar_quadrados_visiveis(_quadTree: QuadTreeSelecao) -> void:
	var lista_comeco_fim_selecionado := _quadTree.get_dimensoes_visiveis()
	desenhar_quadrados(lista_comeco_fim_selecionado)

## Desenha todos os quadradinhos dos nodo folhas (independente de ser visiveis)
func desenhar_quadrados_all(_quadTree: QuadTreeSelecao) -> void:
	var lista_comeco_fim_selecionado := _quadTree.get_dimensoes_all_folhas()
	desenhar_quadrados(lista_comeco_fim_selecionado)

# -----  ------------------------------------------------------------------
func desenhar_quadrados(lista_comeco_fim_selecionado: Array[Array]) -> void:
	# limpa qualquer filho que tenha
	for c in pai_linhas.get_children():
		c.queue_free()

	# percorre a lista de quadrados e desenha eles
	for comeco_fim_selecionado : Array in lista_comeco_fim_selecionado:
		var comeco	:Vector2   = comeco_fim_selecionado[0]
		var fim 	:Vector2   = comeco_fim_selecionado[1]
		var selecionado : bool = comeco_fim_selecionado[2]
		var cantos = QuadTreeSelecao.get_cantos_quadrado(comeco, fim)
		# desenha o quadrado
		desenhar_linhas_quadrado(cantos) 
		# se esetiver selecionado marcao o quadrado
		if selecionado:
			desenhar_interior_quadrado(cantos)

func desenhar_interior_quadrado(cantos_quadrado: Array) ->void:
	# faz uma copia do polygono de referencia
	var polygon : Polygon2D = referencia_polygon_2d.duplicate()
	# adiciona na cena
	pai_linhas.add_child(polygon)
	# adiciona os pontos
	var cantos : Array[Vector2] = []
	for ponto in cantos_quadrado:
		cantos.append(_converter_ponto_quadTree_para_tela(ponto))
	polygon.polygon = PackedVector2Array(cantos)

func desenhar_linhas_quadrado(cantos_quadrado: Array) -> void:
	# faz uma copia da linha de referencia
	var line : Line2D = referencia_line_2d.duplicate()
	line.clear_points()
	# adiciona na cena
	pai_linhas.add_child(line)
	# coloca os pontos no quadrado
	_adicionar_pontos_linha(line, cantos_quadrado)

func _adicionar_pontos_linha(line : Line2D, cantos_quadrado: Array[Vector2]) -> void:
	line.clear_points()
	# coloca os pontos do quadrado
	for ponto : Vector2 in cantos_quadrado:
		line.add_point(_converter_ponto_quadTree_para_tela(ponto))

#------------------------------------------------------------------------------
# Lidar com Clicks

func click(pos: Vector2) -> void:
	# converte para ponto da quadTree
	var pos_quad : Vector2 = _converter_ponto_tela_para_quadTree(pos)
	
	# selecionar os quadrados
	quadTree.deixar_filho_visivel(pos_quad)
	quadTree.toggle_selecionado(pos_quad)
	# desenha os quadrados visiveis
	desenhar_quadrados_visiveis(quadTree)
	
	# verifica se concluiu clicando em todos
	verificar_concluido()

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

#------------------------------------------------------------------------------
# Set Imagem

func set_imagem(_texture: Texture2D,
				_scale: Vector2 = Vector2.ONE,
				region_rect: Rect2 = Rect2(0,0,0,0)
				) -> void:
	sprite_imagem.texture = _texture
	sprite_imagem.scale = _scale
	
	# region rect no esta fazio
	if region_rect.size > Vector2.ONE:
		sprite_imagem.region_enabled = true
		sprite_imagem.region_rect = region_rect
	else:
		sprite_imagem.region_enabled = false
		region_rect = Rect2(
			Vector2.ZERO,
			sprite_imagem.texture.get_size()
		)
	
	#colisor_imagem.shape.size = region_rect.size
	#colisor_imagem.shape.size -= region_rect.position
	
#------------------------------------------------------------------------------
# Conclusao

func verificar_concluido() -> void:
	if is_level_concluido():
		concluido.emit()

func is_level_concluido() -> bool:
	if quadTree.qtd_falta_selecionar_corretas() > max_falta_selecionar_corretas:
		return false
	if quadTree.qtd_selecoes_nao_corretas() > max_selecoes_nao_corretas:
		return false
	return true


#------------------------------------------------------------------------------
# Conversores

## Converte ponto [0.0, 1.0] da quadTree para a posicao global
func _converter_ponto_quadTree_para_tela(ponto_quad: Vector2) -> Vector2:
	return pos_start + (ponto_quad * size_img)

## Converte a global_pos do mouse para o [0.0, 1.0] da quadTree
func _converter_ponto_tela_para_quadTree(ponto_tela: Vector2) -> Vector2:
	return (ponto_tela - pos_start) * div_size_img

#------------------------------------------------------------------------------
# TOOL

func tool_ready() -> void:
	# carrega os dados
	_load_dados_level()
	
	# altera a quadTree para ser toda visivel
	quadTree.deixar_all_visiveis()
	
	# mostra os corretos - na forma -> selecionados
	for p : Vector2 in quadTree.get_posicao_all_nodos_folha_corretos():
		quadTree.marcar_selecionado(p)
	
	# desenha todos os quadrados
	desenhar_quadrados_all(quadTree)
