extends CharacterBody2D

## Offset em [b]radianos[b] que vai ser adicionada ao [i]bounce[i][br]
## Aplicado como [code]randf_range(-qtd_angulo_offset, qtd_angulo_offset)[/code]
@export var qtd_angulo_offset := PI/16

@export var velocidade_inicial : float = 250

@export var velocidade_exponencial: float = 1.10

## [b]Durante o funny[/b] quantidade de vezes a mais que aumenta a velocidade
@export var funny_velocidade_exponencial_extra := 1.5
@export var funny_tempo_rapido := 2.0
@export var funny_tempo_decrescente := 1.5

var velocidade_atual : float = velocidade_inicial
var velocidade_vezes_aumentada : int = 0
var funny_velocidade_exponencial_extra_atual : float = 0.0

func _ready() -> void:
	# direcao inicial de (-180 a 180) - circulo completo
	velocity = Vector2(velocidade_inicial, 0).rotated(randf_range(-PI, PI))

func _physics_process(delta: float) -> void:
	var colisao := move_and_collide(velocity * delta)
	
	if Input.is_action_just_pressed("ui_up"): 
		aumentar_velocidade()
	
	# quando acontece uma colisao, continua o codigo
	if not colisao: return
	
	# bounce na direcao refletida da colisao
	var normal := colisao.get_normal()
	velocity = velocity.bounce(normal)
	
	# adiciona offset ao angulo de bounce
	var offset := randf_range(-qtd_angulo_offset, qtd_angulo_offset)
	velocity = velocity.rotated(offset)
	
	

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
