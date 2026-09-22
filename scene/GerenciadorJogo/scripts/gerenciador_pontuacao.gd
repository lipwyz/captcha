class_name GerenciadorPontuacao
extends Node

@onready var label_tempo: Label = $%LabelTempo

var tempo_total_segundos : float = 0.0

func _ready() -> void:
	set_process(false)
	_atualizar_mostrar_tempo()

func iniciar_contagem() -> void:
	print('iniciar_contagem')
	tempo_total_segundos = 0.0
	set_process(true)

func _process(delta: float) -> void:
	tempo_total_segundos += delta

func _physics_process(_delta: float) -> void:
	_atualizar_mostrar_tempo()

func _atualizar_mostrar_tempo() -> void:
	# pega os segundos totais como int
	var tempo_seg : int = floori(tempo_total_segundos)
	# calcula os minutos
	@warning_ignore("integer_division")
	var tempo_min : int = tempo_seg / 60
	# transforma os segundos para os mostrados dps dos minutos
	tempo_seg = tempo_seg % 60
	
	# atualiza a label 
	# formato do texto MM:SS -> 00:00 ate 99:59
	label_tempo.text = "%02d:%02d" % [tempo_min, tempo_seg]
