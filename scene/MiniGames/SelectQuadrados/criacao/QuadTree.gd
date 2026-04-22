class_name QuadTree
extends RefCounted

## QuadTree Node base da arvore, pai de todos
var root: QuadTreeNode

## Cria a arvore com dada profundidade de camadas (profundidade = 1 para somente o root e 4 filhos)
func _init(profundidade: int) -> void:
	root = QuadTreeNode.new(Vector2.ZERO, Vector2.ONE, profundidade)

## Retorna os dados guardados em um nodo folha na dada posicao
func get_dados(posicao: Vector2) -> Variant:
	return root.get_dados(posicao)

## Insere dados em um nodo folha na dada posicao
func inserir(dados, posicao: Vector2) -> void:
	root.inserir(dados, posicao)

## Retorna uma lista de elementos [comeco, fim] : Array[Vector2]
## 		para a nodo folha da arvore
func get_all_dimensoes() -> Array:
	return root.get_all_dimensoes(Vector2.ZERO, Vector2.ONE)

# ------------------------------------------------------------------------------
# QuadTree Node
# ------------------------------------------------------------------------------

## Classe para cada nodo da arvore
class QuadTreeNode:
	# Nodos filhos, organizados da seguinte maneira:
	#  comeco --------------------------|
	#  		|-------------|-------------|
	#  		|---top_esq---|---top_dir---|
	#  		|-------------|-------------|
	#  		|========== metade =========|
	#  		|-------------|-------------|
	#  		|---bot_esq---|---bot_dir---|
	#  		|-------------|-------------|
	#  		|---------------------------fim
	var top_esq : QuadTreeNode
	var top_dir : QuadTreeNode
	var bot_esq : QuadTreeNode
	var bot_dir : QuadTreeNode
	
	## Profundidade do nodo atual, quantidade de camadas de filhos (se for folha = 0)
	var profundidade : int
	## Posicao da metade do nodo, para calcular esq, dir, top e bot (null nos nodos folhas)
	var pos_metade : Vector2
	
	## Dados que o nodo folha guarda (null nos pais)
	var dados: Variant
	
	## Cria o nodo e seus filhos recursivamente
	func _init(comeco : Vector2, fim : Vector2, _profundidade : int) -> void:
		profundidade = _profundidade
		
		# se for nodo folha (sem filhos), pare aqui
		if _profundidade == 0:
			return
		# se nodo tiver filhos, continue
		
		# calcula a posicao na metade
		pos_metade = comeco + ( (fim - comeco) * 0.5 )
		# diminui a profundidade para criar os nodos filhos
		_profundidade -= 1
		# cria os 4 filhos
		top_esq = QuadTreeNode.new(comeco,
									pos_metade,
									_profundidade)
		top_dir = QuadTreeNode.new(Vector2(pos_metade.x, comeco.y), 
									Vector2(fim.x, pos_metade.y),
									_profundidade)
		bot_esq = QuadTreeNode.new(Vector2(comeco.x, pos_metade.y), 
									Vector2(pos_metade.x, fim.y),
									_profundidade)
		bot_dir = QuadTreeNode.new(pos_metade, 
									fim,
									_profundidade)
	
	## Insere _dados no nodo folha, com base na sua posicao
	func inserir(_dados, posicao: Vector2) -> void:
		if _is_nodo_folha():
			# coloca os dados
			dados = _dados
			# para a func
			return
			
		# nodo nao eh folha, passar para os filhos
		# insere no nodo filho correto
		var nodo_filho := _get_nodo_filho(posicao)
		nodo_filho.inserir(_dados, posicao)
	
	## Retorna a variavel dados do nodo
	func get_dados(posicao: Vector2) -> Variant:
		if _is_nodo_folha():
			# retorne as flags
			return dados
			
		# nodo nao eh folha, continua a func no filho
		var nodo_filho := _get_nodo_filho(posicao)
		return nodo_filho.get_dados(posicao)
	
	## Retona uma lista com a dimensão de cada quadrado, somente dos nodos filhos
	## Dimensao sendo comeco (topo esquerda) e fim (bottom direita) 
	func get_all_dimensoes(comeco: Vector2, fim: Vector2) -> Array:
		if _is_nodo_folha():
			# retorne a lista com as posicoes [inicio, fim]
			return [[comeco, fim]]
		
		#se tem filhos, retorne a posicao de cada um dos 4
		return (
			top_esq.get_all_dimensoes(comeco, pos_metade)
			+ top_dir.get_all_dimensoes(Vector2(pos_metade.x, comeco.y), Vector2(fim.x, pos_metade.y))
			+ bot_esq.get_all_dimensoes(Vector2(comeco.x, pos_metade.y), Vector2(pos_metade.x, fim.y))
			+ bot_dir.get_all_dimensoes(pos_metade, fim)
		)
	
	## Retorna verdadeiro se o nodo eh folha (nao tem filhos)
	func _is_nodo_folha() -> bool:
		return profundidade == 0
	
	## Retorna o nodo filho que contem a posicao -> top_esq, top_dir, bot_esq, bot_dir
	func _get_nodo_filho(posicao: Vector2) -> QuadTreeNode:
		# top
		if posicao.y <= pos_metade.y:
			# esq
			if posicao.x <= pos_metade.x:
				return top_esq
			# dir
			else:
				return top_dir
		# bot
		else:
			# esq
			if posicao.x <= pos_metade.x:
				return bot_esq
			# dir
			else:
				return bot_dir
