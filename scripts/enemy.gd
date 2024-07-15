extends CharacterBody2D

const speed = 35
var player_chase = false
var player = null
var current_direction = "none"

func _physics_process(delta):
	if player_chase:
		##chages the speed of enemy
		velocity = (player.get_global_position() - position).normalized() * speed * delta
		##changes the animation of enemy
		if abs(player.get_position().y - position.y) > abs(player.get_position().x - position.x):
			if (player.get_position().y - position.y) < 0:
				current_direction = "up"
			elif (player.get_position().y - position.y) > 0:
				current_direction = "down"
		else:
			if (player.get_position().x - position.x) < 0:
				current_direction = "left"
			elif (player.get_position().x - position.x) > 0:
				current_direction = "right"
		play_animation(1)
	else:
		##decreases the speed of enemy
		velocity = lerp(velocity, Vector2.ZERO, 0.07)
		play_animation(0)
	move_and_collide(velocity);

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_direction = "right"
		play_animation(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		play_animation(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_direction = "down"
		play_animation(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_direction = "up"
		play_animation(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0
	move_and_slide()

func play_animation(movement):
	var dir = current_direction
	var animation = $AnimatedSprite2D
	
	if dir == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			animation.play("side_idle")
	if dir == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			animation.play("side_idle")
	if dir == "down":
		animation.flip_h = false
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			animation.play("front_idle")
	if dir == "up":
		animation.flip_h = false
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			animation.play("back_idle")
