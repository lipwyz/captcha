extends Node2D

@onready var mouse_trail_line: Line2D = $Line2D

var max_trail_points = 5
var point_distance_threshhold = 2.0
var mouse_still_timer = 0.0
var mouse_still_timeout = 0.25
var last_mouse_position: Vector2 = Vector2.INF

var can_play_slash_sound = true

var game_is_on = false
var score = 0

func _ready():
	mouse_trail_line.clear_points()
	$LabelTime.text = "Time: 20"

func _process(delta):
	var mouse_velocity = Input.get_last_mouse_velocity()
	var mouse_speed = mouse_velocity.length()
	
	print(mouse_speed)
	var current_mouse_position = get_global_mouse_position()
	
	if game_is_on == true:
		$LabelTime.text = "Time: " + str(roundi($TimerGameLength.time_left))
		$LabelScore.text = "Score: " + str(score)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and game_is_on == true:
		$Slash/CollisionShape2D.disabled = false
		$Slash.global_position = get_global_mouse_position()
		
		if mouse_speed >= 3000.0 and can_play_slash_sound:
			can_play_slash_sound = false
			$Slash/Sounds/AudioCooldown.start()
			
			var sound = randi_range(1,5)
			if sound == 1:
				$Slash/Sounds/Audio1.play()
			elif sound == 2:
				$Slash/Sounds/Audio2.play()
			elif sound == 3:
				$Slash/Sounds/Audio3.play()
			elif sound == 4:
				$Slash/Sounds/Audio4.play()
			elif sound == 5:
				$Slash/Sounds/Audio5.play()
		
		
		if last_mouse_position != Vector2.INF and current_mouse_position.distance_to(last_mouse_position) > 0.1:
			mouse_still_timer = 0.0
		else: 
			mouse_still_timer += delta
		
		if mouse_trail_line.get_point_count() == 0 or \
		mouse_trail_line.get_point_position(mouse_trail_line.get_point_count() - 1).distance_to(current_mouse_position) > point_distance_threshhold:
			mouse_trail_line.add_point(current_mouse_position)
		
		while mouse_trail_line.get_point_count() > max_trail_points:
			mouse_trail_line.remove_point(0)
		
		if mouse_still_timer >= mouse_still_timeout:
			mouse_trail_line.clear_points()
			mouse_still_timer = 0.0
			last_mouse_position = Vector2.INF
			
	else:
		mouse_trail_line.clear_points()
		mouse_still_timer = 0.0
		last_mouse_position = Vector2.INF
		$Slash/CollisionShape2D.disabled = true
	
	last_mouse_position = current_mouse_position
	

func _on_play_pressed() -> void:
	game_is_on = true
	$"../Play".disabled = true
	$"../Play".hide()
	$TimerGameLength.start()

func _on_timer_game_length_timeout() -> void:
	get_tree().reload_current_scene()

func _on_audio_cooldown_timeout() -> void:
	can_play_slash_sound = true
