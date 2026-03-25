class_name MiniGameRes
extends Resource

@export_group("Aba")
@export var aba_titulo : String
@export var aba_fechavel : bool
@export var aba_url : String = "https://site.com"
@export var aba_estado_inicial : Aba.Estados
@export_group("Conteudo")
@export var conteudo : PackedScene

func _init(_aba_titulo: String = "", 
			_aba_fechavel: bool = false,
			_aba_estado_inicial: Aba.Estados = Aba.Estados.Idle,
			_aba_url: String = "https://site.com",
			_conteudo : PackedScene = null) -> void:
	aba_titulo = _aba_titulo
	aba_fechavel = _aba_fechavel
	aba_estado_inicial = _aba_estado_inicial
	aba_url = _aba_url
	conteudo = _conteudo

func criar_aba() -> Aba:
	var aba = Aba.criar_aba(aba_titulo, aba_fechavel, aba_estado_inicial, aba_url)
	return aba

func navegador_add_mini_game(navegador : Navegador) -> void:
	var aba := criar_aba()
	navegador.add_aba(aba)
	navegador.set_conteudo_aba(aba, conteudo)
