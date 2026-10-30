class_name SalvadorPontuacao
extends RefCounted

const score_file_path := "user://scores.csv"
const score_file_header := ["name", "millis", "minigames_completed(nao implementado)","ads_viewd(nao implementado)"]

## High score [nome de jogador] -> lista de valores [tempo_ms, minigames, ads]
var high_scores : Dictionary[String, Array] = {}
## True se a ultima partida ja teve os dados salvos, nao salvar entao [br]
## False se ainda pode tentar salvar os dados, pode salvar[br]
## Serve para prevenir o jogador pedir para salvar multiplas vezes na mesma partida
var jogo_foi_salvo := false

## Reseta o jogo_foi_salvo, para indicar que pode salvar a partida atual [br]
## Deve ser chamado ao iniciar uma nova partida
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

# Salvar os pontos
# -----------------------------------------------------------------------------

## Adiciona no highscore o tempo em ms, para nome jogador [br]
## Retorna True se foi adicionado (melhorou o high score ou nao tinha) [br]
## False se nao houve atualizacao, ou seja nao foi adicionado o novo tempo
func add_score(tempo_milis: int, nome_jogador: String) -> bool:
	# se o jogo ja foi salvo, pare
	if jogo_foi_salvo: return false
	# marca que o jogo foi salvo
	jogo_foi_salvo = true
	
	# se ja tiver o nome do jogador
	if high_scores.has(nome_jogador):
		# verifica se eh melhor que o anterior,
		# so mantem o melhor score
		var tempo_antigo : int = high_scores[nome_jogador][0]
		# se o tempo for maior, nao salve
		if tempo_milis > tempo_antigo: 
			return false
	# salva o high score
	high_scores[nome_jogador] = [tempo_milis, -1, -1]
	_salvar()
	return true

## Salva no disco
func _salvar():
	var scores_file = FileAccess.open(score_file_path, FileAccess.WRITE)
	# Erro na leitura
	if scores_file == null: 
		push_error("Error on readling file: " + score_file_path)
		return
	
	# Header
	scores_file.store_csv_line(score_file_header)
	
	for nome : String in high_scores.keys():
		scores_file.store_csv_line([nome] + high_scores[nome])

	scores_file.close()
