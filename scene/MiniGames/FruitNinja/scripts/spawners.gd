extends Node2D

var Obeject1 = preload("uid://cbpaq6lajx5p7")
var Obeject2 = preload("uid://bvp2s8560xoto")
var Obeject3 = preload("uid://vspu3i54gvf7")
var Obeject4 = preload("uid://j6ejlbd2q2xx")
var FuckingBomb = preload("uid://b1cuc330ayttm")

func _on_timer_timeout() -> void:
	if $"..".game_is_on == false:
		return
	var random = randi_range(1,7)
	var bomb_chance = randi_range(1,10)
	var object_instance
	
	if bomb_chance <= 2:
		object_instance = FuckingBomb.instantiate()
	else:
		var object = randi_range(1,4)
		if object == 1:
			object_instance = Obeject1.instantiate()
		elif object == 2:
			object_instance = Obeject1.instantiate()
		elif object == 3:
			object_instance = Obeject1.instantiate()
		elif object == 4:
			object_instance = Obeject1.instantiate()
	
	add_sibling(object_instance)
	var object_speed = 700
	if random == 1:
		object_instance.global_position = $Spawner1.global_position
		object_instance.velocity = Vector2.UP.rotated(object_instance.global_rotation + deg_to_rad(20)) * object_speed
	elif random == 2:
		object_instance.global_position = $Spawner2.global_position
		object_instance.velocity = Vector2.UP.rotated(object_instance.global_rotation + deg_to_rad(-10)) * object_speed
	elif random == 3:
		object_instance.global_position = $Spawner3.global_position
		object_instance.velocity = Vector2.UP.rotated(object_instance.global_rotation) * object_speed
	elif random == 4:
		object_instance.global_position = $Spawner4.global_position
		object_instance.velocity = Vector2.UP.rotated(object_instance.global_rotation + deg_to_rad(-10)) * object_speed
	elif random == 5:
		object_instance.global_position = $Spawner5.global_position
		object_instance.velocity = Vector2.UP.rotated(object_instance.global_rotation + deg_to_rad(-20)) * object_speed
	elif random == 6:
		object_instance.global_position = $Spawner6.global_position
		object_instance.velocity = Vector2.UP.rotated(object_instance.global_rotation + deg_to_rad(-80)) * object_speed
	elif random == 7:
		object_instance.global_position = $Spawner7.global_position
		object_instance.velocity = Vector2.UP.rotated(object_instance.global_rotation + deg_to_rad(80)) * object_speed
	
	
	
	
	
