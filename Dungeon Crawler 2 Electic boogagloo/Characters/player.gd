extends CharacterBody2D

signal Player_Is_Attacking


@export var move_speed: float = 300
@export var starting_direction: Vector2 = Vector2(0, 0.5)
@export var player_health: float = 100
# parameters/Idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
var enemy_is_attacking = false
var is_not_detected = false
var animation_player : AnimationPlayer
var player_is_attacking = false
var hurt_timer : Timer
var hurt_duration = 1.5 #Animation plays 3 times



func _ready():
	position = Vector2(512, 450)
	update_animation_params_player(starting_direction)
	animation_player = $AnimationPlayer
	hurt_timer = $HurtAnimationDuration
	
func  _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	update_animation_params_player(input_direction)
	velocity = input_direction * move_speed
	
	move_and_slide()
	pick_new_state()
	if player_health <= 0:
		get_tree().quit() #PLEASE change this to a transition into a game over scene Thanks!!

func update_animation_params_player(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Attack/blend_position", move_input)
		animation_tree.set("parameters/Hurt/blend_position", move_input)

func pick_new_state():
	player_is_attacking = false
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
	if Input.is_key_pressed(KEY_SPACE):
		state_machine.travel("Attack")
		emit_signal("Player_Is_Attacking")
		player_is_attacking = true
		
		
func check_detection_pos(): #Quadrants go left to right top down
	var firstQuad = true #Player is not in the quadrants
	var secondQuad = true
	var thirdQuad = true
	var fourthQuad = true
	
	if position.y <= 344 and position.y >= 59 and position.x > 368:
		firstQuad = false
	elif position.y <= 344 and position.y >= 59 and position.x < 938:
		secondQuad = false
	elif position.y >= 344 and position.y <= 629 and position.x > 368:
		thirdQuad = false
	elif position.y >= 344 and position.y <= 629 and position.x < 938:
		fourthQuad = false
	else:
		return true


func _on_bb_enemy_enemy_attacking():
	player_health -= 5
	print("Health: ", player_health)
	if not player_is_attacking:
		state_machine.travel("Hurt")
		state_machine.travel("Hurt")
		state_machine.travel("Hurt")
		hurt_timer.start(hurt_duration)
	elif player_is_attacking:
		state_machine.travel("Hurt Attack")
		state_machine.travel("Hurt Attack")
		state_machine.travel("Hurt Attack")
		hurt_timer.start(hurt_duration)
	else:
		return




func _on_hurt_animation_duration_timeout():
	state_machine.travel("Idle")
