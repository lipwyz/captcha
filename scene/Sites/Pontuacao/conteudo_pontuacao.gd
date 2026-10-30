class_name ConteudoPontuacao
extends ConteudoAba

@onready var label_tempo_valor: Label = %LabelTempoValor
@onready var label_minigames_valor: Label = %LabelMinigamesValor
@onready var label_ads_valor: Label = %LabelAdsValor

## Passa o tempo como String
func set_tempo(tempo_str: String) -> void:
	label_tempo_valor.text = tempo_str

func set_minigames(minigames_valor: int) -> void:
	label_minigames_valor.text = str(minigames_valor)

func set_ads(ads_valor: int) -> void:
	label_ads_valor.text = str(ads_valor)
