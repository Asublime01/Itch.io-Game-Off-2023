extends CharacterBody2D

var speed = 50
var chasing_player = false
var player = null
var c_pos = null

func _on_detection_area_body_entered(body):
	player = body
	chasing_player = true

func _on_detection_area_body_exited(body):
	player = null
	chasing_player = false

func _physics_process(delta):
	if chasing_player and player:
		var distance = position.distance_to(player.position)

		# Set the stopping distance
		var stopping_distance = 15  # Adjust this value based on your preference

		# Check if the enemy is within the stopping distance
		if distance > stopping_distance:
			position += (player.position - position) / speed
		else:
			chasing_player = false

			
	
