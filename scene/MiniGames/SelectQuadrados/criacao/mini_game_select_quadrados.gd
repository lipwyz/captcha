extends ConteudoAba

@export var gerenciador_imagem : GerenciadorImagemClicavel

func _ready() -> void:
	gerenciador_imagem.concluido.connect(terminar)
