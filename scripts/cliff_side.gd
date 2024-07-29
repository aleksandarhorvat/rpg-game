extends Node2D

func _process(_delta):
	change_scene()

func _on_world_transition_point_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "cliff_side":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.finish_changes_scenes()
