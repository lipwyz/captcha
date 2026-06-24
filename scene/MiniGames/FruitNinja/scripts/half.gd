extends CharacterBody2D

var gravity = 0.0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
