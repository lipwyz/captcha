class_name Conteudo1
extends ConteudoAba

const CONTEUDO_2_REF = "uid://dvanu1sh6khfa"

func _on_button_pressed() -> void:
	var aba := Aba.criar_aba("Nova Aba", true, Aba.Estados.Idle, "https://teste/teste.com")
	var navegador := GameGerenciador.get_navegador()
	navegador.add_aba(aba, load(CONTEUDO_2_REF))
