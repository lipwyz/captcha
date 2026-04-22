class_name QuadTree
extends RefCounted

var root: QuadTreeNode

func _init(profundidade: int) -> void:
	root = QuadTreeNode.new(Vector2.ZERO, Vector2.ONE, profundidade)

func get_dados(posicao: Vector2) -> Variant:
	return root.get_dados(posicao)

func inserir(dados, posicao: Vector2) -> void:
	root.inserir(dados, posicao)

func get_all_dimensoes() -> Array:
	return root.get_all_dimensoes(Vector2.ZERO, Vector2.ONE)

class QuadTreeNode:
	var top_esq : QuadTreeNode
	var top_dir : QuadTreeNode
	var bot_esq : QuadTreeNode
	var bot_dir : QuadTreeNode
	#  comeco --------------------------|
	#  		|-------------|-------------|
	#  		|---top_esq---|---top_dir---|
	#  		|-------------|-------------|
	#  		|========== metade =========|
	#  		|-------------|-------------|
	#  		|---bot_esq---|---bot_dir---|
	#  		|-------------|-------------|
	#  		|---------------------------fim
	
	var profundidade : int
	var pos_metade : Vector2
	
	var dados
	
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
	
	func get_dados(posicao: Vector2) -> Variant:
		if _is_nodo_folha():
			# retorne as flags
			return dados
			
		# nodo nao eh folha, continua a func no filho
		var nodo_filho := _get_nodo_filho(posicao)
		return nodo_filho.get_dados(posicao)
	
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
		
	
	## retorna se o nodo eh folha (nao tem filhos)
	func _is_nodo_folha() -> bool:
		return profundidade == 0
	
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
