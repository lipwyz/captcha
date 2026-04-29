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
@export var max_corretas_nao_clicadas 	: int = 1
## Quantidade de Selecionados que nao eram Corretos
@export var max_nao_corretas_clicadas : int = 3

# -----------------------------------------------------------------------------
# QuadTree

func save_corretos_quadTree(quadTree: QuadTreeSelecao) -> void:
	posicoes_folhas_corretas = quadTree.get_posicao_all_nodos_folha_corretos()

func load_corretos_quadTree() -> QuadTreeSelecao:
	var quadTree := QuadTreeSelecao.new(profundidade)
	
	for pos : Vector2 in posicoes_folhas_corretas:
		quadTree.marcar_correto(pos)
	
	return quadTree
