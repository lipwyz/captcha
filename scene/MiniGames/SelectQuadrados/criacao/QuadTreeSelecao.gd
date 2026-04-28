@tool
class_name QuadTreeSelecao
extends QuadTree

const FLAG_CORRETO 		:= 1
const FLAG_SELECIONADO	:= 2
const FLAG_SHOW_FILHOS 	:= 4

const VALOR_FLAGS_INICIAL := 0

func _init(_profundidade: int) -> void:
	root = QuadTreeSelecaoNode.new(Vector2.ZERO, Vector2.ONE, _profundidade, "0")
	# mostra somente a primeira camada de quadrados (filhos diretos do root)
	root.dados = FLAG_SHOW_FILHOS

func print_id(posicao: Vector2) -> void:
	root.print_id(posicao)

## Mostra as dimensoes dos somente dos filhos dos nodos que tem FLAG_SHOW_FILHOS
## Retorna lista com itens [comeco, fim, selecionado]
func get_dimensoes_visiveis() -> Array[Array]:
	return root.get_dimensoes_visiveis()

## Mostra as dimensoes de todos os nodos folha
## Retorna lista com itens [comeco, fim, selecionado]
func get_dimensoes_all_folhas() -> Array[Array]:
	return root.get_dimensoes_all_folhas()

## Percorre os filhos visiveis ate o primeiro filho que nao eh visivel
## 		entao marca seus filhos como visivel
func deixar_filho_visivel(posicao: Vector2) -> void:
	root.deixar_filho_visivel(posicao)

## Marca com FLAG_SELECIONADO os nodo folha que sao filhos visiveis.
## 		Para nodos que nao sao visiveis nao acontece nada
func marcar_selecionado(posicao: Vector2) -> void:
	root.selecionar_folha_visivel(posicao)

## Marca com FLAG_SELECIONADO os nodo folha que sao filhos visiveis.
## 		Para nodos que nao sao visiveis nao acontece nada
func toggle_selecionado(posicao: Vector2) -> void:
	root.toggle_selecionar_folha_visivel(posicao)

## Marca com FLAG_CORRETO os nodo folha na posicao
func marcar_correto(posicao: Vector2) -> void:
	root.set_folha_flag(FLAG_CORRETO, true, posicao)

## Retorna a diferenca entre FLAG_SELECIONADO e FLAG_CORRETO em todos os nodos folha
## Para cada nodo:
##	-1 se correto, 		mas 	nao selecionado
##	 0 se correto 		e 		selecionado
##	 1 se nao correto, 	mas 	selecionado 
##	 0 se nao correto, 	e 		nao selecionado
func get_dif_selecoes_marcadas_corretas() -> int:
	return root.get_dif_selecoes_marcadas_corretas()
# ---------------------------------------------------------------------------------------------------

## Set nodo folha na posicao, como FLAG_CORRETO
func set_valido(posicao: Vector2) -> void:
	root.inserir_dados(FLAG_CORRETO, posicao)

## Retorna os dados guardados em um nodo folha na dada posicao
func get_dados(posicao: Vector2) -> Variant:
	return root.get_dados(posicao)

## Insere dados em um nodo folha na dada posicao
func inserir(dados, posicao: Vector2) -> void:
	root.inserir(dados, posicao)

func _set_valor_inicial_todos_nodos(valor: int) -> void:
	root.inserir_dados_nodo_e_filhos(valor)

func get_posicao_all_nodos_folha_corretos() -> Array[Vector2]:
	return root.get_posicao_all_nodos_folha_corretos()

func set_all_nodos_folha_corretos(posicoes: Array[Vector2]) -> void:
	for pos : Vector2 in posicoes:
		root.inserir_dados(FLAG_CORRETO, pos)

## Retorna os 4 cantos do quadrado, dado comeco (esq cima) e fim (direita baixo)
static func get_cantos_quadrado(comeco : Vector2, fim : Vector2) -> Array[Vector2]:
	return [
		Vector2(comeco.x, comeco.y),	# top esq
		Vector2(fim.x, comeco.y), 		# top dir
		Vector2(fim.x, fim.y), 			# bot dir
		Vector2(comeco.x, fim.y),		# bot esq
	]

