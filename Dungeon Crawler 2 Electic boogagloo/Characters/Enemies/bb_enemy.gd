extends CharacterBody2D

signal enemy_attacking


var enemy_is_attacking = false



var speed = 50
var chasing_player = false
var player = null
var animation_player : AnimationPlayer

var idle_right : Sprite2D
var idle_left : Sprite2D
var walk_right : Sprite2D
var walk_left : Sprite2D
var atk_left : Sprite2D
var atk_right: Sprite2D

var running_right = false
var running_left = false
var temp_pos_x = null

var attack_distance_r : float
var attack_distance_l : float



func _ready():
	# Assign sprites and animation player on scene load
	idle_right = $idle_right
	idle_left = $idle_left
	walk_right = $walk_right
	walk_left = $walk_left
	atk_left = $atk_left
	atk_right = $atk_right
	animation_player = $AnimationPlayer
func _on_detection_area_body_entered(body):
	# Check if the entered body is a player, initiate chase
	player = body
	chasing_player = true
	

func _on_detection_area_body_exited(body):
	# Store the position.x of the body before it exits
	temp_pos_x = body.position.x
	player = null
	chasing_player = false
	walk_right.visible = false
	walk_left.visible = false
	atk_left.visible = false
	atk_right.visible = false
	# Determine which idle animation to play based on the stored position.x
	if temp_pos_x > position.x:
		idle_left.visible = false
		idle_right.visible = true
		animation_player.play("idle_right")
	elif temp_pos_x < position.x:
		idle_right.visible = false
		idle_left.visible = true
		animation_player.play("idle_left")

func _physics_process(delta): 
	if chasing_player and player:
		var distance = position.distance_to(player.position)
		var stopping_distance = 15
		atk_left.visible = false
		atk_right.visible = false
		enemy_is_attacking = false
		

		if distance > stopping_distance:
			var player_pos_x = player.position.x
			var direction = 0

			if player_pos_x > position.x and not running_right:
				direction = 1
				running_right = true
				running_left = false
			elif player_pos_x < position.x and not running_left:
				direction = -1
				running_left = true
				running_right = false

			# Move the enemy towards the player
			position += (player.position - position).normalized() * speed * delta

			if direction != 0:
				# Show appropriate walk animation
				idle_right.visible = false
				idle_left.visible = false
				walk_right.visible = direction == 1
				walk_left.visible = direction == -1

				if direction == 1:
					animation_player.play("walk_right")
				else:
					animation_player.play("walk_left")
		
		else:
			# Stop chasing, show appropriate idle animation
			
			running_right = false
			running_left = false
			idle_right.visible = false
			idle_left.visible = false
			walk_left.visible = false
			walk_right.visible = false
			atk_left.visible = false
			atk_right.visible = false

			if player.position.x > position.x: #If player is to the right
				attack_distance_r = abs(player.position.x - position.x)
				if attack_distance_r > stopping_distance:
					enemy_is_attacking = false
					idle_left.visible = false
					idle_right.visible = true
					animation_player.play("idle_right")
				elif attack_distance_r < stopping_distance:
					enemy_is_attacking = true
					emit_signal("enemy_attacking")
					atk_left.visible = false
					atk_right.visible = true
					animation_player.play("atk_right")
			else:
				attack_distance_l = abs(position.x - player.position.x)
				if attack_distance_l > stopping_distance:
					enemy_is_attacking = false
					idle_left.visible = true
					idle_right.visible = false
					animation_player.play("idle_left")
				elif attack_distance_l < stopping_distance:
					enemy_is_attacking = true
					emit_signal("enemy_attacking")
					atk_left.visible = true
					atk_right.visible = false
					animation_player.play("atk_left")


