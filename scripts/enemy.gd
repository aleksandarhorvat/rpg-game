extends CharacterBody2D

const speed = 35
var player_chase = false
var player = null
var current_direction = "none"

var healt = 100
var player_in_attack_range = false
var can_take_damage = true

func _ready():
	var animation = $AnimatedSprite2D
	animation.play("front_idle")

func _physics_process(delta):
	player_attack()
	if healt <= 0:
		healt = 0
		print("Enemy has been killed")
		queue_free()
	
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

func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false

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

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_range = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attack_range = false

func enemy():
	pass

func player_attack():
	if player_in_attack_range and global.player_current_attack:
		if can_take_damage:
			healt -= 20
			print("Current enemy healt: ", healt)
			$take_damage_cooldown.start()
			can_take_damage = false


func _on_take_damage_cooldown_timeout():
	can_take_damage = true
