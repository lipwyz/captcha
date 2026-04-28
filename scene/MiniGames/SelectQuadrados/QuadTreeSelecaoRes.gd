@tool
class_name QuadTreeSelecaoRes
extends Resource

@export var profundidade: int = -1

@export var positions : Array[Vector2]

func save_corretos_quadTree(quadTree: QuadTreeSelecao) -> void:
	positions = quadTree.get_posicao_all_nodos_folha_corretos()

func load_corretos_quadTree() -> QuadTreeSelecao:
	var quadTree := QuadTreeSelecao.new(profundidade)
	
	for pos : Vector2 in positions:
		quadTree.marcar_correto(pos)
	
	return quadTree
