extends ScoreBoard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	button_add_score.disconnect("pressed", _on_button_add_score_pressed)
	button_add_score.pressed.connect(_buscar_jogador)

func _buscar_jogador() -> void:
	var nome_jogador := line_edit_nome_score.text
	buscar_jogador(nome_jogador)

#const PASTA_BASE := GerenciadorGlobal.salvador_pontuacao.score_file_path
const PASTA_BASE := "user://"

func _on_button_pasta_pressed() -> void:
	DirAccess.make_dir_recursive_absolute(PASTA_BASE)
	var caminho_absoluto := ProjectSettings.globalize_path(PASTA_BASE)
	var erro := OS.shell_open(caminho_absoluto)
	if erro != OK:
		push_error("RegistradorPartida: não foi possível abrir a pasta (%s) - %s" % [caminho_absoluto, erro])
