extends Sprite2D

var initial_scale = Vector2(1, 1)
var shrink_speed = 1.2      # Scale units per second

func _ready():
	scale = initial_scale

func _process(delta):
	scale -= Vector2(shrink_speed, shrink_speed) * delta
	if scale.x <= 0:
		scale = Vector2.ZERO
