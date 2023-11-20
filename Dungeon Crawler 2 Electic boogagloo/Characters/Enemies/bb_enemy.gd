extends CharacterBody2D

var speed = 50
var chasing_player = false
var player = null
var animation_player : AnimationPlayer

var idle_right : Sprite2D
var idle_left : Sprite2D
var walk_right : Sprite2D
var walk_left : Sprite2D

var running_right = false
var running_left = false

func _ready():
	idle_right = $idle_right
	idle_left = $idle_left
	walk_right = $walk_right
	walk_left = $walk_left
	animation_player = $AnimationPlayer

func _on_detection_area_body_entered(body):
	player = body
	chasing_player = true

func _on_detection_area_body_exited(body):
	player = null
	chasing_player = false

func _physics_process(delta):
	if chasing_player and player:
		var distance = position.distance_to(player.position)
		var stopping_distance = 15

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

			position += (player.position - position).normalized() * speed * delta

			if direction != 0:
				idle_right.visible = false
				idle_left.visible = false
				walk_right.visible = direction == 1
				walk_left.visible = direction == -1

				if direction == 1:
					animation_player.play("walk_right")
				else:
					animation_player.play("walk_left")
		else:
			chasing_player = false
			running_right = false
			running_left = false
			idle_right.visible = false
			idle_left.visible = false
			walk_left.visible = false
			walk_right.visible = false

			if player.position.x > position.x:
				idle_left.visible = false
				idle_right.visible = true
				animation_player.play("idle_right")
			else:
				idle_right.visible = false
				idle_left.visible = true
				animation_player.play("idle_left")