# -----------------------------------------------------------------------------
# class QuadTreeSelecaoNode
# -----------------------------------------------------------------------------
class QuadTreeSelecaoNode extends QuadTreeNode:
	# Debug: texto com a posicao do nodo 
	# top_esq	 7 | 9	 top_dir
	# 			---+---
	# bot_esq	 1 | 3	 bot_dir
	var id: String = ""
	
	# Posicao [0.0, 1.0] do comeco (top_esq) e fim (bot_dir) do nodo
	# 	para usar ao calcular dimensoes
	var pos_comeco : Vector2
	var pos_fim : Vector2
	
	## Debug: print (id) conforme vai descendo pelos filhos do nodo ate chegar no nodo folha
	func print_id(posicao: Vector2) -> void:
		print(id)
		if is_nodo_folha(): return
		_get_nodo_filho(posicao).print_id(posicao)
	
	func _init(comeco : Vector2, fim : Vector2, _profundidade : int, _id:String) -> void:
		profundidade = _profundidade
		pos_comeco = comeco
		pos_fim    = fim
		id = _id + "_"
		
		dados = VALOR_FLAGS_INICIAL
		
		# se for nodo folha (sem filhos), pare aqui
		if _profundidade == 0:
			return
		# se nodo tiver filhos, continue
		
		# calcula a posicao na metade
		pos_metade = comeco + ( (fim - comeco) * 0.5 )
		# diminui a profundidade para criar os nodos filhos
		_profundidade -= 1
		
		# cria os 4 filhos
		top_esq = QuadTreeSelecaoNode.new(comeco,
											pos_metade,
											_profundidade, 
											id + "7")
		top_dir = QuadTreeSelecaoNode.new(Vector2(pos_metade.x, comeco.y), 
											Vector2(fim.x, pos_metade.y),
											_profundidade, 
											id + "9")
		bot_esq = QuadTreeSelecaoNode.new(Vector2(comeco.x, pos_metade.y), 
											Vector2(pos_metade.x, fim.y),
											_profundidade, 
											id + "1")
		bot_dir = QuadTreeSelecaoNode.new(pos_metade, 
											fim,
											_profundidade, 
											id + "3")
	
	## Retorna a dimensao dos filhos visiveis desse nodo.
	## 	Se o nodo tem a FLAG_SHOW_FILHOS: chame essa funcao nos filhos
	## 	Se um nodo teve essa funcao chamada quer dizer que ele eh um filho visivel
	## 		Entao se foi chamado, e nenhum filho eh visivel, retorne sobre esse nodo
	func get_dimensoes_visiveis() -> Array[Array]:
		# se for nodo folha, nao tem como ter filhos visiveis, retorne a dimensao
		if is_nodo_folha():
			return get_dimensoes_nodo()
		
		var is_filhos_visiveis : bool = _get_node_flag(FLAG_SHOW_FILHOS)
		# filhos nao sao visiveis, retorne as dimensoes desse nodo e pare a funcao
		if not is_filhos_visiveis:
			return get_dimensoes_nodo()
		
		# se os filhos forem visiveis, junte as dimensoes deles num unico array
		var dimensoes_filhos : Array = (
			top_esq.get_dimensoes_visiveis()
			+ top_dir.get_dimensoes_visiveis()
			+ bot_esq.get_dimensoes_visiveis()
			+ bot_dir.get_dimensoes_visiveis()
		)
		return dimensoes_filhos
	
	func get_dimensoes_all_folhas() -> Array[Array]:
		# se for nodo folha, nao tem como ter filhos visiveis, retorne a dimensao
		if is_nodo_folha():
			return get_dimensoes_nodo()
		
		# se tem filhos, junte as dimensoes deles num unico array
		var dimensoes_filhos : Array = (
			  top_esq.get_dimensoes_all_folhas()
			+ top_dir.get_dimensoes_all_folhas()
			+ bot_esq.get_dimensoes_all_folhas()
			+ bot_dir.get_dimensoes_all_folhas()
		)
		return dimensoes_filhos
	
	## Retorne a lista com as posicoes [inicio, fim] desse nodo
	func get_dimensoes_nodo() -> Array[Array]:
		var selecionado = _get_node_flag(FLAG_SELECIONADO)
		return [[pos_comeco, pos_fim, selecionado]]
	
	## Set a flag com valor (flag_value) no nodo folha
	func set_folha_flag(flag: int, flag_value: bool, posicao: Vector2) -> void:
		if is_nodo_folha():
			_set_node_flag(flag, flag_value)
			return
		# se nao for folha, chame no filho
		_get_nodo_filho(posicao).set_folha_flag(flag, flag_value, posicao)
	
	## Retorna se Flag no nodo filho eh (true ou false)
	func get_folha_flag(flag: int, posicao: Vector2) -> bool:
		if is_nodo_folha():
			return _get_node_flag(flag)
		# se nao for folha, chame no filho
		return _get_nodo_filho(posicao).get_folha_flag(flag, posicao)
	
	## Set o valor de flag para flag_value, neste nodo 
	func _set_node_flag(flag: int, flag_value: bool) -> void:
		if flag_value:
			# se flag true -> coloca como true
			dados = dados | flag
		else:
			# se flag false -> apagar valor
			dados = dados & (~flag)
	
	## Retorna o valor de flag para este nodo
	func _get_node_flag(flag: int) -> bool:
		# se valor da flag nao eh zero
		return (dados & flag) != 0
	
	## Deixa o primeiro filho que encontra com os filhos visivel, com FLAG_SHOW_FILHOS
	func deixar_filho_visivel(posicao: Vector2) -> void:
		# se for nodo folha, nao tem como ter filhos visiveis, pare
		if is_nodo_folha(): return 
		
		var is_filhos_visiveis : bool = _get_node_flag(FLAG_SHOW_FILHOS)
		if not is_filhos_visiveis:
			# filhos nao sao visiveis, coloque que esse node tem filho visivel
			_set_node_flag(FLAG_SHOW_FILHOS, true)
		else:
			# se os filhos forem visiveis, continue
			_get_nodo_filho(posicao).deixar_filho_visivel(posicao)
	
	## Marca com FLAG_SELECIONADO os nodo folha que sao filhos visiveis.
	## 		Para nodos que nao sao visiveis nao acontece nada
	func selecionar_folha_visivel(posicao: Vector2) -> void:
		# se for nodo folha, marque como selecionado e pare
		if is_nodo_folha():
			_set_node_flag(FLAG_SELECIONADO, true)
			return
		# se nao for folha, veja se os filhos sao visiveis
		var is_filhos_visiveis : bool = _get_node_flag(FLAG_SHOW_FILHOS)
		if is_filhos_visiveis:
			# se os filhos forem visiveis, continue
			_get_nodo_filho(posicao).selecionar_folha_visivel(posicao)
		else:
			# filhos nao sao visiveis, pare
			return
	
	## Toggle a FLAG_SELECIONADO os nodo folha que sao filhos visiveis.
	## 		Inverte o valor de FLAG_SELECIONADO no nodo
	## 		Para nodos que nao sao visiveis nao acontece nada
	func toggle_selecionar_folha_visivel(posicao: Vector2) -> void:
		# se for nodo folha, marque como selecionado e pare
		if is_nodo_folha():
			var valor_flag: bool = _get_node_flag(FLAG_SELECIONADO)
			_set_node_flag(FLAG_SELECIONADO, not valor_flag)
			return
		# se nao for folha, veja se os filhos sao visiveis
		var is_filhos_visiveis : bool = _get_node_flag(FLAG_SHOW_FILHOS)
		if is_filhos_visiveis:
			# se os filhos forem visiveis, continue
			_get_nodo_filho(posicao).toggle_selecionar_folha_visivel(posicao)
		else:
			# filhos nao sao visiveis, pare
			return
	
	
	func get_posicao_all_nodos_folha_corretos() -> Array[Vector2]:
		# se eh folha, acabe aqui
		if is_nodo_folha():
			# se for FLAG_CORRETO, retorne a posicao metade
			if _get_node_flag(FLAG_CORRETO):
				return [pos_metade]
			return []
		# se tem filhos, retorne a juncao das posicao que eles retornarem
		var return_dos_filhos : Array = (
			  top_esq.get_posicao_all_nodos_folha_corretos()
			+ top_dir.get_posicao_all_nodos_folha_corretos()
			+ bot_esq.get_posicao_all_nodos_folha_corretos()
			+ bot_dir.get_posicao_all_nodos_folha_corretos()
		)
		return return_dos_filhos
	
	## Para cada nodo retorne os valores somados dos filhos
	## 	Onde para cada filho:
	##	-1 se correto, 		mas 	nao selecionado
	##	 0 se correto 		e 		selecionado
	##	 1 se nao correto, 	mas 	selecionado 
	##	 0 se nao correto, 	e 		nao selecionado
	func get_dif_selecoes_marcadas_corretas() -> int:
		# se eh folha, retorne se esta correto
		if is_nodo_folha():
			var correto: int     = 1 if _get_node_flag(FLAG_CORRETO)     else 0
			var selecionado: int = 1 if _get_node_flag(FLAG_SELECIONADO) else 0
			return selecionado - correto
		# se tiver filhos
		var valor : int = 0
		valor += top_esq.get_dif_selecoes_marcadas_corretas()
		valor += top_dir.get_dif_selecoes_marcadas_corretas()
		valor += bot_esq.get_dif_selecoes_marcadas_corretas()
		valor += bot_dir.get_dif_selecoes_marcadas_corretas()
		return valor
