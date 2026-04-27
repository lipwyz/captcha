@tool
class_name QuadTreeSelecao
extends QuadTree

const FLAG_CLICK 		:= 1
const FLAG_CORRETO 		:= 2
const FLAG_SHOW_FILHOS 	:= 4

func _init(_profundidade: int) -> void:
	root = QuadTreeSelecaoNode.new(Vector2.ZERO, Vector2.ONE, _profundidade, "0")
	
	# zera as flags em todos os nodos
	const flags_inicial : int = 0
	_set_valor_inicial_todos_nodos(flags_inicial)
	# mostra somente a primeira camada de quadrados (filhos diretos do root)
	root.dados = FLAG_SHOW_FILHOS
	#for filho : QuadTreeNode in [root.top_esq, root.top_dir, root.bot_esq, root.bot_dir]:
		#filho.dados = FLAG_SHOW_FILHOS

func print_id(posicao: Vector2) -> void:
	root.print_id(posicao)

func get_dimensoes_visiveis() -> Array[Array]:
	return root.get_dimensoes_visiveis()

func mostrar_quadrados() -> Array[Array]:
	#return root.get_dimensoes_filhos_nodos_com_dados(FLAG_SHOW)
	return root.get_folhas_dimensoes()

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


func marcar_clicado(posicao: Vector2) -> void:
	var nodo : QuadTreeSelecaoNode = root.get_nodo_folha(posicao)
	var flags :int = nodo.get_dados(posicao)
	flags = flags | FLAG_CLICK
	nodo.inserir_dados(flags, posicao)

func set_valido(posicao: Vector2) -> void:
	root.inserir_dados(FLAG_CORRETO, posicao)

## Retorna os dados guardados em um nodo folha na dada posicao
func get_dados(posicao: Vector2) -> Variant:
	return root.get_dados(posicao)

## Insere dados em um nodo folha na dada posicao
func inserir(dados, posicao: Vector2) -> void:
	root.inserir(dados, posicao)
#
### Retorna uma lista de elementos [comeco, fim] : Array[Vector2]
### 		para a nodo folha da arvore
#func get_all_dimensoes() -> Array:
	#return root.get_all_dimensoes(Vector2.ZERO, Vector2.ONE)

## Retorna os 4 cantos do quadrado, dado comeco (esq cima) e fim (direita baixo)
func get_cantos_quadrado(comeco : Vector2, fim : Vector2) -> Array[Vector2]:
	return [
		Vector2(comeco.x, comeco.y),	# top esq
		Vector2(fim.x, comeco.y), 		# top dir
		Vector2(fim.x, fim.y), 			# bot dir
		Vector2(comeco.x, fim.y),		# bot esq
	]

func _set_valor_inicial_todos_nodos(valor: int) -> void:
	root.inserir_dados_nodo_e_filhos(valor)

# -----------------------------------------------------------------------------
# class QuadTreeSelecaoNode
# -----------------------------------------------------------------------------
class QuadTreeSelecaoNode extends QuadTreeNode:
	#
	var id: String = ""
	
	var pos_comeco : Vector2
	var pos_fim : Vector2
	
	func print_id(posicao: Vector2) -> void:
		print(id)
		if is_nodo_folha(): return
		_get_nodo_filho(posicao).print_id(posicao)
	
	func _init(comeco : Vector2, fim : Vector2, _profundidade : int, _id:String) -> void:
		profundidade = _profundidade
		pos_comeco = comeco
		pos_fim    = fim
		id = _id + "_"
		
		dados = 0
		
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
	
	func get_dimensoes_visiveis() -> Array[Array]:
		var is_filhos_visiveis : bool = (dados & FLAG_SHOW_FILHOS) != 0
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
	
