@tool
class_name QuadTreeSelecao
extends QuadTree

const FLAG_CLICK 	:= 1
const FLAG_CORRETO 	:= 2
const FLAG_SHOW 	:= 4

func _init(_profundidade: int) -> void:
	super(_profundidade)
	# zera as flags em todos os nodos
	const flags_inicial : int = 0
	_set_valor_inicial_todos_nodos(flags_inicial)
	# mostra somente a primeira camada de quadrados (filhos diretos do root)
	root.dados = FLAG_SHOW
	for filho : QuadTreeNode in [root.top_esq, root.top_dir, root.bot_esq, root.bot_dir]:
		filho.dados = FLAG_SHOW

func print_id(posicao: Vector2) -> void:
	root.print_id(posicao)

func mostrar_quadrados() -> Array[Array]:
	return root.get_dimensoes_filhos_nodos_com_dados(FLAG_SHOW)

func clicar(posicao: Vector2) -> void:
	var nodo : QuadTreeNode = root.get_nodo_folha(posicao)
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
