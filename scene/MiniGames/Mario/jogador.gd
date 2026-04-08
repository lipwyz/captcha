extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = 400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		# animacoes de pulo e queda
		if (velocity.y > 0):
			animated_sprite_2d.play("falling")
		else:
			animated_sprite_2d.play("jumping")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if not is_zero_approx(direction):
		velocity.x = direction * SPEED
		# vira pro lado que o jogador esta indo
		animated_sprite_2d.flip_h = direction < 0
		# se estiver no chao, anim de corrida
		if is_on_floor(): animated_sprite_2d.play("running")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# se estiver no chao, anim de idle
		if is_on_floor(): animated_sprite_2d.play("idle")
	
	move_and_slide()
