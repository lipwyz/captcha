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
	# -- save --
	janela.salvar_quadrados.connect(_salvar_quadrados)
	
	
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

const CENA_IMAGEM_CLICAVEL = preload("uid://bwk2s0vp06pp8")
var gerenciador_img_clicavel : GerenciadorImagemClicavel

func _mostrar_quadrados(janela: ToolWindowGerenciadorQuadTree) -> void:
	gerenciador_img_clicavel = CENA_IMAGEM_CLICAVEL.instantiate()
	# passa self como referencia para pegar a quadTree
	gerenciador_img_clicavel.gerenciador_quadTree = self
	gerenciador_img_clicavel.global_position = Vector2(100, 100)
	# coloca na cena (chama o ready)
	janela.add_child(gerenciador_img_clicavel)
	
	print("Quadrados mostrados")

func _salvar_quadrados() -> void:
	if (not gerenciador_img_clicavel) or gerenciador_img_clicavel == null:
		push_error("Cena da Imagem Clicavel nao foi encontrada")
		return
	
	# salva as posicoes selecionadas como corretas
	var posicoes_corretas: Array[Vector2] = quadTree.get_posicao_all_nodos_folha_selecionados()
	for pos : Vector2 in posicoes_corretas:
		quadTree.marcar_correto(pos)
	
	# salva a quad tree no resource
	quadTree_resource.save_corretos_quadTree(quadTree)
	var error = ResourceSaver.save(quadTree_resource, quadTree_resource.resource_path)
	quadTree_resource.take_over_path(quadTree_resource.resource_path)
	print("quadTree_resource.resource_path: ", quadTree_resource.resource_path)
	
	if error == OK:
		print("%d Quadrados Corretos da QuadTree Salvos no Resource %s" % 
			[posicoes_corretas.size(), quadTree_resource.resource_name] )
	else:
		push_warning("Não foi possível salver o resource, error code %d" % error)
