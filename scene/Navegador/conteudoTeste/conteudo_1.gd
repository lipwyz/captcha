class_name Conteudo1
extends Control

func _on_button_pressed() -> void:
	var aba := Aba.criar_aba("Nova Aba", true, Aba.Estados.Idle, "https://teste/teste.com")
	var navegador := GameGerenciador.get_navegador()
	navegador.add_aba(aba)
	navegador.set_conteudo_aba(aba, load("res://scene/Navegador/conteudoTeste/Conteudo2.tscn"))
	
