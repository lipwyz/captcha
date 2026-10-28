class_name SalvadorPontuacao
extends RefCounted

const score_file_path := "user://scores.csv"

var jogo_foi_salvo := false

var high_scores : Dictionary[String, Array] = {}

func _ler() -> void:
	for nome : String in high_scores.keys():
		print(nome, " : ", high_scores[nome])

func reset_novo_jogo() -> void:
	jogo_foi_salvo = false

# Load Scores
# -----------------------------------------------------------------------------

func get_scores() -> Dictionary[String, Array]:
	return high_scores

## pega do disco os scores salvos
func load_scores() -> void:
	var scores_file = FileAccess.open(score_file_path, FileAccess.READ)
	# erro se tiver 
	if scores_file == null:
		push_error("Error on readling file: " + score_file_path)
		return

	# pula header
	if not scores_file.eof_reached():
		scores_file.get_csv_line()

	# le linha por linha
	while not scores_file.eof_reached():
		var linha := scores_file.get_csv_line()
		# vazia
		if linha.size() <= 1: return
		# adiciona no highscore
		var linha_array := Array(linha)
		var nome : String = linha_array.pop_at(0)
		var dados : Array = linha_array.map(func(v): return int(v))
		high_scores[nome] = dados
	
	# fecha o arquivo
	scores_file.close()
	
	print("load")
	_ler()

# Salvar os pontos
# -----------------------------------------------------------------------------

func add_score(tempo_milis: int, nome_jogador: String) -> void:
	# se o jogo ja foi salvo, pare
	if jogo_foi_salvo: return
	# marca que o jogo foi salvo
	jogo_foi_salvo = true
	
	# salva o jogo
	high_scores[nome_jogador] = [tempo_milis, -1, -1]
	_salvar()

## Salva no disco
func _salvar():
	var scores_file = FileAccess.open(score_file_path, FileAccess.WRITE)
	# Erro na leitura
	if scores_file == null: 
		push_error("Error on readling file: " + score_file_path)
		return
	
	# Header
	scores_file.store_csv_line(["name", "millis", "minigames_completed","ads_viewd"])
	
	for nome : String in high_scores.keys():
		scores_file.store_csv_line([nome] + high_scores[nome])

	scores_file.close()
	
	print("store")
	_ler()
