extends ConteudoAba

@onready var mundo_dvd: DVDMundo = $SubViewportContainer/SubViewport/MundoDVD

func _ready() -> void:
	mundo_dvd.completo.connect(minigame_ganhar)
	mundo_dvd.anuncio.connect(minigame_errar)
