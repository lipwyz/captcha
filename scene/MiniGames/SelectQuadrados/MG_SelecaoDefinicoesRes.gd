@tool
class_name MG_SelecaoDefinicoesRes
extends Resource

# --- Criacao da QuadTree --- 
## Profundidade da QuadTree (profundidade = 1 -> root e 4 filhos)
@export var profundidade: int = -1
## Lista de posicoes (do meio do nodo folha) referentes aos nodos corretos
@export var posicoes_folhas_corretas : Array[Vector2]

# --- Level ---
## Quantidade de Corretos que nao foram Selecionadas
@export var max_selecao_nao_cliadas 	: int = 1
## Quantidade de Selecionados que nao eram Corretos
@export var max_selecao_erradas_cliadas : int = 3

##	-1 se correto, 		mas 	nao selecionado
##	 0 se correto 		e 		selecionado
##	 1 se nao correto, 	mas 	selecionado 
##	 0 se nao correto, 	e 		nao selecionado

# -----------------------------------------------------------------------------
# QuadTree

func save_corretos_quadTree(quadTree: QuadTreeSelecao) -> void:
	posicoes_folhas_corretas = quadTree.get_posicao_all_nodos_folha_corretos()

func load_corretos_quadTree() -> QuadTreeSelecao:
	var quadTree := QuadTreeSelecao.new(profundidade)
	
	for pos : Vector2 in posicoes_folhas_corretas:
		quadTree.marcar_correto(pos)
	
	return quadTree
