extends Node2D

@export var mouse_warp: Node2D

func center_mouse_at_node(node: Node2D) -> void:
	# Make sure the viewport is ready
	await get_tree().process_frame  # Wait one frame
	
	# Get the global position of the node
	var target_global_pos = node.global_position
	
	# Convert to screen coordinates
	var screen_pos = get_viewport().canvas_transform * target_global_pos
	
	# Center the mouse cursor at that position
	Input.warp_mouse(screen_pos)
	
	# Debug: print the position to verify
	print("Warping mouse to: ", screen_pos)

func _ready() -> void:
	# Wait a bit to ensure everything is set up
	await get_tree().process_frame
	center_mouse_at_node(mouse_warp)
