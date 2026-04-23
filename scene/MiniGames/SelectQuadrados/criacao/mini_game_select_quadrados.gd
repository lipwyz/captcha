extends ConteudoAba

#@export var quad_tree_profundidade : int = 3
#var quad_tree : QuadTreeSelecao

#@onready var linhas: LinhasSelectQuadrado = $Mundo/Linhas

#func _ready() -> void:
	#quad_tree = QuadTreeSelecao.new(quad_tree_profundidade)
	#await get_tree().create_timer(0.1).timeout
	#linhas.desenhar_posicoes(quad_tree.get_all_dimensoes())
