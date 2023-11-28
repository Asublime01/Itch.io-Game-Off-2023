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
var attack_cd = 2
var animation_player : AnimationPlayer
var player_attack_timer: Timer
var player_attack_cd: float = 1.5



func _ready():
	position = Vector2(512, 450)
	update_animation_params_player(starting_direction)
	animation_player = $AnimationPlayer
	player_attack_timer = Timer.new()
	player_attack_timer.wait_time = player_attack_cd
	player_attack_timer.one_shot = false
	add_child(player_attack_timer)

	
func  _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	update_animation_params_player(input_direction)
	velocity = input_direction * move_speed
	
	move_and_slide()
	pick_new_state()


func update_animation_params_player(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Attack/blend_position", move_input)

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
	if Input.is_key_pressed(KEY_SPACE):
		state_machine.travel("Attack")
		player_attack_timer.start()		
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
	print("Player health: ", player_health)
		

func _on_attack_timer_timeout():
	emit_signal("Player_Is_Attacking")
