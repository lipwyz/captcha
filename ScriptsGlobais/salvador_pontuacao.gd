class_name SalvadorPontuacao
extends RefCounted

var jogo_foi_salvo := false

# Load Scores
# -----------------------------------------------------------------------------

## pega do disco os scores salvos
func load_scores() -> Dictionary:
	var scores_file = FileAccess.open("user://scores.csv", FileAccess.READ)
	return {}
	#var highscores : Dictionary[String, String] = {}
	#for linha: String in scores_file.get_csv_line():
		#var nome : String = linha[0]
		#var tempo : String = linha[1]
		#highscores[nome] = tempo
	#return {}

# Salvar os pontos
# -----------------------------------------------------------------------------

func add_score(tempo_milis: int, nome_jogador: String) -> void:
	# se o jogo ja foi salvo, pare
	if jogo_foi_salvo: return
	# marca que o jogo foi salvo
	jogo_foi_salvo = true
	
	# salva o jogo
	

## Salva no disco
func _salvar():
	var scores_file = FileAccess.open("user://scores.csv", FileAccess.WRITE)
	scores_file.store_csv_line("json_string, a")
