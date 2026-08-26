@tool
extends Control

@export_dir var pasta_pai_mini_game

@onready var file_dialog: FileDialog = $FileDialog

# conteudo a ser pego
@onready var line_edit_nome_eng: LineEdit = $MarginContainer/ScrollContainer/VBox/GridContainer/LineEditNomeEng
@onready var check_button_conteudo_aba: CheckButton = $MarginContainer/ScrollContainer/VBox/GridContainer/CheckButtonConteudoAba
@onready var check_button_conteudo_viewport: CheckButton = $MarginContainer/ScrollContainer/VBox/GridContainer/CheckButtonConteudoViewport
# conteudo Aba
@onready var line_edit_nome_aba: LineEdit = $MarginContainer/ScrollContainer/VBox/GridContainer/LineEditNomeAba
@onready var line_edit_url_aba: LineEdit = $MarginContainer/ScrollContainer/VBox/GridContainer/LineEditUrlAba

# utilizados
@onready var label_pasta_pai_atual: Label = $MarginContainer/ScrollContainer/VBox/GridContainer/LabelPastaPaiAtual

func _ready() -> void:
	_mostrar_pasta_pai()

# Pasta Pai
# -----------------------------------------------------------------------------
func _on_button_pasta_pai_pressed() -> void:
	file_dialog.show()

func _mostrar_pasta_pai() -> void:
	label_pasta_pai_atual.text = pasta_pai_mini_game

func _on_file_dialog_dir_selected(dir: String) -> void:
	pasta_pai_mini_game = dir
	_mostrar_pasta_pai()

# Pegar dados
# -----------------------------------------------------------------------------

func _on_button_criar_mini_game_pressed() -> void:
	criar_mini_game()

func criar_mini_game() -> void:
	# pega os inputs
	var nome_eng : String = line_edit_nome_eng.text
	nome_eng = nome_eng.replace(' ', '_')
	
	var nome_aba : String = line_edit_nome_aba.text
	var url_aba  : String = line_edit_url_aba.text
	
	# cria o diretorio / pasta
	var dir_path : String = pasta_pai_mini_game + '/' + nome_eng
	var pasta_criada: bool = _criar_pasta(dir_path)
	if not pasta_criada: return
	
	# cria a cena se necessario
	var criar_cena: bool = check_button_conteudo_aba.button_pressed
	var criar_subview: bool = check_button_conteudo_viewport.button_pressed
	
	var cena_packed: PackedScene = null
	if criar_cena:
		var cena := _gerar_minigame_cena(nome_eng)
		if criar_subview: _gerar_minigame_subviewport(cena)
		cena_packed = _salvar_minigame_cena(cena, dir_path, nome_eng)
	# cria a aba
	_criar_minigame_res(dir_path, nome_eng, nome_aba, url_aba, cena_packed)
	# updata o disco para mostrar os novos arquivos no editor
	if Engine.is_editor_hint():
		EditorInterface.get_resource_filesystem().scan()

## Cria no disco uma pasta.[br] 
## Retorna [code]True[/code] se foi possivel[br] 
## Retorna [code]False[/code] caso algum erro aconteca
func _criar_pasta(dir_path : String) -> bool:
	var err = DirAccess.make_dir_absolute(dir_path)
	if err == OK:
		print("Pasta '{dir_path}' criada!".format({'dir_path': dir_path}))
		return true
	else:
		push_error("Falha ao criar a pasta '{dir_path}'. Error code: {err}".format({
			'dir_path': dir_path, 'err': err
		}))
		return false

## [b]Gera em memoria a cena[/b] do mini game
func _gerar_minigame_cena(nome_engine: String) -> Node:
	var cena : Node = ConteudoAba.new()
	# ajusta o nome do nodo
	cena.name = nome_engine
	# coloca o anchor do control para ser o full
	cena.set_anchors_preset(Control.PRESET_FULL_RECT)
	# troca mouse flag de stop para ignore
	cena.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return cena

## [b]Gera e adiciona subviewport[/b] a uma cena em memoria
func _gerar_minigame_subviewport(cena: Node) -> void:
	# -- SubViewport Container
	var subview_container := SubViewportContainer.new()
	# coloca o anchor do control para ser o full
	subview_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	# ativa o stretch
	subview_container.stretch = true
	# adiciona na cena
	cena.add_child(subview_container)
	
	# -- SubViewport
	var subviewport := SubViewport.new()
	# ajusta para o tamanho da tela
	var _size := Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	subviewport.size = _size
	subviewport.size_2d_override = _size
	subviewport.size_2d_override_stretch = true
	# outras flags
	subviewport.disable_3d = true
	subviewport.transparent_bg = true
	subviewport.handle_input_locally = false
	# adiciona como filho do subviewport container
	subview_container.add_child(subviewport)
	
	# -- renomeia ambos
	subview_container.name 	= "SubViewportContainer"
	subviewport.name 		= "SubViewport"

## [b]Salva em disco a cena[/b], retorna o path da cena nos arquivos
func _salvar_minigame_cena(cena: Node, 
							dir_path : String, nome_eng: String) -> PackedScene:
	# ajuste dos filhos para terem a cena como owner (para nao serem ignoradas pelo packing)
	_set_owner_recursive(cena, cena)
	# faz o packing da cena
	var packed_cena = PackedScene.new()
	var packed_err := packed_cena.pack(cena)
	# falhou ao dar o pack
	if packed_err != OK:
		push_error("Falhou ao fazer o PackedScene. Erro: ", packed_err)
		return null
	# deu certo o packed
	# salva o packedScene nos arquivos
	var file_nome: String = nome_eng + '.tscn'
	var path: String = dir_path + '/' + file_nome
	var save_err := ResourceSaver.save(packed_cena, path)
	# falhou ao salvar
	if save_err != OK:
		push_error("Falhou ao salvar packedScene como '{path}'. Erro: {err}".format({
			'path': path, 'err': save_err
		}))
		return null
	# deu certo o save
	print("Cena salva em '{path}'".format({'path': path}))
	return packed_cena

func _set_owner_recursive(node: Node, new_owner: Node):
	if node != new_owner: node.owner = new_owner
	for child in node.get_children():
		_set_owner_recursive(child, new_owner)

## Cria no disco o resource de mini game.[br] 
## Retorna [code]True[/code] se foi possivel[br] 
## Retorna [code]False[/code] caso algum erro aconteca
func _criar_minigame_res(dir_path : String, nome_eng: String, 
				nome_aba: String, url_aba: String,
				cena_packed: PackedScene = null) -> bool:
	# cria o resource
	var minigame_res := MiniGameRes.new()
	minigame_res.aba_titulo = nome_aba
	minigame_res.aba_url = url_aba
	if cena_packed != null:
		minigame_res.conteudo = cena_packed
	
	# salva no disco
	# 	deixa a primeira letra maiuscula
	var nome_arquivo: String = nome_eng[0].to_upper() + nome_eng.erase(0,1)
	nome_arquivo = "miniGame" + nome_arquivo + ".tres"
	# 	path
	var save_path: String = dir_path + '/' + nome_arquivo
	# tenta salva o recurso
	var err = ResourceSaver.save(minigame_res, save_path)
	if err == OK:
		print("Resource de MiniGame '{nome_arquivo}' criado!".format({'nome_arquivo': nome_arquivo}))
		return true
	else:
		push_error("Falha ao criar Resource de MiniGame '{save_path}'. Error code: {err}".format({
			'save_path': save_path, 'err': err
		}))
		return false
