class_name ListaMiniGamesRes
extends Resource

enum Dificuldade {FACIL, MEDIO, DIFICIL}

@export_group("Fáceis")
@export var lista_faceis: Array[MiniGameRes]

@export_group("Médios")
@export var lista_medios: Array[MiniGameRes]

@export_group("Difíceis")
@export var lista_dificeis: Array[MiniGameRes]

#var curr_index_faceis: int = 0
#var curr_index_medios: int = 0
#var curr_index_dificeis: int = 0
#
#func get_mini_game(dificuldade: Dificuldade) -> MiniGameRes:
	#var mini_game : MiniGameRes
	## pega um mini game da dificuldade correta
	#match (dificuldade):
		#Dificuldade.FACIL:
			#mini_game = lista_faceis.get(curr_index_faceis)
			#curr_index_faceis += 1
			#curr_index_faceis = curr_index_faceis % lista_faceis.size()
		#Dificuldade.MEDIO:
			#mini_game = lista_medios.get(curr_index_medios)
			#curr_index_medios += 1
			#curr_index_medios = curr_index_medios % lista_medios.size()
		#Dificuldade.DIFICIL:
			#mini_game = lista_dificeis.get(curr_index_dificeis)
			#curr_index_dificeis += 1
			#curr_index_dificeis = curr_index_dificeis % lista_dificeis.size()
	#
	#return mini_game
