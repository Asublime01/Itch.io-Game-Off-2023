extends CharacterBody2D

@export var move_speed: float = 300
@export var starting_direction: Vector2 = Vector2(0, 0.5)
@export var player_health: float = 100
# parameters/Idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")


func _ready():
	position = Vector2(512, 450)
	update_animation_params_player(starting_direction)
	connect("attack_state_changed", _on_bb_enemy_attack_state_changed)
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



func _on_bb_enemy_attack_state_changed(is_attacking):
	if is_attacking:
		print("enemy is attacking!!!!!")
	else:
		print("Enemy stopped attacking.")
