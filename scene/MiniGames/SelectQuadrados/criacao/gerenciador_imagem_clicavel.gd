@tool
class_name GerenciadorImagemClicavel
extends Node2D

@export  var gerenciador_quadTree: GerenciadorQuadTree
## Imagem que o jogador vai clicar
#@export var imagem_verificador: Sprite2D
@export var colisor_imagem : CollisionShape2D

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
var max_corretas_nao_clicadas: int
var max_nao_corretas_clicadas: int
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_processar_click(event.global_position)

func _ready() -> void:
	# Codigo que so eh rodado como tool do editor
	if Engine.is_editor_hint(): 
		_tool_ready()
		return

	# certificar que estao na posicao correta
	for c: Node2D in get_children():
		assert(c.position == Vector2.ZERO, "Nodo %s nao esta na origem da Imagem (position != (0,0)), pode causar problemas" % c.name)
	
	# ajusta os dados relacionados ao tamanho da imagem
	ajustar_dados_tamanho_imagem()
	# carrega os dados
	_load_dados_level()
	# mostra os quadrados que sao visiveis
	desenhar_quadrados_visiveis(quadTree)


## Ajusta os dados relacionados ao tamanho da imagem
## 		Chamar antes de qualquer desenhar quadrados na imagem, pois precisa dos dados
func ajustar_dados_tamanho_imagem() -> void:
	var rect : Rect2 = colisor_imagem.shape.get_rect()
	var tamanho = rect.size
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
	max_corretas_nao_clicadas = gerenciador_quadTree.get_max_corretas_nao_clicadas()
	max_nao_corretas_clicadas = gerenciador_quadTree.get_max_nao_corretas_clicadas()
	

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
# Conclusao

func verificar_concluido() -> void:
	if is_level_concluido():
		print("concluido")

func is_level_concluido() -> bool:
	var diferenca: int = quadTree.get_dif_selecoes_marcadas_corretas()
	# -1 se correto, 		mas 	nao selecionado
	#  0 se correto 		e 		selecionado
	#  1 se nao correto, 	mas 	selecionado 
	
	# todas as corretas foram clicadas (e nenhuma errada foi selecionada)
	if diferenca == 0:
		return true
	
	# corretas que nao foram selecionadas (diferenca negativa)
	var corretas_ainda_serem_selecionadas: bool = diferenca < 0
	# se corretas que nao foram selecionadas
	if corretas_ainda_serem_selecionadas:
		# e quantidade delas esta dentro do previsto, retorne true
		if abs(diferenca) < max_corretas_nao_clicadas:
			return true
	# se mais quadrados foram selecionados alem das corretas
	else:
		# e quantidade delas esta dentro do previsto
		if abs(diferenca) < max_nao_corretas_clicadas:
			return true
	return false


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

func _tool_ready() -> void:
	pass
