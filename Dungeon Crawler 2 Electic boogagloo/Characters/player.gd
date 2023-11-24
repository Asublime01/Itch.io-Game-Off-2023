extends CharacterBody2D

@export var move_speed: float = 300
@export var starting_direction: Vector2 = Vector2(0, 0.5)
@export var player_health: float = 100
# parameters/Idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
var enemy_is_attacking = false
var is_not_detected = false


func _ready():
	position = Vector2(512, 450)
	update_animation_params_player(starting_direction)
	

	
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

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
		
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
	is_not_detected = check_detection_pos()
	if position == Vector2(512, 450):
		pass
	elif velocity != Vector2.ZERO: #player is moving
		pass
	elif velocity == Vector2.ZERO and is_not_detected: #player is not moving but hasn't been detected
		pass
	else:
		print("Enemy is attacking")


