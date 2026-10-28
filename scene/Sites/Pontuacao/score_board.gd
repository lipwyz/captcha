class_name ScoreBoard
extends Control

@onready var item_list_scores: ItemList = %ItemListScores

@onready var line_edit_nome_score: LineEdit = %LineEditNomeScore
@onready var button_add_score: Button = %ButtonAddScore

func _on_button_try_again_pressed() -> void:
	GerenciadorGlobal.chamar_menu_inicial()

func _ready() -> void:
	button_add_score.disabled = true
	_load_scores()

# Mostra a lista de scores
# -----------------------------------------------------------------------------

func _load_scores(tempo_atual : int = -1) -> void:
	item_list_scores.clear()
	# pega os scores
	var scores := GerenciadorGlobal.pegar_scores()
	# separa o nome e tempo nos scores
	var score_tempo_nome : Array = []
	for nome : String in scores.keys():
		var tempo_milis : int = scores[nome][0]
		score_tempo_nome.append([tempo_milis, nome])
	# ordena por menor tempo
	score_tempo_nome.sort_custom(func(a, b): return a[0] < b[0])
	
	# preenche a lista com tempo e nome dos jogadores
	for item : Array in score_tempo_nome:
		var tempo_milis = item[0]
		var nome = item[1]
		item_list_scores.add_item(_get_texto_item(nome, tempo_milis))
		if tempo_atual == tempo_milis:
			var idx := item_list_scores.item_count-1
			item_list_scores.set_item_custom_fg_color(idx, Color.ORANGE)
			item_list_scores.select(idx)
			item_list_scores.ensure_current_is_visible()

func _get_texto_item(nome: String, tempo_milis: int) -> String:
	var tempo_str := GerenciadorPontuacao.format_tempo_str(tempo_milis)
	return "%s - %s" % [tempo_str, nome]

# Adicionar score na lista
# -----------------------------------------------------------------------------

func _on_line_edit_nome_score_text_changed(new_text: String) -> void:
	button_add_score.disabled = new_text.length() < 3 or new_text.length() > 10

func _on_button_add_score_pressed() -> void:
	var nome_jogador : String = line_edit_nome_score.text
	var tempo_milis := GerenciadorGlobal.salvar_score(nome_jogador)
	
	_load_scores(tempo_milis)
