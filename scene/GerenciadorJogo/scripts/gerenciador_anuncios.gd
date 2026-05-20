class_name GerenciadorAnuncios
extends Node

signal anuncio_fechado

@export var anuncios_ref: Array[PackedScene]

var anuncios_sendo_mostrandos: Array = []

## Cria um anuncio para mostrar na tela
func spawnar_anuncio() -> void:
	anuncios_sendo_mostrandos.append('')
	# TODO: Criar o anuncio

## Fecha anuncio, e emite sinal anuncio_fechado
func fechar_anuncio() -> void:
	anuncios_sendo_mostrandos.erase('')
	anuncio_fechado.emit()
	# TODO: deletar o anuncio (ou fazer object pooling)

## Retona true sem tem anuncios sendo mostrados
func tem_anuncios_sendo_mostrados() -> bool:
	return not anuncios_sendo_mostrandos.is_empty()
