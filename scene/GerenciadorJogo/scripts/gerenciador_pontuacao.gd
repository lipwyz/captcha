class_name GerenciadorPontuacao
extends Node

@export var cor_fim := Color.GREEN_YELLOW

@onready var label_tempo: Label = $%LabelTempo

var tempo_total_segundos : float = 0.0

var mini_games_ganhos : int
var anuncios_spawnados : int

func _ready() -> void:
	set_process(false)
	_atualizar_mostrar_tempo()

# Contagem da Run
# -----------------------------------------------------------------------------

## Inicia a contagem do tempo e outros marcadores dessa run
func iniciar_contagem() -> void:
	# contagem de tempo
	tempo_total_segundos = 0.0
	set_process(true)
	# outras metricas
	mini_games_ganhos = 0
	anuncios_spawnados = 0

## Para a contagem dessa run, pausando os valores
func parar_contagem() -> void:
	# contagem de tempo
	set_process(false)
	label_tempo.modulate = cor_fim

# Marcadores
# -----------------------------------------------------------------------------

## Marcar que ganhou um mini game
func marcar_ganhou_mini_game() -> void:
	mini_games_ganhos += 1

## Marca
func marcar_spawnou_anuncio() -> void:
	anuncios_spawnados += 1


# Tempo 
# -----------------------------------------------------------------------------

static func format_tempo_str(tempo_milis: int) -> String:
	# pega os mili segundos como int
	var milis : int = tempo_milis % 100
	
	# pega os segundos totais como int
	@warning_ignore("integer_division")
	var seg : int = floori(float(tempo_milis)/100)
	
	# calcula os minutos
	@warning_ignore("integer_division")
	var mins : int = floori(float(seg) / 60)
	
	# transforma os segundos para os mostrados dps dos minutos
	seg = seg % 60
	
	return "%02d:%02d:%02d" % [mins, seg, milis]

## Retorna o numero inteiro de milisegundos 
func get_tempo_milis() -> int:
	return floori(tempo_total_segundos * 100)

## Retorna String com formato do texto MM:SS:mm -> 00:00:00 ate 99:59:99
func get_str_tempo() -> String:
	return format_tempo_str(get_tempo_milis())

func _process(delta: float) -> void:
	tempo_total_segundos += delta

func _physics_process(_delta: float) -> void:
	_atualizar_mostrar_tempo()

func _atualizar_mostrar_tempo() -> void:
	# atualiza a label 
	label_tempo.text = get_str_tempo()
