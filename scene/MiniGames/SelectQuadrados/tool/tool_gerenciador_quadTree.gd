@tool
class_name GerenciadorQuadTree
extends Node

@export_category("QuadTree")
@export var quadTree_resource: MG_SelecaoDefinicoesRes

@export_tool_button("Abrir Janela Configuracao", "ScriptCreateDialog") var button_janela = _tool_janela

var _tool_gui := preload("uid://bj231cdcdqwep")

var quadTree : QuadTreeSelecao

func _ready() -> void:
	if Engine.is_editor_hint(): return


func load_quadTree() -> void:
	# TODO: fazer o load
	quadTree = quadTree_resource.load_corretos_quadTree()


# ------------------------------------------------------------------------------
# Get configuracoes Level
# ------------------------------------------------------------------------------

func get_max_corretas_nao_clicadas() -> int:
	return quadTree_resource.max_corretas_nao_clicadas

func get_max_nao_corretas_clicadas() -> int:
	return quadTree_resource.max_nao_corretas_clicadas

# ------------------------------------------------------------------------------
# Tool
# ------------------------------------------------------------------------------

func _tool_janela():
	if not Engine.is_editor_hint(): return
	
	var window := Window.new()
	EditorInterface.popup_dialog_centered(window, Vector2i(400, 300))
	window.close_requested.connect(func(): window.queue_free() )
	
	var janela : ToolWindowGerenciadorQuadTree = _tool_gui.instantiate()
	window.add_child(janela)
	
	janela.closed.connect(func(): window.queue_free() )
	# -- criar --
	janela.criar_quadTree.connect(_criar_quadTree)
	# -- load --
	janela.load_quadTree.connect(_load_quadTree)
	janela.mostrar_quadrados.connect(_mostrar_quadrados.bind(janela))
	
	if quadTree_resource:
		janela.receber_resource(quadTree_resource)
	else:
		janela.receber_resource(null)

#var janela

func _criar_quadTree(profundidade: int) -> void:
	quadTree = QuadTreeSelecao.new(profundidade)
	print("Criada quadTree, profundidade: ", profundidade)
	
func _load_quadTree() -> void:
	quadTree = quadTree_resource.load_corretos_quadTree()
	print("Load quadTree")

func _mostrar_quadrados(janela: ToolWindowGerenciadorQuadTree) -> void:
	var imagem_clicavel :Node2D = CENA_IMAGEM_CLICAVEL.instantiate()
	var _gerenciador_linhas : GerenciadorImagemClicavel = imagem_clicavel.get_child(-1)
	_gerenciador_linhas.gerenciador_quadTree = self
	janela.add_child(imagem_clicavel)
	#
	_gerenciador_linhas.ajustar_dados_tamanho_imagem()
	_gerenciador_linhas.desenhar_quadrados_all(quadTree)
	print("Quadrados mostrados")

const CENA_IMAGEM_CLICAVEL = preload("uid://bwk2s0vp06pp8")
