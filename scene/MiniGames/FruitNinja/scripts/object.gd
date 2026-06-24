extends CharacterBody2D

var direction_hit: String
var gravity = 300.0
var hit = false
var rotation_speed = 120.0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _process(delta):
	rotation_degrees += rotation_speed * delta

func _on_area_2d_horizontal_area_entered(area: Area2D) -> void:
	if area.is_in_group("slash") and hit == false:
		hit = true
		$WholeSprite.visible = false
		$Horizontal.visible = true
		$Horizontal/Half1.gravity = 100.0
		$Horizontal/Half2.gravity = 100.0
		
		await get_tree().create_timer(0.1).timeout
		
		var fruit_speed = 700
		$Horizontal/Half1.velocity = Vector2.UP.rotated($Horizontal/Half1.global_rotation) * fruit_speed
		$Horizontal/Half2.velocity = Vector2.DOWN.rotated($Horizontal/Half1.global_rotation) * fruit_speed
		$TimerDespawn.start()
		rotation_speed = 0
		$"..".score += 1
		
		var sound = randi_range(1,5)
		if sound == 1:
			$Sounds/Audio1.play()
		elif sound == 2:
			$Sounds/Audio2.play()
		elif sound == 3:
			$Sounds/Audio3.play()
		elif sound == 4:
			$Sounds/Audio4.play()
		elif sound == 5:
			$Sounds/Audio5.play()

func _on_area_2d_vertical_area_entered(area: Area2D) -> void:
	if area.is_in_group("slash") and hit == false:
		hit = true
		$WholeSprite.visible = false
		$Vertical.visible = true
		$Vertical/Half1.gravity = 100.0
		$Vertical/Half2.gravity = 100.0
		
		await get_tree().create_timer(0.1).timeout
		
		var fruit_speed = 700
		$Vertical/Half1.velocity = Vector2.LEFT.rotated($Vertical/Half1.global_rotation) * fruit_speed
		$Vertical/Half2.velocity = Vector2.RIGHT.rotated($Vertical/Half1.global_rotation) * fruit_speed
		$TimerDespawn.start()
		rotation_speed = 0
		$"..".score += 1
		
		var sound = randi_range(1,5)
		if sound == 1:
			$Sounds/Audio1.play()
		elif sound == 2:
			$Sounds/Audio2.play()
		elif sound == 3:
			$Sounds/Audio3.play()
		elif sound == 4:
			$Sounds/Audio4.play()
		elif sound == 5:
			$Sounds/Audio5.play()

func _on_area_2d_diagonal_45_area_entered(area: Area2D) -> void:
	if area.is_in_group("slash") and hit == false:
		hit = true
		$WholeSprite.visible = false
		$Diagonal45.visible = true
		$Diagonal45/Half1.gravity = 100.0
		$Diagonal45/Half2.gravity = 100.0
		
		await get_tree().create_timer(0.1).timeout
		
		var fruit_speed = 700
		$Diagonal45/Half1.velocity = Vector2.UP.rotated($Diagonal45/Half1.global_rotation + deg_to_rad(-45)) * fruit_speed
		$Diagonal45/Half2.velocity = Vector2.DOWN.rotated($Diagonal45/Half1.global_rotation + deg_to_rad(-45)) * fruit_speed
		$TimerDespawn.start()
		rotation_speed = 0
		$"..".score += 1
		
		var sound = randi_range(1,5)
		if sound == 1:
			$Sounds/Audio1.play()
		elif sound == 2:
			$Sounds/Audio2.play()
		elif sound == 3:
			$Sounds/Audio3.play()
		elif sound == 4:
			$Sounds/Audio4.play()
		elif sound == 5:
			$Sounds/Audio5.play()

func _on_area_2d_diagonal_315_area_entered(area: Area2D) -> void:
	if area.is_in_group("slash") and hit == false:
		hit = true
		$WholeSprite.visible = false
		$Diagonal315.visible = true
		$Diagonal315/Half1.gravity = 100.0
		$Diagonal315/Half2.gravity = 100.0
		
		await get_tree().create_timer(0.1).timeout
		
		var fruit_speed = 700
		$Diagonal315/Half1.velocity = Vector2.UP.rotated($Diagonal315/Half1.global_rotation + deg_to_rad(45)) * fruit_speed
		$Diagonal315/Half2.velocity = Vector2.DOWN.rotated($Diagonal315/Half1.global_rotation + deg_to_rad(45)) * fruit_speed
		$TimerDespawn.start()
		rotation_speed = 0
		$"..".score += 1
		
		var sound = randi_range(1,5)
		if sound == 1:
			$Sounds/Audio1.play()
		elif sound == 2:
			$Sounds/Audio2.play()
		elif sound == 3:
			$Sounds/Audio3.play()
		elif sound == 4:
			$Sounds/Audio4.play()
		elif sound == 5:
			$Sounds/Audio5.play()

func _on_timer_despawn_timeout() -> void:
	queue_free()

func _on_cut_delay_timer_timeout() -> void:
	pass 
