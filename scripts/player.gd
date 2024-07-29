extends CharacterBody2D

const speed = 100
var current_direction = "none"

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var healt = 200
var player_alive = true
var attack_ip = false

func _ready():
	var animation = $AnimatedSprite2D
	animation.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	play_attack_animation()
	current_camera()
	
	if healt <= 0:
		player_alive = false
		healt = 0
		print("Player has been killed")
		queue_free()
	
func player_movement(_delta):
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
			if !attack_ip:
				animation.play("side_idle")
	if dir == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if !attack_ip:
				animation.play("side_idle")
	if dir == "down":
		animation.flip_h = false
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			if !attack_ip:
				animation.play("front_idle")
	if dir == "up":
		animation.flip_h = false
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			if !attack_ip:
				animation.play("back_idle")

func play_attack_animation():
	var dir = current_direction
	var animation = $AnimatedSprite2D
	var timer = $deal_attack_timer
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			animation.flip_h = false
			animation.play("side_attack")
			timer.start()
		elif dir == "left":
			animation.flip_h = true
			animation.play("side_attack")
			timer.start()
		elif dir == "down":
			animation.flip_h = false
			animation.play("front_attack")
			timer.start()
		elif dir == "up":
			animation.flip_h = false
			animation.play("back_attack")
			timer.start()

func _on_deal_attack_timer_timeout():
	var timer = $deal_attack_timer
	timer.stop()
	global.player_current_attack = false
	attack_ip = false

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func player():
	pass

func enemy_attack():
	if enemy_in_attack_range && enemy_attack_cooldown:
		healt -= 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("Current healt: ", healt)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func current_camera():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$cliff_side_camera.enabled = false
	elif global.current_scene == "cliff_side":
		$world_camera.enabled = false
		$cliff_side_camera.enabled = true
