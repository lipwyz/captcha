class_name GerenciadorCutSceneInicial
extends Node

@export_group("CutScene")
@export var cena_cutscene: PackedScene
@export var cena_cutscene_2: PackedScene

func iniciar_cutscene(navegador: Navegador, area_trabalho: AreaTrabalho) -> void:	
	var aba_cutscene := Aba.criar_aba(
			"TwiXer",
			false,
			Aba.Estados.Idle,
			"TwiXer/forYou")
	navegador.add_aba(aba_cutscene, cena_cutscene)
	
	# TODO: inicar a cut scene
	var nav_cont = navegador.navegador_conteudo
	var teste_cutscene = nav_cont.conteudo_por_aba[aba_cutscene]
	#if teste_cutscene is TestCutScene:
		#aba_cutscene.clicada.connect(
			#func():
				#teste_cutscene.iniciar_cutscene()
		#)
	
	# -------------
	#var aba_cutscene_2 := Aba.criar_aba(
			#"TwiXer 2",
			#false,
			#Aba.Estados.Idle,
			#"TwiXer/forYou")
	#navegador.add_aba(aba_cutscene_2, cena_cutscene_2)
	#var teste_cutscene_2 = nav_cont.conteudo_por_aba[aba_cutscene_2]
	#aba_cutscene_2.clicada.connect(func(): teste_cutscene_2.iniciar_cutscene() )
	
	# Ajustar a aba inicial
	navegador.mudar_aba(aba_cutscene)
	
	# TODO: mudar essa inicializacao
	area_trabalho.click_navegador.connect(
		_iniciar_cutscene.bind(teste_cutscene, area_trabalho)
	)


func _iniciar_cutscene(teste_cutscene: TestCutScene, area_trabalho: AreaTrabalho) -> void:
	area_trabalho.click_navegador.disconnect(_iniciar_cutscene)
	#await get_tree().create_timer(0.2).timeout
	teste_cutscene.iniciar_cutscene()
