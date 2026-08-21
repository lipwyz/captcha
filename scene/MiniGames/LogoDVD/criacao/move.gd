class_name DVDItemMovendo
extends CharacterBody2D

signal clicado 

## Offset em [b]radianos[/b] que vai ser adicionada ao [i]bounce[/i]
## para deixar mais aleatorio a movimentacao em vez de apenas espelhar o [i]bounce[/i][br]
## Aplicado como [code]randf_range(-qtd_angulo_offset, qtd_angulo_offset)[/code]
@export var qtd_angulo_offset := PI/16

## Velocidade inicial do item
@export var velocidade_inicial : float = 250

## O quanto a velocidade inicial vai ser elevada cada vez que fica mais rapida
@export var velocidade_exponencial: float = 1.10

## Multiplicador para aumentar o tamanho do hitbox ao aumentar a velocidade
@export var aumentar_hitbox_mult = 1.3

@export_group("Funny")
## [b]Durante o funny[/b] quantidade de vezes a mais que aumenta a velocidade
@export var funny_velocidade_exponencial_extra := 1.5
## [b]Durante o funny[/b] tempo em segundo que dura a velocidade aumentada
@export var funny_tempo_rapido := 2.0
## [b]Durante o funny[/b] tempo em segundo para gradualmente voltar a velocidade normal
@export var funny_tempo_decrescente := 1.5

@onready var collision_shape_2d_click: CollisionShape2D = $Area2DClick/CollisionShape2DClick

## Velocidade atual dos itens
var velocidade_atual : float = velocidade_inicial
## Quantidade de vezes que a velocidade eh aumentada
var velocidade_vezes_aumentada : int = 0
## Acumula o expoente da velocidade extra atualmente
var funny_velocidade_exponencial_extra_atual : float = 0.0

@onready var area_2d_click: Area2D = $Area2DClick

func _ready() -> void:
	# direcao inicial de (-180 a 180) - circulo completo
	velocity = Vector2(velocidade_inicial, 0).rotated(randf_range(-PI, PI))

# Movimentacao do Item
# -----------------------------------------------------------------------------

# move o item, e calcula as colisoes e bounces
func _physics_process(delta: float) -> void:	
	var colisao := move_and_collide(velocity * delta)
	
	# quando acontece uma colisao, continua o codigo
	if not colisao: return
	
	# bounce na direcao refletida da colisao
	var normal := colisao.get_normal()
	velocity = velocity.bounce(normal)
	
	# adiciona offset ao angulo de bounce
	var offset := randf_range(-qtd_angulo_offset, qtd_angulo_offset)
	velocity = velocity.rotated(offset)

## calcula e atualiza a velocidade do item
func _update_velocidade() -> void:
	var expon := velocidade_exponencial ** (
		velocidade_vezes_aumentada * 
		(1 + funny_velocidade_exponencial_extra_atual)
		)
	velocidade_atual = velocidade_inicial ** expon
	
	# normaliza (deixa em tamanho = 1)
	velocity = velocity.normalized()
	# acelera a velocidade
	velocity = velocity * velocidade_atual

## Aumenta a velocidade 
func aumentar_velocidade() -> void:
	velocidade_vezes_aumentada += 1
	_update_velocidade()
	
	# aumenta muito mais e devagar depois
	if (velocidade_vezes_aumentada > 1):
		funny()
		# aumenta o hitbox do botao
		_aumentar_hitbox_click()

## Faz o eveto divertido de aumentar muito a velocidade por alguns segundos
## (tempo dado por [code]funny_tempo_rapido[/code])
## [br] Seguido por diminuir a velocidade gradualmente (em [code]divisoes[/code])
## durante [code]funny_tempo_decrescente[/code]
func funny() -> void:
	# coloca a velocidade mais rapida
	funny_velocidade_exponencial_extra_atual = funny_velocidade_exponencial_extra
	_update_velocidade()
	
	# espera alguns segundos e volta antes de voltar ao normal
	await get_tree().create_timer(funny_tempo_rapido).timeout
	
	# diminui gradualmente
	const divisoes = 10
	@warning_ignore("integer_division")
	var subtracao := funny_velocidade_exponencial_extra_atual / divisoes
	var tempo := funny_tempo_decrescente / divisoes
	for i in range(divisoes):
		funny_velocidade_exponencial_extra_atual -= subtracao
		_update_velocidade()
		await get_tree().create_timer(tempo).timeout
	
	# volta a velocidade correta
	funny_velocidade_exponencial_extra_atual = 0

# Botao de Fechar do item
# -----------------------------------------------------------------------------

## Chamado ao clicar no botao de fechar do item
func _botao_clicado() -> void:
	clicado.emit()

## Aumenta de tamanho o hitbox de deteccao do click
func _aumentar_hitbox_click() -> void:
	collision_shape_2d_click.shape.size *= aumentar_hitbox_mult

## Verifica se o clique foi dentro do botao de fechar item
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click_action"):
		# pega as posicoes do mouse e da caixa (botao de fechar item)
		var mouse_position = get_global_mouse_position()
		var button_position = area_2d_click.global_position
		# area que o clique tem que ter para ser considerado dentro
		var dist 	 : Vector2 = mouse_position - button_position
		var box_size : Vector2 = collision_shape_2d_click.shape.size
		# se o clique foi dentro da caixa
		if abs(dist.x) < box_size.x and abs(dist.y) < box_size.y:
			_botao_clicado()

## !! NAO ESTA SENDO UTILIZADO MAIS !!
## Detecao de clique na area do botao
func _on_area_2d_click_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# se o evento for do tipo click do mouse
	if event is InputEventMouseButton:
		# se o click foi de apertar o botao do mouse (em vez de soltar)
		if event.is_pressed():
			_botao_clicado()
