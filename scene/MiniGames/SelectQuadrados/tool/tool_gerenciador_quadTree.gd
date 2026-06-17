@tool
class_name GerenciadorQuadTree
extends Node

@export_category("Resource Level")
@export var quadTree_resource: MG_SelecaoDefinicoesRes

@export_group("Dados Imagem")
@export var imagem_sprite: Sprite2D
@export_tool_button("Capturar Dados Imagem", "ActionPaste") var button_dados_sprite = _tool_capturar_dados_sprite

@export_category("Janela Edição")
@export var size_janela_edicao := Vector2i(600, 700)
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

func get_max_falta_selecionar_corretas() -> int:
	return quadTree_resource.max_falta_selecionar_corretas

func get_max_selecoes_nao_corretas() -> int:
	return quadTree_resource.max_selecoes_nao_corretas

# ------------------------------------------------------------------------------
# Tool
# ------------------------------------------------------------------------------

# --------------------------------------------------------
# Janela Editar QuadTree
func _tool_janela():
	if not Engine.is_editor_hint(): return
	
	var window := Window.new()
	EditorInterface.popup_dialog_centered(window, size_janela_edicao)
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

func _criar_quadTree(profundidade: int) -> void:
	quadTree = QuadTreeSelecao.new(profundidade)
	print("Criada quadTree, profundidade: ", profundidade)
	# salva o resource no disco
	quadTree_resource.profundidade = profundidade
	_salvar_disco_resource(quadTree_resource)

func _load_quadTree() -> void:
	quadTree = quadTree_resource.load_corretos_quadTree()
	print("Load quadTree")

const CENA_IMAGEM_CLICAVEL = preload("uid://bwk2s0vp06pp8")
var gerenciador_img_clicavel : GerenciadorImagemClicavel

func _mostrar_quadrados(janela: ToolWindowGerenciadorQuadTree) -> void:
	gerenciador_img_clicavel = CENA_IMAGEM_CLICAVEL.instantiate()
	# coloca na cena
	janela.img_start_pos_node.add_child(gerenciador_img_clicavel)
	# passa self como referencia para pegar a quadTree
	gerenciador_img_clicavel.gerenciador_quadTree = self
	# chama o ready
	gerenciador_img_clicavel.tool_ready()
	print("Quadrados mostrados")

func _salvar_quadrados() -> void:
	if (not gerenciador_img_clicavel) or gerenciador_img_clicavel == null:
		push_error("Cena da Imagem Clicavel nao foi encontrada")
		return
	
	# salva as posicoes selecionadas como corretas
	var posicoes_corretas: Array[Vector2] = quadTree.get_posicao_all_nodos_folha_selecionados()
	for pos : Vector2 in posicoes_corretas:
		quadTree.marcar_correto(pos)
	
	# atualiza a posicao no resource
	var posicoes:  = quadTree.get_posicao_all_nodos_folha_selecionados()
	quadTree_resource.save_corretos_quadTree(posicoes)
	print("%d Quadrados Corretos da QuadTree" % posicoes_corretas.size())
	# salva o resource no disco
	_salvar_disco_resource(quadTree_resource)

# --------------------------------------------------------
# Capturar dados Sprite
func _tool_capturar_dados_sprite() -> void:
	if not Engine.is_editor_hint(): return
	# se a sprite nao tiver setada corretamente, pare
	if (not imagem_sprite) or (imagem_sprite == null):
		push_warning("Referencia da Sprite Faltando")
		return
	# captura os dados da imagem e passa pro resource
	quadTree_resource.obter_dados_imagem(imagem_sprite)
	# salvar o resource
	_salvar_disco_resource(quadTree_resource)
	print("Dados da Imagem atualizados no Resource ")

# --------------------------------------------------------
# Salvar Resource
func _salvar_disco_resource(_resource: Resource) -> void:
	var res_path := _resource.resource_path
	var error = ResourceSaver.save(_resource, res_path)
	_resource.take_over_path(_resource.resource_path)
	
	if error == OK:
		print("Salvo Resource %s" % res_path )
	else:
		push_warning("Não foi possível salvar o resource (%s), error code %d" % [res_path, error])
