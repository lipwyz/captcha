class_name QuadTree
extends RefCounted

## QuadTree Node base da arvore, pai de todos
var root: QuadTreeNode

## Cria a arvore com dada profundidade de camadas (profundidade = 1 para somente o root e 4 filhos)
func _init(profundidade: int) -> void:
	root = QuadTreeNode.new(Vector2.ZERO, Vector2.ONE, profundidade, "0")

## Retorna os dados guardados em um nodo folha na dada posicao
func get_dados(posicao: Vector2) -> Variant:
	return root.get_dados(posicao)

## Insere dados em um nodo folha na dada posicao
func inserir_dados(dados: Variant, posicao: Vector2) -> void:
	root.inserir_dados(dados, posicao)

func get_all_dimensoes() -> Array:
	return root.get_all_dimensoes()

## Retorna uma lista de elementos [comeco, fim] : Array[Vector2]
## 		para cada nodo folha da arvore
func get_folhas_dimensoes() -> Array[Vector2]:
	return root.get_folhas_dimensoes()

## Retorna uma lista de elementos [comeco, fim] : Array[Vector2]
## 		para cada nodo folha da arvore
func get_dimensoes_nodos_com_dados(dados_comparar: Variant) -> Array[Vector2]:
	return root.get_dimensoes_nodos_com_dados(dados_comparar)

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
	
	var pos_comeco : Vector2
	var pos_fim : Vector2
	
	## Dados que o nodo folha guarda (null nos pais)
	var dados: Variant
	
	#
	var id: String = ""
	
	func print_id(posicao: Vector2) -> void:
		print(id)
		if is_nodo_folha(): return
		_get_nodo_filho(posicao).print_id(posicao)
	
	## Cria o nodo e seus filhos recursivamente
	func _init(comeco : Vector2, fim : Vector2, _profundidade : int, _id:String) -> void:
		profundidade = _profundidade
		pos_comeco = comeco
		pos_fim    = fim
		id = _id
		
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
									_profundidade, id + "7")
		top_dir = QuadTreeNode.new(Vector2(pos_metade.x, comeco.y), 
									Vector2(fim.x, pos_metade.y),
									_profundidade, id + "9")
		bot_esq = QuadTreeNode.new(Vector2(comeco.x, pos_metade.y), 
									Vector2(pos_metade.x, fim.y),
									_profundidade, id + "1")
		bot_dir = QuadTreeNode.new(pos_metade, 
									fim,
									_profundidade, id + "3")
	
	
	## Insere _dados no nodo folha, com base na sua posicao
	func inserir_dados(_dados: Variant, posicao: Vector2) -> void:
		if is_nodo_folha():
			# coloca os dados
			dados = _dados
			# para a func
			return
			
		# nodo nao eh folha, passar para os filhos
		# insere no nodo filho correto
		var nodo_filho := _get_nodo_filho(posicao)
		nodo_filho.inserir_dados(_dados, posicao)
	
	## Insere _dados no nodo e seus filhos
	func inserir_dados_nodo_e_filhos(_dados) -> void:
		if is_nodo_folha():
			# coloca os dados
			dados = _dados
			# para a func
			return
			
		# nodo nao eh folha, passar para os filhos
		for filho in [top_esq, top_dir, bot_esq, bot_dir]:
			filho.inserir_dados_nodo_e_filhos(_dados)
	
	## Retorna a variavel dados do nodo
	func get_dados(posicao: Vector2) -> Variant:
		if is_nodo_folha():
			# retorne as flags
			return dados
			
		# nodo nao eh folha, continua a func no filho
		var nodo_filho := _get_nodo_filho(posicao)
		return nodo_filho.get_dados(posicao)
	
	## Retona uma lista com a dimensão de cada quadrado
	## Dimensao sendo comeco (topo esquerda) e fim (bottom direita) 
	func get_all_dimensoes() -> Array:
		if is_nodo_folha():
			# retorne as posicoes [inicio, fim]
			return [pos_comeco, pos_fim, [] ]
		
		# se tem filhos
		var dimensoes_filhos : Array = (
			top_esq.get_all_dimensoes()
			+ top_dir.get_all_dimensoes()
			+ bot_esq.get_all_dimensoes()
			+ bot_dir.get_all_dimensoes()
		)
		
		return [pos_comeco, pos_fim, dimensoes_filhos]
	
	## Retona uma lista com a dimensão de cada quadrado, somente dos nodos filhos
	## 	Dimensao sendo comeco (topo esquerda) e fim (bottom direita) 
	func get_folhas_dimensoes() -> Array:
		if is_nodo_folha():
			return get_dimensoes_nodo()
		
		# se tem filhos, retorne a posicao de cada um dos 4
		return (
			top_esq.get_folhas_dimensoes()
			+ top_dir.get_folhas_dimensoes()
			+ bot_esq.get_folhas_dimensoes()
			+ bot_dir.get_folhas_dimensoes()
		)
	
	# retorne a lista com as posicoes [inicio, fim]
	func get_dimensoes_nodo() -> Array[Array]:
		return [[pos_comeco, pos_fim]]
	
	func get_dimensoes_filhos_nodos_com_dados(dados_comparar: Variant) -> Array:
		# se o valor nao for igual, retorne o tamanho dos filhos
		if dados != dados_comparar:
			return (
				top_esq.get_dimensoes_nodo()
				+ top_dir.get_dimensoes_nodo()
				+ bot_esq.get_dimensoes_nodo()
				+ bot_dir.get_dimensoes_nodo()
			)
		# se o valor for igual
		
		# se chegar nos nodos folha, retorne a posicao deles
		if is_nodo_folha():
			return get_dimensoes_nodo()
		
		# dimensoes dos filhos
		var dimensoes_filhos : Array = (
			top_esq.get_dimensoes_filhos_nodos_com_dados(dados_comparar)
			+ top_dir.get_dimensoes_filhos_nodos_com_dados(dados_comparar)
			+ bot_esq.get_dimensoes_filhos_nodos_com_dados(dados_comparar)
			+ bot_dir.get_dimensoes_filhos_nodos_com_dados(dados_comparar)
		)
		
		#se nenhnum filho retornou nada, bote o valor deste nodo
		if dimensoes_filhos.is_empty():
			return [[pos_comeco, pos_fim]]
		# se os filhos retornaram algo, retorne os valores deles
		else:
			return dimensoes_filhos
	
	## Retorna o nodo folha na dada posicao
	func get_nodo_folha(posicao: Vector2) -> QuadTreeNode:
		if is_nodo_folha():
			return self
		# se for pai -> chama get_nodo_folha no nodo filho da posicao correspondente
		return _get_nodo_filho(posicao).get_nodo_folha(posicao)
	
	## Retorna verdadeiro se o nodo eh folha (nao tem filhos)
	func is_nodo_folha() -> bool:
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
