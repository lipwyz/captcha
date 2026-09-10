extends ConteudoAba

@onready var mundo_dvd: DVDMundo = $SubViewportContainer/SubViewport/MundoDVD

func _ready() -> void:
	mundo_dvd.completo.connect(minigame_ganhar)
	mundo_dvd.click_errado.connect(minigame_errar)

## Detecta cliques dentro do conteudo da pagina, e envia para o mundo dvd
func _on_sub_viewport_container_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click_action"):
		mundo_dvd.mouse_click()
