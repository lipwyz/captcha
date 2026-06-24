extends CharacterBody2D

## Offset em [b]radianos[b] que vai ser adicionada ao [i]bounce[i][br]
## Aplicado como [code]randf_range(-qtd_angulo_offset, qtd_angulo_offset)[/code]
@export var qtd_angulo_offset := PI/16

@export var velocidade_inicial : float = 200

@export var velocidade_exponencial: float = 1.15

var velocidade_atual := velocidade_inicial
var velocidade_vezes_aumentada := 0

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
	velocidade_atual = velocidade_inicial ** (velocidade_exponencial ** velocidade_vezes_aumentada)
	
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
		var guarda_velocidade = velocidade_vezes_aumentada
		
		velocidade_vezes_aumentada += 2
		_update_velocidade()
		
		# espera uns 2 segundos e volta ao normal
		await get_tree().create_timer(2.0).timeout
		
		# diminui gradualmente
		for i in range(velocidade_vezes_aumentada, guarda_velocidade, -1):
			velocidade_vezes_aumentada = i
			_update_velocidade()
			await get_tree().create_timer(1.0).timeout
		
		# volta a velocidade correta
		velocidade_vezes_aumentada = guarda_velocidade
		_update_velocidade()
