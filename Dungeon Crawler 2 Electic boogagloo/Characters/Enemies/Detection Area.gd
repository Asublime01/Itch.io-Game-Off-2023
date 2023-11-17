extends Area2D

var speed = 400
var chasing_player = false
var player = null

func _physics_process(_delta):
	if chasing_player and player:
		position += (player.position - position).normalized() * speed * _delta

func _on_body_entered(body):
	print("Entered:", body.name)
	if body.is_in_group("player"):
		player = body
		chasing_player = true

func _on_body_exited(body):
	print("Exited:", body.name)
	if body == player:
		chasing_player = false
		player = null

