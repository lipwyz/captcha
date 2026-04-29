@tool
class_name ToolWindowGerenciadorQuadTree
extends MarginContainer

signal closed

signal criar_quadTree(profundidade: int)
signal load_quadTree
signal mostrar_quadrados


@onready var criar_quad_tree: Control = $CriarQuadTree
@onready var load_quad_tree: Control = $LoadQuadTree

var quadTreeResource : MG_SelecaoDefinicoesRes

func _ready() -> void:
	criar_quad_tree.hide()
	load_quad_tree.hide()

func receber_resource(quadTreeRes: MG_SelecaoDefinicoesRes) -> void:
	if (not quadTreeRes) or quadTreeRes == null:
		push_error("QuadTreeRes null")
		closed.emit()
		return
	
	quadTreeResource = quadTreeRes
	
	if quadTreeRes.profundidade < 0:
		criar_quad_tree.show()
	else:
		load_quad_tree.show()
		_load_quadTree()

# -----------------------------------------------------------------------------
# Criar Quad Tree
@onready var spin_box_profundidade: SpinBox = $CriarQuadTree/VBox/HBox/SpinBoxProfundidade
func _on_button_criar_pressed() -> void:
	var prof : int = int(spin_box_profundidade.value)
	criar_quadTree.emit(prof)

# -----------------------------------------------------------------------------
# Load Quad Tree
@onready var label_inicial: Label = $LoadQuadTree/VBox/LabelInicial
@onready var button_mostrar: Button = $LoadQuadTree/VBox/ButtonMostrar
func _load_quadTree() -> void:
	label_inicial.text += "\n profundidade: " + str(quadTreeResource.profundidade)
	label_inicial.text += "\n quadrados marcados: " + str(quadTreeResource.posicoes_folhas_corretas.size())
	button_mostrar.disabled = true

func _on_button_load_pressed() -> void:
	load_quadTree.emit()
	button_mostrar.disabled = false

func _on_button_mostrar_pressed() -> void:
	mostrar_quadrados.emit()
