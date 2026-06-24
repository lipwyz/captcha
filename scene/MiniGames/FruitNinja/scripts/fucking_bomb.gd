extends CharacterBody2D

var direction_hit: String
var gravity = 300.0
@onready var bomb_timer: Timer = $BombTimer

func _ready():
	$WholeSprite/AnimationPlayer.play("RESET")

func _process(delta):
	rotation_degrees += 120 * delta

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("slash"):
		Engine.time_scale = 0.3
		bomb_timer.start()
		$"../AnimationPlayer".play("lose")
		$"..".score -= 5

func _on_bomb_timer_timeout() -> void:
	Engine.time_scale = 1.0
	queue_free()
