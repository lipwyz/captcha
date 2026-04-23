@tool
class_name GerenciadorQuadTree
extends Node

@export_category("Iniciar")
@export var quadTree_res: QuadTreeSelecaoRes

@export_group("Load Estrutura")
@export_tool_button("Carregar") var button_load = _tool_load

@export_group("Criar Estrutura")
@export var profundidade : int = 3
@export_tool_button("Criar") var button_criar = _tool_criar

var quadTree : QuadTreeSelecao

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	print("criado")
	quadTree = load_quadTree()


func load_quadTree() -> QuadTreeSelecao:
	# TODO: fazer o load
	return QuadTreeSelecao.new(profundidade)

# ------------------------------------------------------------------------------
# Tool
# ------------------------------------------------------------------------------

func _tool_criar():
	if not Engine.is_editor_hint(): return
	
	quadTree = QuadTreeSelecao.new(profundidade)
	print("QuadTree criada")

func _tool_load():
	if not Engine.is_editor_hint(): return
	
	print("_tool_load")
	
	print(quadTree.root)
	print(quadTree.root.dados)
	print(quadTree.root.profundidade)
	
	print(quadTree.root.top_esq)
	print(quadTree.root.top_esq.dados)
	print(quadTree.root.top_esq.profundidade)
	pass

func _posicoes_to_quadTree(posicoes: Array[Vector2]) -> void:
	quadTree = QuadTreeSelecao.new(profundidade)
	for p: Vector2 in posicoes:
		quadTree.inserir(0, p)

func populate_data():
	if not Engine.is_editor_hint():
		return
