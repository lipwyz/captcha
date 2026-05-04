@tool
class_name MG_SelecaoDefinicoesRes
extends Resource

# --- Level ---
@export_group("Design do Level")
## Quantidade de Corretos que nao foram Selecionadas
@export var max_falta_selecionar_corretas 	: int = 0
## Quantidade de Selecionados que nao eram Corretos
@export var max_selecoes_nao_corretas : int = 0

@export var imagem_texture : Texture2D
@export var imagem_scale : Vector2 = Vector2.ONE
@export var imagem_region_rect : Rect2 = Rect2(0,0,0,0)

# --- Criacao da QuadTree --- 
@export_group("Dados QuadTree")
## Profundidade da QuadTree (profundidade = 1 -> root e 4 filhos)
@export var profundidade: int = -1
## Lista de posicoes (do meio do nodo folha) referentes aos nodos corretos
@export var posicoes_folhas_corretas : PackedVector2Array

# -----------------------------------------------------------------------------
# QuadTree

func save_corretos_quadTree(posicoes: Array[Vector2]) -> void:
	posicoes_folhas_corretas = PackedVector2Array(posicoes)

func load_corretos_quadTree() -> QuadTreeSelecao:
	var quadTree := QuadTreeSelecao.new(profundidade)
	
	for pos : Vector2 in Array(posicoes_folhas_corretas):
		quadTree.marcar_correto(pos)
	
	return quadTree
